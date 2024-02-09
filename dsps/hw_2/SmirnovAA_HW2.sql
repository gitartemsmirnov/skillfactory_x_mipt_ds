/* Выводим все уникальные бренды, у которых стандартная 
 * стоимость выше 1500 долларов. */
SELECT DISTINCT brand
FROM "transaction" t
WHERE standard_cost > 1500;


/* Выводим все подтвержденные транзакции за период 
 * '2017-04-01' по '2017-04-09' включительно */
SELECT *
FROM "transaction" t
WHERE TO_DATE(transaction_date, 'DD.MM.YYYY') BETWEEN '2017-04-01' AND '2017-04-09'
  AND order_status = 'Approved';

/* Выводим все профессии у клиентов из сферы IT или 
 * Financial Services, которые начинаются с фразы 'Senior'.
 * Под 'всеми профессиями' понимаем уникальные должности, начинающиеся
 * с 'Senior' в указанных отраслях.*/
SELECT DISTINCT job_title
FROM "customer" c
WHERE job_industry_category IN ('IT', 'Financial Services') AND job_title LIKE 'Senior%';

/* Выводим все бренды, которые закупают клиенты, 
 * работающие в сфере Financial Services */
SELECT DISTINCT t.brand
FROM "transaction" t 
JOIN customer c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'Financial Services';

/* Выводим 10 клиентов, которые оформили онлайн-заказ 
 * продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'. 
 * Исходим из того, что под клиентом понимается customer_id. Если для описания
 * клиента понадобятся атрибуты из таблицы customer, то их можно вывести,
 * объединив таблицы*/
SELECT customer_id
FROM "transaction" t 
WHERE brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles') AND online_order IS TRUE
LIMIT 10;

/* Выводим всех клиентов, у которых нет транзакций. 
 * Исходим из того, что под клиентом понимается customer_id. При необходимости
 * иные поля из таблицы customer можно вывести, добавив их в SELECT с
 * использованием alias 'с'. Под 'всех' в контексте задания
 * понимаем всех уникальных клиентов*/
SELECT c.customer_id
FROM "customer" c 
LEFT JOIN "transaction" t ON c.customer_id = t.customer_id
WHERE t.customer_id IS NULL;

/* Выводим всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
 * Исходим из того, что под клиентом понимается customer_id. При необходимости
 * иные поля из таблицы customer можно вывести, добавив их в SELECT с
 * использованием alias 'с'. Под 'всех' в контексте задания
 * понимаем всех уникальных клиентов*/
SELECT DISTINCT c.customer_id
FROM "customer" c 
JOIN "transaction" t ON t.customer_id = c.customer_id 
WHERE c.job_industry_category = 'IT' AND t.standard_cost = (
	SELECT MAX(standard_cost) FROM "transaction");

/* Выводим всех клиентов из сферы IT и Health, у которых есть подтвержденные 
 * транзакции за период '2017-07-07' по '2017-07-17'
 * Исходим из того, что под клиентом понимается customer_id. При необходимости
 * иные поля из таблицы customer можно вывести, добавив их в SELECT с
 * использованием alias 'с'. Под 'всех' в контексте задания
 * понимаем всех уникальных клиентов*/
SELECT DISTINCT t.customer_id
FROM "transaction" t 
JOIN customer c ON t.customer_id = c.customer_id 
WHERE c.job_industry_category IN ('IT', 'Health') AND
(TO_DATE(transaction_date, 'DD.MM.YYYY')
	BETWEEN '2017-07-07' AND '2017-07-17')
	AND order_status = 'Approved';