USE practice;

CREATE TABLE projects (
	task_id INTEGER,
    start_date DATE,
    end_date DATE
);

INSERT INTO projects VALUES (1, '2015-10-01', '2015-10-02');
INSERT INTO projects VALUES (2, '2015-10-02', '2015-10-03');
INSERT INTO projects VALUES (3, '2015-10-03', '2015-10-04');
INSERT INTO projects VALUES (4, '2015-10-13', '2015-10-14');
INSERT INTO projects VALUES (5, '2015-10-14', '2015-10-15');
INSERT INTO projects VALUES (6, '2015-10-28', '2015-10-29');
INSERT INTO projects VALUES (7, '2015-10-31', '2015-10-31');


SELECT * FROM projects;

-- Solution
SET @group := 1;

SELECT MIN(start_date), MAX(end_date)
FROM (
	SELECT start_date, end_date, previous_end_date,
		CASE WHEN previous_end_date = DATE_SUB(end_date, INTERVAL 1 DAY) THEN @group ELSE @group := @group + 1 END AS grp
	FROM (
		SELECT start_date, end_date, LAG(end_date) OVER(ORDER BY start_date) AS previous_end_date
		FROM projects
		ORDER BY start_date
	) temp
) temp2
GROUP BY grp
ORDER BY COUNT(grp);


