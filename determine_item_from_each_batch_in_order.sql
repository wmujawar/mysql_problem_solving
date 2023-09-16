USE practice;

DROP TABLE IF EXISTS batch;
DROP TABLE IF EXISTS orders;

CREATE TABLE batch (batch_id varchar(10), quantity integer);
CREATE TABLE orders (order_number varchar(10), quantity integer);


INSERT INTO batch VALUES ('B1', 5);
INSERT INTO batch VALUES ('B2', 12);
INSERT INTO batch VALUES ('B3', 8);

INSERT INTO orders VALUES ('O1', 2);
INSERT INTO orders VALUES ('O2', 8);
INSERT INTO orders VALUES ('O3', 2);
INSERT INTO orders VALUES ('O4', 5);
INSERT INTO orders VALUES ('O5', 9);
INSERT INTO orders VALUES ('O6', 5);

SELECT * FROM batch;
SELECT * FROM orders;

WITH batch_cte AS
(
	SELECT *, ROW_NUMBER() OVER(ORDER BY batch_id) AS rn
	FROM (
		WITH RECURSIVE batch_split AS (
			SELECT batch_id, 1 as quantity FROM batch
			
			UNION ALL
			
			SELECT bs.batch_id, (bs.quantity + 1) AS quantity
			FROM batch_split bs
			INNER JOIN batch b
			ON bs.batch_id = b.batch_id AND b.quantity > bs.quantity
		)

		SELECT batch_id, 1 AS quantity
		FROM batch_split
	) batch_details
),

order_cte AS
(
	SELECT *, ROW_NUMBER() OVER(ORDER BY order_number) AS rn
	FROM (
		WITH RECURSIVE order_split AS (
			SELECT order_number, 1 AS quantity FROM orders
			
			UNION ALL
			
			SELECT os.order_number, (os.quantity + 1) AS quantity
			FROM order_split os
			INNER JOIN orders o
			ON os.order_number = o.order_number AND o.quantity > os.quantity
		)

		SELECT order_number, 1 AS quantity
		FROM order_split
	) order_details
)

SELECT order_number, batch_id, SUM(o.quantity) AS quantity
FROM order_cte o
LEFT OUTER JOIN batch_cte b
ON o.rn = b.rn
GROUP BY 1, 2
ORDER BY order_number, batch_id;
 