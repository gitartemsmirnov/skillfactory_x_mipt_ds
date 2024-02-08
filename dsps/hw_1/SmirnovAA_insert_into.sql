/*
Подробное описание структуры базы данных см. в README.md
Вставляем первые десять строк каждой из двух исходных таблиц.
Для удобства заполнения через вставку ограничений по внешним ключам не создавалось.
ВНИМАНИЕ: product_id таблицы transaction является внешним ключом для id таблицы  product
(НЕ для product_id таблицы product)
*/

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


INSERT INTO address (address, postcode, state, country)
VALUES
	('060 Morning Avenue', '2016', 'New South Wales', 'Australia'),
	('6 Meadow Vale Court', '2153', 'New South Wales', 'Australia'),
	('0 Holy Cross Court', '4211', 'QLD', 'Australia'),
	('17979 Del Mar Point', '2448', 'New South Wales', 'Australia'),
	('9 Oakridge Court', '3216', 'VIC', 'Australia'),
	('4 Delaware Trail', '2210', 'New South Wales', 'Australia'),
	('49 Londonderry Lane', '2650', 'New South Wales', 'Australia'),
	('97736 7th Trail', '2023', 'New South Wales', 'Australia'),
	('93405 Ludington Park', '3044', 'VIC', 'Australia'),
	('44339 Golden Leaf Alley', '4557', 'QLD', 'Australia');

INSERT INTO customer_address (customer_id, address_id)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10);

INSERT INTO "product" (product_id, brand, product_line, product_class, product_size)
VALUES
	(2, 'Solex', 'Standard', 'medium', 'medium'),
	(3, 'Trek Bicycles', 'Standard', 'medium', 'large'),
	(37, 'OHM Cycles', 'Standard', 'low', 'medium'),
	(88, 'Norco Bicycles', 'Standard', 'medium', 'medium'),
	(78, 'Giant Bicycles', 'Standard', 'medium', 'large'),
	(25, 'Giant Bicycles', 'Road', 'medium', 'medium'),
	(22, 'WeareA2B', 'Standard', 'medium', 'medium'),
	(15, 'WeareA2B', 'Standard', 'medium', 'medium'),
	(67, 'Solex', 'Standard', 'medium', 'large'),
	(12, 'WeareA2B', 'Standard', 'medium', 'medium');

INSERT INTO "transaction" (product_id, customer_id, transaction_date, online_order, order_status, list_price, standard_cost)
VALUES
	(1, 2950, '25.02.2017', 'False', 'Approved', 71.49, 53.62),
	(2, 3120, '21.05.2017', 'True', 'Approved', 2091.47, 388.92),
	(3, 402, '16.10.2017', 'False', 'Approved', 1793.43, 248.82),
	(4, 3135, '31.08.2017', 'False', 'Approved', 1198.46, 381.10),
	(5, 787, '01.10.2017', 'True', 'Approved', 1765.3, 709.48),
	(6, 2339, '08.03.2017', 'True', 'Approved', 1538.99, 829.65),
	(7, 1542, '21.04.2017', 'True', 'Approved', 60.34, 45.26),
	(8, 2459, '15.07.2017', 'False', 'Approved', 1292.84, 13.44),
	(9, 1305, '10.08.2017', 'False', 'Approved', 1071.23, 380.74),
	(10, 3262, '30.08.2017', 'True', 'Approved', 1231.15, 161.60);
