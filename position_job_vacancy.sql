use practice;

drop table if exists job_positions;
create table job_positions
(
	id			int,
	title 		varchar(100),
	grps 		varchar(10),
	levels		varchar(10),
	payscale	int,
	totalpost	int
);
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1);
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5);
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);

drop table if exists job_employees;
create table job_employees
(
	id				int,
	name 			varchar(100),
	position_id 	int
);
insert into job_employees values (1, 'John Smith', 1);
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2);
insert into job_employees values (5, 'William Lee', 3);
insert into job_employees values (6, 'Jessica Clark', 3);
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3);

/*
	Problem Statement: Position table contains the available job vacancies, Employee table
	mentions the employees who already filled some of the vacancies. Write an SQL query using the
	above 2 tables to return the output as shown below.
*/

select * from job_positions;
select * from job_employees;

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
