/*
Подробное описание структы базы данных см. в README.md
Создаем таблицы для базы данных
*/

CREATE TABLE "transaction" (
  "id" serial PRIMARY KEY,
  "product_id" int4,
  "customer_id" int4,
  "transaction_date" varchar(30),
  "online_order" varchar(30),
  "order_status" varchar(30),
  "list_price" float4 NOT NULL,
  "standard_cost" float4
);

CREATE TABLE "product" (
  "id" serial PRIMARY KEY,
  "product_id" int4,
  "brand" varchar(30),
  "product_line" varchar(30),
  "product_class" varchar(30),
  "product_size" varchar(30),
  CONSTRAINT composite_key
    UNIQUE ("product_id", "brand", "product_line", "product_class", "product_size")
);


CREATE TABLE "customer" (
  "id" serial PRIMARY KEY,
  "first_name" varchar(50),
  "last_name" varchar(50),
  "gender" varchar(30),
  "dob" varchar(50),
  "job_title" varchar(50),
  "job_industry_category" varchar(50),
  "wealth_segment" varchar(50),
  "deceased_indicator" varchar(50),
  "owns_car" varchar(30),
  "property_valuation" int4
);

CREATE TABLE "customer_address" (
  "customer_id" int,
  "address_id" int
);

CREATE TABLE "address" (
  "id" serial PRIMARY KEY,
  "address" varchar,
  "postcode" varchar,
  "state" varchar,
  "country" varchar
);

ALTER TABLE "transaction" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id");

ALTER TABLE "transaction" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("id");

ALTER TABLE "customer_address" ADD FOREIGN KEY ("customer_id") REFERENCES "customer" ("id");

ALTER TABLE "customer_address" ADD FOREIGN KEY ("address_id") REFERENCES "address" ("id");


INSERT INTO "product" (product_id, brand, product_line, product_class, product_size)
VALUES
	()
INSERT INTO "transaction" (product_id, customer_id, transaction_date, online_order, order_status, list_price, standard_cost)
INSERT INTO "transaction" (product_id, customer_id, transaction_date, online_order, order_status, list_price, standard_cost)


INSERT INTO customer (first_name, last_name, gender, dob, job_title, job_industry_category, wealth_segment, deceased_indicator, owns_car, property_valuation)
VALUES ('Laraine', 'Medendorp', 'F', '1953-10-12', 'Executive Secretary', 'Health', 'Mass Customer', 'N', 'Yes', 10);

INSERT INTO customer (first_name, last_name, gender, dob, job_title, job_industry_category, wealth_segment, deceased_indicator, owns_car, property_valuation)
VALUES
	('Laraine', 'Medendorp', 'F', '1953-10-12', 'Executive Secretary', 'Health', 'Mass Customer', 'N', 'Yes', 10),
	('Eli', 'Bockman', 'Male', '1980-12-16', 'Administrative Officer', 'Financial Services', 'Mass Customer', 'N', 'Yes', 10),
	('Arlin', 'Dearle', 'Male', '1954-01-20', 'Recruiting Manager', 'Property', 'Mass Customer', 'N', 'Yes', 9),
	('Talbot', NULL, 'Male', '1961-10-03', NULL, 'IT', 'Mass Customer', 'N', 'No', '4'),
	('Sheila-kathryn', 'Calton', 'Female', '1977-05-13', 'Senior Editor', 'n/a', 'Affluent Customer', 'N', 'Yes', 9),
	('Curr', 'Duckhouse', 'Male', '1966-09-16', NULL, 'Retail', 'High Net Worth', 'N', 'Yes', '9'),
	('Fina', 'Merali', 'Female', '1976-02-23', NULL, 'Financial Services', 'Affluent Customer', 'N', 'Yes', 4),
	('Rod', 'Inder', 'Male', '1962-03-30', 'Media Manager I', 'n/a', 'Mass Customer', 'N', 'No', 12),
	('Mala', 'Lind', 'Female', '1973-03-10', 'Business Systems Development Analyst', 'Argiculture', 'Affluent Customer', 'N', 'Yes', 8),
	('Fiorenze', 'Birdall', 'Female', '1988-10-11', 'Senior Quality Engineer', 'Financial Services', 'Mass Customer', 'N', 'Yes', 4);
