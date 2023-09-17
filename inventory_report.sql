-- FAANG Interview Question

/*
Q) 	We want to generate an inventory age report which would show the distribution of remaining inventory
	across the length of time the inventory has been sitting at the warehouse. We are trying to classify
	the inventory on hand across the below 4 buckets to denote the time the inventory has been lying the 
	warehouse.
 
	0-90 days old
	91-180 days old
	181-270 days old
	271 – 365 days old
 
	For example, the warehouse received 100 units yesterday and shipped 30 units today, then there are 70
	units which are a day old.
 
	The warehouses use FIFO (first in first out) approach to manage inventory, i.e., the inventory that comes
	first will be sent out first.
    
	+--------+----------------+---------------------+------------+------------------+
	| ID     | OnHandQuantity | OnHandQuantityDelta | event_type | event_datetime   |
	+--------+----------------+---------------------+------------+------------------+
	| SH0013 | 278            | 99                  | OutBound   | 2020-05-25 0:25  |
	+--------+----------------+---------------------+------------+------------------+
	| SH0012 | 377            | 31                  | InBound    | 2020-05-24 22:00 |
	+--------+----------------+---------------------+------------+------------------+
	| SH0011 | 346            | 1                   | OutBound   | 2020-05-24 15:01 |
	+--------+----------------+---------------------+------------+------------------+
	| SH0010 | 346            | 1                   | OutBound   | 2020-05-23 5:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH009  | 348            | 102                 | InBound    | 2020-04-25 18:00 |
	+--------+----------------+---------------------+------------+------------------+
	| SH008  | 246            | 43                  | InBound    | 2020-04-25 2:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH007  | 203            | 2                   | OutBound   | 2020-02-25 9:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH006  | 205            | 129                 | OutBound   | 2020-02-18 7:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH005  | 334            | 1                   | OutBound   | 2020-02-18 8:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH004  | 335            | 27                  | OutBound   | 2020-01-29 5:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH003  | 362            | 120                 | InBound    | 2019-12-31 2:00  |
	+--------+----------------+---------------------+------------+------------------+
	| SH002  | 242            | 8                   | OutBound   | 2019-05-22 0:50  |
	+--------+----------------+---------------------+------------+------------------+
	| SH001  | 250            | 250                 | InBound    | 2019-05-20 0:45  |
	+--------+----------------+---------------------+------------+------------------+

 
	For example, on 20th May 2019, 250 units were inbounded into the FC. On 22nd May 2019, 8 units were 
	shipped out (outbound) from the FC, reducing inventory on hand to 242 units. On 31st December, 120 
	units were further inbounded into the FC increasing the inventory on hand from 242 to 362. On 29th 
	January 2020, 27 units were shipped out reducing the inventory on hand to 335 units.
	
	On 29th January, of the 335 units on hands, 120 units were 0-90 days old (29 days old) and 215 units 
	were 181-270 days old (254 days old).
	 
	Columns:
	ID:						of the log entry
	OnHandQuantity:			Quantity in warehouse after an event
	OnHandQuantityDelta:	Change in on-hand quantity due to an event
	event_type: 			Inbound – inventory being brought into the warehouse; Outbound – inventory being sent out of warehouse
	event_datetime:			datetime of event
	
	The data is sorted with latest entry at top.
	 
	Sample output:
	+---------------+-----------------+------------------+------------------+
	| 0-90 days old | 91-180 days old | 181-270 days old | 271-365 days old |
	+---------------+-----------------+------------------+------------------+
	| 176           | 102             | 0                | 0                |
	+---------------+-----------------+------------------+------------------+

*/

USE practice;

DROP TABLE IF EXISTS warehouse;

CREATE TABLE warehouse
(
	ID						VARCHAR(10),
	OnHandQuantity			INT,
	OnHandQuantityDelta		INT,
	event_type				VARCHAR(10),
	event_datetime			DATETIME
);

