# python -m luigi --module extractor FinalizeDataset --dataset-name GSE68849 --local-scheduler

import luigi
import os
import requests
import tarfile
import pandas as pd
import io
import gzip
import shutil

class DownloadDataset(luigi.Task):
    dataset_name = luigi.Parameter(default="GSE68849")

    def output(self):
        return luigi.LocalTarget(f"data/{self.dataset_name}/{self.dataset_name}_RAW.tar")

    def run(self):
        url = f"https://www.ncbi.nlm.nih.gov/geo/download/?acc={self.dataset_name}&format=file"
        os.makedirs(os.path.dirname(self.output().path), exist_ok=True)
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            with open(self.output().path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)

class ExtractAndOrganizeFiles(luigi.Task):
    dataset_name = luigi.Parameter(default="GSE68849")

    def requires(self):
        return DownloadDataset(self.dataset_name)

    def output(self):
        return luigi.LocalTarget(f"data/{self.dataset_name}/extracted")

    def run(self):
        os.makedirs(self.output().path, exist_ok=True)
        tar_path = self.input().path

        with tarfile.open(tar_path, "r") as tar:
            for member in tar.getmembers():
                member_path = os.path.join(self.output().path, member.name)
                tar.extract(member, path=self.output().path)
                if member.name.endswith('.gz'):
                    with gzip.open(member_path, 'rb') as f_in:
                        with open(member_path[:-3], 'wb') as f_out:
                            shutil.copyfileobj(f_in, f_out)
                    os.remove(member_path)

class ProcessFiles(luigi.Task):
    dataset_name = luigi.Parameter(default="GSE68849")

    def requires(self):
        return ExtractAndOrganizeFiles(self.dataset_name)

    def output(self):
        return luigi.LocalTarget(f"data/{self.dataset_name}/processed")

    def run(self):
        os.makedirs(self.output().path, exist_ok=True)
        extracted_dir = self.input().path

        for root, dirs, files in os.walk(extracted_dir):
            for file in files:
                if file.endswith(".txt"):
                    file_path = os.path.join(root, file)
                    dfs = {}
                    with open(file_path) as f:
                        write_key = None
                        fio = io.StringIO()
                        for line in f:
                            if line.startswith('['):
                                if write_key:
                                    fio.seek(0)
                                    header = None if write_key == 'Heading' else 'infer'
                                    dfs[write_key] = pd.read_csv(fio, sep='\t', header=header)
                                    table_dir = os.path.join(self.output().path, write_key)
                                    os.makedirs(table_dir, exist_ok=True)
                                    dfs[write_key].to_csv(os.path.join(table_dir, f"{write_key}.tsv"), sep='\t', index=False)
                                fio = io.StringIO()
                                write_key = line.strip('[]\n')
                                continue
                            if write_key:
                                fio.write(line)
                        if write_key:
                            fio.seek(0)
                            dfs[write_key] = pd.read_csv(fio, sep='\t', header=header)
                            table_dir = os.path.join(self.output().path, write_key)
                            os.makedirs(table_dir, exist_ok=True)
                            dfs[write_key].to_csv(os.path.join(table_dir, f"{write_key}.tsv"), sep='\t', index=False)

                    if 'Probes' in dfs:
                        reduced_columns = ['Definition', 'Ontology_Component', 'Ontology_Process', 'Ontology_Function', 'Synonyms', 'Obsolete_Probe_Id', 'Probe_Sequence']
                        reduced_df = dfs['Probes'].drop(columns=reduced_columns, errors='ignore')
                        reduced_table_dir = os.path.join(self.output().path, 'Probes')
                        reduced_df.to_csv(os.path.join(reduced_table_dir, "Probes_reduced.tsv"), sep='\t', index=False)

class FinalizeDataset(luigi.Task):
    dataset_name = luigi.Parameter(default="GSE68849")

    def requires(self):
        return ProcessFiles(self.dataset_name)

    def run(self):

        extracted_path = f"data/{self.dataset_name}/extracted"
        shutil.rmtree(extracted_path, ignore_errors=True)


if __name__ == '__main__':
    luigi.run()
