/*
 * Выводим распределение (количество) клиентов по сферам деятельности,
 * отсортировав результат по убыванию количества.
*/
SELECT job_industry_category, COUNT(customer_id) AS num_of_customers
FROM customer c
GROUP BY job_industry_category
ORDER BY num_of_customers DESC;

/*
 * Находим сумму транзакций за каждый месяц по сферам деятельности,
 * отсортировав по месяцам и по сфере деятельности.
 */

SELECT EXTRACT(MONTH FROM TO_DATE(t.transaction_date, 'DD.MM.YYYY')) AS month
	,c.job_industry_category
	,SUM(t.list_price)
FROM "transaction" t
JOIN "customer" c ON t.customer_id = c.customer_id
GROUP BY c.job_industry_category, EXTRACT(MONTH FROM TO_DATE(t.transaction_date, 'DD.MM.YYYY'))
ORDER BY month, c.job_industry_category;

/*
 * Выводим количество онлайн-заказов для всех брендов в рамках
 * подтвержденных заказов клиентов из сферы IT.
 */
 SELECT t.brand
 	,COUNT(*) AS online_orders_approved
 FROM "transaction" t
 JOIN "customer" c ON c.customer_id = t.customer_id
 GROUP BY t.brand, t.online_order, t.order_status, c.job_industry_category
 HAVING t.online_order = 'True'
		AND t.order_status = 'Approved'
		AND c.job_industry_category = 'IT';

/*
 * Находим по всем клиентам сумму всех транзакций (list_price), максимум,
 * минимум и количество транзакций, отсортировав результат по убыванию
 * суммы транзакций и количества клиентов.
 */

-- Первый способ. Запрос с использованием GROUP BY
SELECT t.customer_id
	,SUM(t.list_price) AS total_amount
	,MAX(t.list_price) AS max_transaction
	,MIN(t.list_price) AS min_transaction
	,COUNT(t.list_price) AS transaction_count
FROM "transaction" t
GROUP BY t.customer_id
ORDER BY total_amount DESC, transaction_count DESC;

-- Второй способ. Запрос с использованием только оконных функций
SELECT DISTINCT t.customer_id
    ,SUM(t.list_price) OVER (PARTITION BY t.customer_id) AS total_amount
    ,MAX(t.list_price) OVER (PARTITION BY t.customer_id) AS max_transaction
    ,MIN(t.list_price) OVER (PARTITION BY t.customer_id) AS min_transaction
    ,COUNT(*) OVER (PARTITION BY t.customer_id) AS transaction_count
FROM
    "transaction" t
ORDER BY
    total_amount DESC, transaction_count DESC;

/* Находим имена и фамилии клиентов с минимальной/максимальной суммой транзакций
 * за весь период (сумма транзакций не может быть null). Пишем отдельные запросы
 * для минимальной и максимальной суммы.
 */

-- Выводим имена и фамилии клиентов с минимальной суммой транзакций
SELECT c.first_name, c.last_name
FROM "customer" c
JOIN "transaction" t ON c.customer_id  = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(t.list_price) = (
       	SELECT MIN(total_amount)
        FROM (SELECT SUM(list_price) AS total_amount
            FROM transaction
            GROUP BY customer_id) AS min_amount);

-- Выводим имена и фамилии клиентов с максимальной суммой транзакций
SELECT c.first_name, c.last_name
FROM "customer" c
JOIN "transaction" t ON c.customer_id  = t.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(t.list_price) = (
       	SELECT MAX(total_amount)
        FROM (SELECT SUM(list_price) AS total_amount
            FROM transaction
            GROUP BY customer_id) AS max_amount);

/*
 * Выводим только самые первые транзакции клиентов.
 * Решение с помощью оконных функций.
 */
SELECT DISTINCT t.customer_id
	,FIRST_VALUE (transaction_id) OVER (
	PARTITION BY customer_id ORDER BY TO_DATE(transaction_date, 'dd.mm.yyyy')
	) AS first_transaction
FROM "transaction" t;

/*
 * Выводим имена, фамилии и профессии клиентов, между транзакциями которых был
 * максимальный интервал (интервал вычисляется в днях)
 */
WITH transaction_delta AS
(SELECT customer_id, MAX(delta) AS max_delta
FROM
(SELECT t.customer_id, TO_DATE(transaction_date, 'dd.mm.yyyy'), lead(TO_DATE(transaction_date, 'dd.mm.yyyy')) over(PARTITION BY t.customer_id)
,lead(TO_DATE(transaction_date, 'dd.mm.yyyy')) over(PARTITION BY t.customer_id
ORDER BY TO_DATE(transaction_date, 'dd.mm.yyyy')) - TO_DATE(transaction_date, 'dd.mm.yyyy') AS delta
FROM "transaction" t) AS a
GROUP BY customer_id)

SELECT c.first_name, c.last_name, c.job_title
FROM customer c
JOIN transaction_delta td ON td.customer_id = c.customer_id
WHERE td.max_delta = (SELECT MAX(max_delta) from transaction_delta)