INSERT INTO warehouse VALUES ('SH0013', 278,   99 ,   'OutBound', '2020-05-25 0:25');
INSERT INTO warehouse VALUES ('SH0012', 377,   31 ,   'InBound',  '2020-05-24 22:00');
INSERT INTO warehouse VALUES ('SH0011', 346,   1  ,   'OutBound', '2020-05-24 15:01');
INSERT INTO warehouse VALUES ('SH0010', 346,   1  ,   'OutBound', '2020-05-23 5:00');
INSERT INTO warehouse VALUES ('SH009',  348,   102,   'InBound',  '2020-04-25 18:00');
INSERT INTO warehouse VALUES ('SH008',  246,   43 ,   'InBound',  '2020-04-25 2:00');
INSERT INTO warehouse VALUES ('SH007',  203,   2  ,   'OutBound', '2020-02-25 9:00');
INSERT INTO warehouse VALUES ('SH006',  205,   129,   'OutBound', '2020-02-18 7:00');
INSERT INTO warehouse VALUES ('SH005',  334,   1  ,   'OutBound', '2020-02-18 8:00');
INSERT INTO warehouse VALUES ('SH004',  335,   27 ,   'OutBound', '2020-01-29 5:00');
INSERT INTO warehouse VALUES ('SH003',  362,   120,   'InBound',  '2019-12-31 2:00');
INSERT INTO warehouse VALUES ('SH002',  242,   8  ,   'OutBound', '2019-05-22 0:50');
INSERT INTO warehouse VALUES ('SH001',  250,   250,   'InBound',  '2019-05-20 0:45');

SELECT * FROM warehouse;

-- SOLUTION #1 --
WITH wh AS
(
	SELECT *
    FROM warehouse
    ORDER BY event_datetime DESC
),

days AS
(
	SELECT OnHandQuantity,
		event_datetime AS day_1,
		DATE_SUB(event_datetime, INTERVAL 90 DAY) AS day_90,
		DATE_SUB(event_datetime, INTERVAL 180 DAY) AS day_180,
		DATE_SUB(event_datetime, INTERVAL 270 DAY) AS day_270,
		DATE_SUB(event_datetime, INTERVAL 365 DAY) AS day_365
    FROM wh
    LIMIT 1
),

delta_values AS
(
	SELECT IFNULL(SUM(OnHandQuantityDelta), 0) AS delta
	FROM wh
	CROSS JOIN days d
	WHERE event_datetime BETWEEN d.day_90 AND d.day_1
	AND event_type = 'InBound'

	UNION ALL

	SELECT IFNULL(SUM(OnHandQuantityDelta), 0) AS delta
	FROM wh
	CROSS JOIN days d
	WHERE event_datetime BETWEEN d.day_180 AND d.day_90
	AND event_type = 'InBound'

	UNION ALL

	SELECT IFNULL(SUM(OnHandQuantityDelta), 0) AS delta
	FROM wh
	CROSS JOIN days d
	WHERE event_datetime BETWEEN d.day_270 AND d.day_180
	AND event_type = 'InBound'

	UNION ALL

	SELECT IFNULL(SUM(OnHandQuantityDelta), 0) AS delta
	FROM wh
	CROSS JOIN days d
	WHERE event_datetime BETWEEN d.day_365 AND d.day_270
	AND event_type = 'InBound'
),

delta_value_plus_previous_delta AS
(
	SELECT delta, OnHandQuantity,
		IFNULL(LAG(delta, 1) OVER(), 0) AS prev_1_delta,
		IFNULL(LAG(delta, 2) OVER(), 0) AS prev_2_delta,
		IFNULL(LAG(delta, 3) OVER(), 0) AS prev_3_delta
	FROM delta_values
	CROSS JOIN days
),

final_delta_value AS
(
	SELECT CASE 
			WHEN (OnHandQuantity - (prev_1_delta + prev_2_delta + prev_3_delta)) < 0 THEN delta -- Assumung that delta is zero
			WHEN delta > (OnHandQuantity - (prev_1_delta + prev_2_delta + prev_3_delta))
				THEN (OnHandQuantity - (prev_1_delta + prev_2_delta + prev_3_delta))
				ELSE delta END AS delta,
			ROW_NUMBER() OVER() AS rn
	FROM delta_value_plus_previous_delta
)

