/*
Problem: Most Modified Extensions

A database contains a list of filenames including their extensions and the dates they were last modified. 
For each date that a modification was made, return the date, the extension(s) of the files that were modified
the most, and the number of files modified that date. If more than one file extension ties for the most
modifications, return them as a comma-delimited list in reverse alphabetical order. 

As an example, see the first row of output in the example below.

INPUT
+----+---------------+----------------------+
| id | date_modified | file_name            |
+----+---------------+----------------------+
| 1  | 2021-06-03    | thresholds.svg       |
+----+---------------+----------------------+
| 2  | 2021-06-01    | redrag.py            |
+----+---------------+----------------------+
| 3  | 2021-06-03    | counter.pdf          |
+----+---------------+----------------------+
| 4  | 2021-06-06    | reinfusion.py        |
+----+---------------+----------------------+
| 5  | 2021-06-06    | tonoplast.docx       |
+----+---------------+----------------------+
| 6  | 2021-06-01    | uranian.pptx         |
+----+---------------+----------------------+
| 7  | 2021-06-03    | discuss.pdf          |
+----+---------------+----------------------+
| 8  | 2021-06-06    | nontheologically.pdf |
+----+---------------+----------------------+
| 9  | 2021-06-01    | skiagrams.py         |
+----+---------------+----------------------+
| 10 | 2021-06-04    | flavors.py           |
+----+---------------+----------------------+
| 11 | 2021-06-05    | nonv.pptx            |
+----+---------------+----------------------+
| 12 | 2021-06-01    | under.pptx           |
+----+---------------+----------------------+
| 13 | 2021-06-02    | demit.csv            |
+----+---------------+----------------------+
| 14 | 2021-06-02    | trailings.pptx       |
+----+---------------+----------------------+
| 15 | 2021-06-04    | asst.py              |
+----+---------------+----------------------+
| 16 | 2021-06-03    | pseudo.pdf           |
+----+---------------+----------------------+
| 17 | 2021-06-03    | unguarded.jpeg       |
+----+---------------+----------------------+
| 18 | 2021-06-06    | suzy.docx            |
+----+---------------+----------------------+
| 19 | 2021-06-06    | anitsplentic.py      |
+----+---------------+----------------------+
| 20 | 2021-06-03    | tallies.py           |
+----+---------------+----------------------+

EXPECTED OUTPUT
+---------------+-----------+-------+
| date_modified | extension | count |
+---------------+-----------+-------+
| 2021-06-01    | py,pptx   | 2     |
+---------------+-----------+-------+
| 2021-06-02    | pptx,csv  | 1     |
+---------------+-----------+-------+
| 2021-06-03    | pdf       | 3     |
+---------------+-----------+-------+
| 2021-06-04    | py        | 2     |
+---------------+-----------+-------+
| 2021-06-05    | pptx      | 1     |
+---------------+-----------+-------+
| 2021-06-06    | py,docx   | 2     |
+---------------+-----------+-------+

*/

USE practice;

DROP TABLE IF EXISTS files;
CREATE TABLE files
(
    id             INT PRIMARY KEY,
    date_modified   DATE,
    file_name       VARCHAR(50)
);
INSERT INTO files VALUES (1	,   '2021-06-03', 'thresholds.svg');
INSERT INTO files VALUES (2	,   '2021-06-01', 'redrag.py');
INSERT INTO files VALUES (3	,   '2021-06-03', 'counter.pdf');
INSERT INTO files VALUES (4	,   '2021-06-06', 'reinfusion.py');
INSERT INTO files VALUES (5	,   '2021-06-06', 'tonoplast.docx');
INSERT INTO files VALUES (6	,   '2021-06-01', 'uranian.pptx');
INSERT INTO files VALUES (7	,   '2021-06-03', 'discuss.pdf');
INSERT INTO files VALUES (8	,   '2021-06-06', 'nontheologically.pdf');
INSERT INTO files VALUES (9	,   '2021-06-01', 'skiagrams.py');
INSERT INTO files VALUES (10,   '2021-06-04', 'flavors.py');
INSERT INTO files VALUES (11,   '2021-06-05', 'nonv.pptx');
INSERT INTO files VALUES (12,   '2021-06-01', 'under.pptx');
INSERT INTO files VALUES (13,   '2021-06-02', 'demit.csv');
INSERT INTO files VALUES (14,   '2021-06-02', 'trailings.pptx');
INSERT INTO files VALUES (15,   '2021-06-04', 'asst.py');
INSERT INTO files VALUES (16,   '2021-06-03', 'pseudo.pdf');
INSERT INTO files VALUES (17,   '2021-06-03', 'unguarded.jpeg');
INSERT INTO files VALUES (18,   '2021-06-06', 'suzy.docx');
INSERT INTO files VALUES (19,   '2021-06-06', 'anitsplentic.py');
INSERT INTO files VALUES (20,   '2021-06-03', 'tallies.py');

SELECT * FROM files;

-- SOLUTION
WITH only_file_extension AS
(
	SELECT date_modified, SUBSTRING(file_name, POSITION('.' IN file_name) + 1) AS extension
    FROM files
),

grouped_files AS
(
	SELECT date_modified, extension, COUNT(1) AS cnt, RANK() OVER(PARTITION BY date_modified ORDER BY COUNT(1) DESC) AS rnk
    FROM only_file_extension
    GROUP BY date_modified, extension
)

SELECT date_modified, GROUP_CONCAT(extension ORDER BY extension DESC) AS extension, MAX(cnt) AS 'count'
FROM grouped_files
WHERE rnk = 1
GROUP BY date_modified
ORDER BY date_modified;
