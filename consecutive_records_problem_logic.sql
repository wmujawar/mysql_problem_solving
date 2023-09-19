USE practice;

/*
From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

Note: Weather is considered to be extremely cold then its temperature is less than zero.
*/

-- Table Structure:

DROP TABLE IF EXISTS weather;
CREATE TABLE weather
(
	id INTEGER,
	city VARCHAR(50),
	temperature INTEGER,
	day DATE
);

INSERT INTO weather VALUES
(1, 'London', -1, '2021-01-01'),
(2, 'London', -2, '2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2, '2021-01-05'),
(6, 'London', -5, '2021-01-06'),
(7, 'London', -7, '2021-01-07'),
(8, 'London', 5, '2021-01-08');

SELECT * FROM weather;

-- SCENARIO #1: Records with primary key
WITH weather_data AS
(
	SELECT *, id - ROW_NUMBER() OVER(ORDER BY id) AS difference
	FROM weather
	WHERE temperature < 0
),

weather_with_day_count AS
(
	SELECT *, COUNT(1) OVER(PARTITION BY difference) AS cnt
	FROM weather_data
)

SELECT id, city, temperature, day
FROM weather_with_day_count
WHERE cnt = 3;


-- SCENARIO #2: records with date
WITH weather_data AS
(
	SELECT *, DATE_SUB(day, INTERVAL ROW_NUMBER() OVER(ORDER BY day) DAY) AS difference
	FROM weather
	WHERE temperature < 0
),

weather_with_day_count AS
(
	SELECT *, COUNT(1) OVER(PARTITION BY difference) AS cnt
	FROM weather_data
)

SELECT id, city, temperature, day
FROM weather_with_day_count
WHERE cnt = 3;

-- SCENARIO #3: records with no date or primary key
DROP VIEW IF EXISTS weather_vw;
CREATE VIEW weather_vw AS (
	SELECT day, temperature
    FROM weather
);

WITH weather_with_id AS
(
	SELECT *, ROW_NUMBER() OVER() AS id
    FROM weather_vw
),

weather_data AS
(
	SELECT *, id - ROW_NUMBER() OVER(ORDER BY id) AS difference
	FROM weather_with_id
	WHERE temperature < 0
),

weather_with_day_count AS
(
	SELECT *, COUNT(1) OVER(PARTITION BY difference) AS cnt
	FROM weather_data
)

SELECT day, temperature
FROM weather_with_day_count
WHERE cnt = 3;
