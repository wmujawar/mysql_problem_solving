/*
	PROBLEM STATEMENT: Find Hierarchy of employees
	For each employee, showcase all the employee's working under them (including themselves).
	Such that, when the child tree expands i.e every new employee should be dynamically assigned to their managers till the top level hierarchy.
    
    INPUT:
	+--------+--------------+
	| emp_id | reporting_id |
	+--------+--------------+
	| 1      |              |
	+--------+--------------+
	| 2      | 1            |
	+--------+--------------+
	| 3      | 1            |
	+--------+--------------+
	| 4      | 2            |
	+--------+--------------+
	| 5      | 2            |
	+--------+--------------+
	| 6      | 3            |
	+--------+--------------+
	| 7      | 3            |
	+--------+--------------+
	| 8      | 4            |
	+--------+--------------+
	| 9      | 4            |
	+--------+--------------+
    
    EXPEXTED OUTPUT:
	+--------+---------------+
	| emp_id | emp_hierarchy |
	+--------+---------------+
	| 1      | 1             |
	+--------+---------------+
	| 1      | 2             |
	+--------+---------------+
	| 1      | 3             |
	+--------+---------------+
	| 1      | 4             |
	+--------+---------------+
	| 1      | 5             |
	+--------+---------------+
	| 1      | 6             |
	+--------+---------------+
	| 1      | 7             |
	+--------+---------------+
	| 1      | 8             |
	+--------+---------------+
	| 1      | 9             |
	+--------+---------------+
	| 2      | 2             |
	+--------+---------------+
	| 2      | 4             |
	+--------+---------------+
	| 2      | 5             |
	+--------+---------------+
	| 2      | 8             |
	+--------+---------------+
	| 2      | 9             |
	+--------+---------------+
	| 3      | 3             |
	+--------+---------------+
	| 3      | 6             |
	+--------+---------------+
	| 3      | 7             |
	+--------+---------------+
	| 4      | 4             |
	+--------+---------------+
	| 4      | 8             |
	+--------+---------------+
	| 4      | 9             |
	+--------+---------------+
	| 5      | 5             |
	+--------+---------------+
	| 6      | 6             |
	+--------+---------------+
	| 7      | 7             |
	+--------+---------------+
	| 8      | 8             |
	+--------+---------------+
	| 9      | 9             |
	+--------+---------------+
*/

USE practice;

DROP TABLE IF EXISTS emp_hierarchy;

CREATE TABLE emp_hierarchy
(
	emp_id INTEGER,
    reporting_id INTEGER
);

INSERT INTO emp_hierarchy VALUES(1, null);
INSERT INTO emp_hierarchy VALUES(2, 1);
INSERT INTO emp_hierarchy VALUES(3, 1);
INSERT INTO emp_hierarchy VALUES(4, 2);
INSERT INTO emp_hierarchy VALUES(5, 2);
INSERT INTO emp_hierarchy VALUES(6, 3);
INSERT INTO emp_hierarchy VALUES(7, 3);
INSERT INTO emp_hierarchy VALUES(8, 4);
INSERT INTO emp_hierarchy VALUES(9, 4);

SELECT * FROM emp_hierarchy;
    
-- SOLUTION
WITH RECURSIVE hierarchy AS
(
	SELECT emp_id, emp_id AS emp_hierarchy
    FROM emp_hierarchy
    
    UNION ALL
    
    SELECT h.emp_id, eh.emp_id AS emp_hierarchy
    FROM hierarchy h
    INNER JOIN emp_hierarchy eh
    ON eh.reporting_id = h.emp_hierarchy
)

SELECT *
FROM hierarchy
ORDER BY emp_id, emp_hierarchy;

