USE practice;

DROP TABLE IF EXISTS job_positions;
CREATE TABLE job_positions
(
	id			INT,
	title 		VARCHAR(100),
	grps 		VARCHAR(10),
	levels		VARCHAR(10),
	payscale	INT,
	totalpost	int
);
INSERT INTO job_positions VALUES (1, 'General manager', 'A', 'l-15', 10000, 1);
INSERT INTO job_positions VALUES (2, 'Manager', 'B', 'l-14', 9000, 5);
INSERT INTO job_positions VALUES (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

DROP TABLE IF EXISTS job_employees;
CREATE TABLE job_employees
(
	id				INT,
	name 			VARCHAR(100),
	position_id 	int
);
INSERT INTO job_employees VALUES (1, 'John Smith', 1);
INSERT INTO job_employees VALUES (2, 'Jane Doe', 2);
INSERT INTO job_employees VALUES (3, 'Michael Brown', 2);
INSERT INTO job_employees VALUES (4, 'Emily Johnson', 2);
INSERT INTO job_employees VALUES (5, 'William Lee', 3);
INSERT INTO job_employees VALUES (6, 'Jessica Clark', 3);
INSERT INTO job_employees VALUES (7, 'Christopher Harris', 3);
INSERT INTO job_employees VALUES (8, 'Olivia Wilson', 3);
INSERT INTO job_employees VALUES (9, 'Daniel Martinez', 3);
INSERT INTO job_employees VALUES (10, 'Sophia Miller', 3);

/*
	Problem Statement: Position table contains the available job vacancies, Employee table
	mentions the employees who already filled some of the vacancies. Write an SQL query using the
	above 2 tables to return the output as shown below.
*/

SELECT * FROM job_positions;
SELECT * FROM job_employees;

WITH RECURSIVE job_position_split AS
(
	SELECT id, title, grps, levels, payscale, 1 AS totalpost
	FROM job_positions
	
	UNION
	
	SELECT js.id, js.title, js.grps, js.levels, js.payscale, (js.totalpost + 1) AS totalpost
	FROM job_position_split js
	INNER JOIN job_positions j
	ON js.id = j.id AND j.totalpost > js.totalpost
)

SELECT title, grps AS 'group', levels, payscale, IFNULL(name, 'VACANT') AS employee_name
FROM job_position_split j
LEFT OUTER JOIN
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY position_id ORDER BY id) AS rn
    FROM job_employees
) emp
ON j.id = emp.position_id AND j.totalpost = emp.rn
ORDER BY grps;
