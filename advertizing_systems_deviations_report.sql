USE practice;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers
(
    id          INT,
    first_name   VARCHAR(50),
    last_name   VARCHAR(50)
);
INSERT INTO customers VALUES(1, 'Carolyn', 'O''Lunny');
INSERT INTO customers VALUES(2, 'Matteo', 'Husthwaite');
INSERT INTO customers VALUES(3, 'Melessa', 'Rowesby');

DROP TABLE IF EXISTS campaigns;
CREATE TABLE campaigns
(
    id          INT,
    customer_id INT,
    name        VARCHAR(50)
);
INSERT INTO campaigns VALUES(2, 1, 'Overcoming Challenges');
INSERT INTO campaigns VALUES(4, 1, 'Business Rules');
INSERT INTO campaigns VALUES(3, 2, 'YUI');
INSERT INTO campaigns VALUES(1, 3, 'Quantitative Finance');
INSERT INTO campaigns VALUES(5, 3, 'MMC');

DROP TABLE IF EXISTS events;
CREATE TABLE events
(
    campaign_id INT,
    status      VARCHAR(50)
);
INSERT INTO events VALUES(1, 'success');
INSERT INTO events VALUES(1, 'success');
INSERT INTO events VALUES(2, 'success');
INSERT INTO events VALUES(2, 'success');
INSERT INTO events VALUES(2, 'success');
INSERT INTO events VALUES(2, 'success');
INSERT INTO events VALUES(2, 'success');
INSERT INTO events VALUES(3, 'success');
INSERT INTO events VALUES(3, 'success');
INSERT INTO events VALUES(3, 'success');
INSERT INTO events VALUES(4, 'success');
INSERT INTO events VALUES(4, 'success');
INSERT INTO events VALUES(4, 'failure');
INSERT INTO events VALUES(4, 'failure');
INSERT INTO events VALUES(5, 'failure');
INSERT INTO events VALUES(5, 'failure');
INSERT INTO events VALUES(5, 'failure');
INSERT INTO events VALUES(5, 'failure');
INSERT INTO events VALUES(5, 'failure');
INSERT INTO events VALUES(5, 'failure');

INSERT INTO events VALUES(4, 'success');
INSERT INTO events VALUES(5, 'success');
INSERT INTO events VALUES(5, 'success');
INSERT INTO events VALUES(1, 'failure');
INSERT INTO events VALUES(1, 'failure');
INSERT INTO events VALUES(1, 'failure');
INSERT INTO events VALUES(2, 'failure');
INSERT INTO events VALUES(3, 'failure');

SELECT * FROM customers;
SELECT * FROM campaigns;
SELECT * FROM events;
/*
	As part of HackerAd's advertising system analytics, they need a list of the customers who have the most failures and successes in ad campaigns.
	There should be exactly two rows that contain type, customer, campaign, total.
		1. type contains 'success' in the first row and 'failure' in the second. These relate to events.status.
		2. customer is the customers.first_name and customers.last_name, separated by a single space.
		3. campaign is a comma-separated list of campaigns.name that are associated with the customer, ordered ascending.
		4. total is the number of associated events.
		
	Report only 2 customers, the two with the most successful and the most failing campaigns.
*/

SELECT event_type, customer, campaign, total
FROM
(
	SELECT status as event_type, 
		CONCAT(first_name, ' ', last_name) AS customer,
		GROUP_CONCAT(DISTINCT camp.name ORDER BY camp.name ASC, ',') AS campaign, -- In PostgreSQL the alternative to GROUP_CONCAT is STRING_AGG function
		COUNT(1) AS total,
		ROW_NUMBER() OVER(PARTITION BY status ORDER BY COUNT(1) DESC) AS rn
	FROM customers cust
	INNER JOIN campaigns camp
	ON cust.id = camp.customer_id
	INNER JOIN events e
	ON camp.id = e.campaign_id
	GROUP BY event_type, customer
) caimpaign_details
WHERE rn = 1
ORDER BY event_type DESC;