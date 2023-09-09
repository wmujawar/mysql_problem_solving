CREATE DATABASE practice;
USE practice;

CREATE TABLE employees (
	id integer NOT NULL,
	company varchar(50) NOT NULL,
	salary NUMERIC(8, 2) NOT NULL
);

-- Scaler
INSERT INTO employees values (1, 'Scaler', 2053);
INSERT INTO employees values (7, 'Scaler', 1111);
INSERT INTO employees values (5, 'Scaler', 1921);
INSERT INTO employees values (2, 'Scaler', 1763);
INSERT INTO employees values (4, 'Scaler', 2012);
INSERT INTO employees values (3, 'Scaler', 3157);
INSERT INTO employees values (6, 'Scaler', 2201);

-- Amazon
INSERT INTO employees values (8, 'Amazon', 3125);
INSERT INTO employees values (10, 'Amazon', 1717);
INSERT INTO employees values (12, 'Amazon', 2134);
INSERT INTO employees values (11, 'Amazon', 4444);
INSERT INTO employees values (9, 'Amazon', 1001);
INSERT INTO employees values (13, 'Amazon', 3212);

-- Google
INSERT INTO employees values (16, 'Google', 1091);
INSERT INTO employees values (15, 'Google', 2222);
INSERT INTO employees values (14, 'Google', 1923);

-- Check the number of records 
SELECT company, COUNT(*) FROM employees
GROUP BY 1;

-- Display all records sorted by company and salary
SELECT company, salary FROM employees
ORDER BY 1, 2;

-- Find the median of all the companies
SELECT company, ROUND(AVG(salary), 2)
FROM (
	SELECT *,
			ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rn,
			COUNT(*) OVER(PARTITION BY company ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt
	FROM employees
) emp
WHERE rn IN (CEIL(cnt / 2), cnt / 2 + 1)
GROUP BY 1;

