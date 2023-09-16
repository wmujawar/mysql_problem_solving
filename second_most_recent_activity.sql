USE practice;

DROP TABLE IF EXISTS user_activity;

CREATE TABLE user_activity (
	username VARCHAR(50),
    activity VARCHAR(50),
    start_date DATE,
    end_date DATE
);

INSERT INTO user_activity VALUES ('Amy', 'Travel', '2020-02-12', '2020-02-20');
INSERT INTO user_activity VALUES ('Amy', 'Dancing', '2020-02-21', '2020-02-23');
INSERT INTO user_activity VALUES ('Amy', 'Travel', '2020-02-24', '2020-02-28');
INSERT INTO user_activity VALUES ('Joe', 'Travel', '2020-02-11', '2020-02-18');
INSERT INTO user_activity VALUES ('Adam', 'Travel', '2020-02-12', '2020-02-20');
INSERT INTO user_activity VALUES ('Adam', 'Dancing', '2020-02-21', '2020-02-23');
INSERT INTO user_activity VALUES ('Adam', 'Singing', '2020-02-24', '2020-02-28');
INSERT INTO user_activity VALUES ('Adam', 'Travel', '2020-02-29', '2020-03-28');

SELECT * FROM user_activity;

/*
	This table does not contain primary key.
	This table contains information about the activity performed by each user in a period of time.
	A person with username performed an activity from start_date to end_date.

	Write an SQL query to show the second most recent activity of each user.

	If the user only has one activity, return that one.
	A user can't perform more than one activity at the same time. Return the result table in any order.
*/

SELECT username, activity, start_date, end_date
FROM (
	SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY username ORDER BY start_date) AS rn,
		COUNT(1) OVER(PARTITION BY username ORDER BY start_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt
	FROM user_activity
) AS activity
WHERE rn = CASE WHEN cnt = 1 THEN 1 ELSE cnt - 1 END
