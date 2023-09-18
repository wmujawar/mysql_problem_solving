/*
	Write an SQL query to display the correct message (meaningful message) from input comments_and_translation table.
    
    INPUT
	+----+-----------+---------------+
	| id | comment   | translation   |
	+----+-----------+---------------+
	| 1  | very good |               |
	+----+-----------+---------------+
	| 2  | good      |               |
	+----+-----------+---------------+
	| 3  | bad       |               |
	+----+-----------+---------------+
	| 4  | ordinary  |               |
	+----+-----------+---------------+
	| 5  | cdcdcdcd  | very bad      |
	+----+-----------+---------------+
	| 6  | excellent |               |
	+----+-----------+---------------+
	| 7  | ababab    | not satisfied |
	+----+-----------+---------------+
	| 8  | satisfied |               |
	+----+-----------+---------------+
	| 9  | aabbaabb  | extraordinary |
	+----+-----------+---------------+
	| 10 | ccddccbb  | medium        |
	+----+-----------+---------------+
    
    SAMPLE OUTPUT
	+---------------+
	| output        |
	+---------------+
	| very good     |
	+---------------+
	| good          |
	+---------------+
	| bad           |
	+---------------+
	| ordinary      |
	+---------------+
	| very bad      |
	+---------------+
	| excellent     |
	+---------------+
	| not satisfied |
	+---------------+
	| satisfied     |
	+---------------+
	| extraordinary |
	+---------------+
	| medium        |
	+---------------+
*/

USE practice;

DROP TABLE IF EXISTS comments_and_translations;
CREATE TABLE comments_and_translations
(
	id				INTEGER,
	comment			VARCHAR(100),
	translation		VARCHAR(100)
);

INSERT INTO comments_and_translations VALUES
(1, 'very good', null),
(2, 'good', null),
(3, 'bad', null),
(4, 'ordinary', null),
(5, 'cdcdcdcd', 'very bad'),
(6, 'excellent', null),
(7, 'ababab', 'not satisfied'),
(8, 'satisfied', null),
(9, 'aabbaabb', 'extraordinary'),
(10, 'ccddccbb', 'medium');

SELECT * FROM comments_and_translations;

-- SOLUTION #1
SELECT COALESCE(translation, comment) AS output
FROM comments_and_translations;

-- SOLUTION #2
SELECT IFNULL(translation, comment) AS output
FROM comments_and_translations;

-- SOLUTION #3
SELECT CASE WHEN translation IS NULL THEN COMMENT ELSE translation END AS output
FROM comments_and_translations;
