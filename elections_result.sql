USE practice;
--- #1) Election Results ---

-- DATASET
DROP TABLE IF EXISTS candidates;
create table candidates
(
    id      int,
    gender  varchar(1),
    age     int,
    party   varchar(20)
);
insert into candidates values(1,'M',55,'Democratic');
insert into candidates values(2,'M',51,'Democratic');
insert into candidates values(3,'F',62,'Democratic');
insert into candidates values(4,'M',60,'Republic');
insert into candidates values(5,'F',61,'Republic');
insert into candidates values(6,'F',58,'Republic');

DROP TABLE IF EXISTS results;
create table results
(
    constituency_id     int,
    candidate_id        int,
    votes               int
);
insert into results values(1,1,847529);
insert into results values(1,4,283409);
insert into results values(2,2,293841);
insert into results values(2,5,394385);
insert into results values(3,3,429084);
insert into results values(3,6,303890);

select * from candidates;
select * from results;

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
) temp
WHERE rn = 1
GROUP BY party
ORDER BY COUNT(1) DESC;
