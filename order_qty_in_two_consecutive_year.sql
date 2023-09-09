CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE orders (
	order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    purchase_date DATETIME NOT NULL
);

INSERT INTO orders VALUES(1, 1, 6, '2022-07-25 00:00:00');
INSERT INTO orders VALUES(2, 1, 7, '2022-07-26 00:00:00');
INSERT INTO orders VALUES(3, 1, 4, '2022-07-27 00:00:00');
INSERT INTO orders VALUES(4, 1, 8, '2021-08-20 00:00:00');
INSERT INTO orders VALUES(5, 1, 1, '2021-09-29 00:00:00');
INSERT INTO orders VALUES(6, 2, 4, '2022-07-30 00:00:00');
INSERT INTO orders VALUES(7, 3, 1, '2022-07-31 00:00:00');
INSERT INTO orders VALUES(8, 4, 1, '2022-08-01 00:00:00');
INSERT INTO orders VALUES(9, 4, 2, '2022-08-02 00:00:00');
INSERT INTO orders VALUES(10, 4, 2, '2022-08-03 00:00:00');
INSERT INTO orders VALUES(29, 1, 2, '2021-09-04 00:00:00');
INSERT INTO orders VALUES(31, 2, 1, '2022-09-05 00:00:00');
INSERT INTO orders VALUES(40, 2, 20, '2021-09-03 00:00:00');
INSERT INTO orders VALUES(44, 1, 8, '2021-09-07 00:00:00');
INSERT INTO orders VALUES(45, 1, 9, '2021-09-08 00:00:00');
INSERT INTO orders VALUES(46, 3, 10, '2022-08-31 00:00:00');
INSERT INTO orders VALUES(51, 1, 6, '2021-05-21 00:00:00');

-- Write a query to report the IDs of all the products that were ordered three or more times in two consecutive years.

SELECT product_id
FROM (
	SELECT *, 
			LEAD(curr_year) OVER(PARTITION BY product_id ORDER BY curr_year) - curr_year AS year_diff
	FROM (
		SELECT product_id, YEAR(purchase_date) AS curr_year
		FROM orders
		GROUP BY 1, 2
		HAVING COUNT(order_id) >= 3
		ORDER BY 1, 2
	) o1
) o2
WHERE year_diff = 1;