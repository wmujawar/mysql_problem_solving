USE practice;

DROP TABLE IF EXISTS candidates_tab;
CREATE TABLE candidates_tab
(
    id          INT,
    first_name   VARCHAR(50),
    last_name   VARCHAR(50)
);
INSERT INTO candidates_tab VALUES(1, 'Davide', 'Kentish');
INSERT INTO candidates_tab VALUES(2, 'Thorstein', 'Bridge');

DROP TABLE IF EXISTS results_tab;
CREATE TABLE results_tab
(
    candidate_id    INT,
    state           VARCHAR(50)
);
INSERT INTO results_tab VALUES(1, 'Alabama');
INSERT INTO results_tab VALUES(1, 'Alabama');
INSERT INTO results_tab VALUES(1, 'California');
INSERT INTO results_tab VALUES(1, 'California');
INSERT INTO results_tab VALUES(1, 'California');
INSERT INTO results_tab VALUES(1, 'California');
INSERT INTO results_tab VALUES(1, 'California');
INSERT INTO results_tab VALUES(2, 'California');
INSERT INTO results_tab VALUES(2, 'California');
INSERT INTO results_tab VALUES(2, 'New York');
INSERT INTO results_tab VALUES(2, 'New York');
INSERT INTO results_tab VALUES(2, 'Texas');
INSERT INTO results_tab VALUES(2, 'Texas');
INSERT INTO results_tab VALUES(2, 'Texas');

INSERT INTO results_tab VALUES(1, 'New York');
INSERT INTO results_tab VALUES(1, 'Texas');
INSERT INTO results_tab VALUES(1, 'Texas');
INSERT INTO results_tab VALUES(1, 'Texas');
INSERT INTO results_tab VALUES(2, 'California');
INSERT INTO results_tab VALUES(2, 'Alabama');

SELECT * FROM candidates_tab;
SELECT * FROM results_tab;

/*
	As part of HackerPoll's election exit poll analytics, a team needs a list of candidates and their top 3 vote totals and the states
    where they occurred.
	
    The result should be in the following format: candidate_name, 1st_place, 2nd_place, 3rd_place.

	1. Concatenate the candidate's first and last names with a space between them.
	2. 1st_place, 2nd_place, 3rd_place are comma-separated US state names and numbers of votes in a format "%statename% (%votes%)", 
	   for example, "New York (23)".
	3. Results should be sorted ascending by candidate_name.
*/

WITH state_wise_results AS
(
	SELECT CONCAT(first_name, ' ', last_name) AS candidate_name, state, COUNT(1) AS result
	FROM candidates_tab c
	INNER JOIN results_tab r
	ON c.id = r.candidate_id
	GROUP BY candidate_name, state
),

state_wise_grouped_result AS
(
	SELECT candidate_name, CONCAT(state, ' (', result, ')') AS state_result,
		DENSE_RANK() OVER(PARTITION BY candidate_name ORDER BY result DESC) AS rnk
	FROM state_wise_results
)

SELECT candidate_name, 
	GROUP_CONCAT(CASE WHEN rnk = 1 THEN state_result END ORDER BY state_result) AS 1st_place,
    GROUP_CONCAT(CASE WHEN rnk = 2 THEN state_result END ORDER BY state_result) AS 2nd_place,
    GROUP_CONCAT(CASE WHEN rnk = 3 THEN state_result END ORDER BY state_result) AS 3rd_place
FROM state_wise_grouped_result
GROUP BY candidate_name;
