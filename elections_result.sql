USE practice;
--- #1) Election Results ---

-- DATASET
DROP TABLE IF EXISTS candidates;
CREATE TABLE candidates
(
    id      INT,
    gender  VARCHAR(1),
    age     INT,
    party   VARCHAR(20)
);
INSERT INTO candidates VALUES(1,'M',55,'Democratic');
INSERT INTO candidates VALUES(2,'M',51,'Democratic');
INSERT INTO candidates VALUES(3,'F',62,'Democratic');
INSERT INTO candidates VALUES(4,'M',60,'Republic');
INSERT INTO candidates VALUES(5,'F',61,'Republic');
INSERT INTO candidates VALUES(6,'F',58,'Republic');

DROP TABLE IF EXISTS results;
CREATE TABLE results
(
    constituency_id     INT,
    candidate_id        INT,
    votes               int
);
INSERT INTO results VALUES(1,1,847529);
INSERT INTO results VALUES(1,4,283409);
INSERT INTO results VALUES(2,2,293841);
INSERT INTO results VALUES(2,5,394385);
INSERT INTO results VALUES(3,3,429084);
INSERT INTO results VALUES(3,6,303890);

SELECT * FROM candidates;
SELECT * FROM results;

/*
	Given a database of the results of an election, find the number of seats won by each party. 
	There are some rules to going about this:
		1. There are many constituencies in a state and many candidates who are contesting the election from each constituency.
		2. Each candidate belongs to a party.
		3. The candidate with the maximum number of votes in a given constituency wins for that constituency.

	The output should be in the following format: Party Seats_won
	The ordering should be in the order of seats won in descending order.
*/

SELECT CONCAT(party, ' ', COUNT(1)) AS party_seats_won
FROM
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY constituency_id ORDER BY votes DESC) AS rn
	FROM results r
	INNER JOIN candidates c
	ON r.candidate_id = c.id
) elections_result
WHERE rn = 1
GROUP BY party
ORDER BY COUNT(1) DESC;