SELECT MAX(CASE WHEN rn = 1 THEN delta END) AS '0-90 days old',
	MAX(CASE WHEN rn = 2 THEN delta END) AS '90-180 days old',
	MAX(CASE WHEN rn = 3 THEN delta END) AS '180-270 days old',
	MAX(CASE WHEN rn = 4 THEN delta END) AS '270-365 days old'
FROM final_delta_value;

-- SOLUTION #2 --
WITH wh AS
(
	SELECT *
    FROM warehouse
    ORDER BY event_datetime DESC
),

days AS
(
	SELECT OnHandQuantity,
		event_datetime AS day_1,
		DATE_SUB(event_datetime, INTERVAL 90 DAY) AS day_90,
		DATE_SUB(event_datetime, INTERVAL 180 DAY) AS day_180,
		DATE_SUB(event_datetime, INTERVAL 270 DAY) AS day_270,
		DATE_SUB(event_datetime, INTERVAL 365 DAY) AS day_365
    FROM wh
    LIMIT 1
),

inventory_90 AS
(
	SELECT SUM(OnHandQuantityDelta) AS day_90_value
    FROM warehouse
    CROSS JOIN days d
    WHERE event_datetime BETWEEN d.day_90 AND d.day_1
    AND event_type = 'InBound'
),
inventory_90_final AS
(
	SELECT IFNULL(CASE WHEN OnHandQuantity < day_90_value 
					THEN OnHandQuantity 
                    ELSE day_90_value END, 0) AS day_90_value
    FROM days
    CROSS JOIN inventory_90 
),

inventory_180 AS
(
	SELECT SUM(OnHandQuantityDelta) AS day_180_value
    FROM warehouse
    CROSS JOIN days d
    WHERE event_datetime BETWEEN d.day_180 AND d.day_90
    AND event_type = 'InBound'
),
inventory_180_final AS
(
	SELECT IFNULL(CASE WHEN day_180_value > (OnHandQuantity - day_90_value) 
					THEN (OnHandQuantity - day_90_value) 
					ELSE day_180_value END, 0) AS day_180_value
    FROM days
    CROSS JOIN inventory_180
    CROSS JOIN inventory_90_final
),

inventory_270 AS
(
	SELECT SUM(OnHandQuantityDelta) AS day_270_value
    FROM warehouse
    CROSS JOIN days d
    WHERE event_datetime BETWEEN d.day_270 AND d.day_180
    AND event_type = 'InBound'
),
inventory_270_final AS
(
	SELECT IFNULL(CASE WHEN day_270_value > (OnHandQuantity - (day_90_value + day_180_value)) 
					THEN (OnHandQuantity - (day_90_value + day_180_value))
					ELSE day_270_value END, 0) AS day_270_value
    FROM days
    CROSS JOIN inventory_270
    CROSS JOIN inventory_180_final
    CROSS JOIN inventory_90_final
),

inventory_365 AS
(
	SELECT SUM(OnHandQuantityDelta) AS day_365_value
    FROM warehouse
    CROSS JOIN days d
    WHERE event_datetime BETWEEN d.day_365 AND d.day_270
    AND event_type = 'InBound'
),
inventory_365_final AS
(
	SELECT IFNULL(CASE WHEN day_365_value > (OnHandQuantity - (day_90_value + day_180_value + day_270_value)) 
					THEN (OnHandQuantity - (day_90_value + day_180_value + day_270_value))
					ELSE day_365_value END, 0) AS day_365_value
    FROM days
    CROSS JOIN inventory_365
    CROSS JOIN inventory_270_final
    CROSS JOIN inventory_180_final
    CROSS JOIN inventory_90_final
)

SELECT day_90_value AS '0-90 days old',
		day_180_value AS '91-180 days old', 
        day_270_value AS '181-270 days old', 
        day_365_value AS '271-365 days old'
FROM inventory_90_final
CROSS JOIN inventory_180_final
CROSS JOIN inventory_270_final
CROSS JOIN inventory_365_final;
