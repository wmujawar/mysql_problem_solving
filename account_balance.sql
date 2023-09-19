USE practice;

/*
Write a query to return the account no and the transaction date when the account balance reached 1000.
Please include only those accounts whose balance currently is >= 1000

INPUT
+------------+------------------+--------------+--------------------+
| account_no | transaction_date | debit_credit | transaction_amount |
+------------+------------------+--------------+--------------------+
| acc_1      | 2022-01-20       | credit       | 100                |
+------------+------------------+--------------+--------------------+
| acc_1      | 2022-01-21       | credit       | 500                |
+------------+------------------+--------------+--------------------+
| acc_1      | 2022-01-22       | credit       | 300                |
+------------+------------------+--------------+--------------------+
| acc_1      | 2022-01-23       | credit       | 200                |
+------------+------------------+--------------+--------------------+
| acc_2      | 2022-01-20       | credit       | 500                |
+------------+------------------+--------------+--------------------+
| acc_2      | 2022-01-21       | credit       | 1100               |
+------------+------------------+--------------+--------------------+
| acc_2      | 2022-01-22       | debit        | 1000               |
+------------+------------------+--------------+--------------------+
| acc_3      | 2022-01-20       | credit       | 1000               |
+------------+------------------+--------------+--------------------+
| acc_4      | 2022-01-20       | credit       | 1500               |
+------------+------------------+--------------+--------------------+
| acc_4      | 2022-01-21       | debit        | 500                |
+------------+------------------+--------------+--------------------+
| acc_5      | 2022-01-20       | credit       | 900                |
+------------+------------------+--------------+--------------------+

EXPECTED OUTPUT
+------------+------------------+
| account_no | transaction_date |
+------------+------------------+
| acc_1      | 2022-01-23       |
+------------+------------------+
| acc_3      | 2022-01-20       |
+------------+------------------+
| acc_4      | 2022-01-20       |
+------------+------------------+
*/

DROP TABLE IF EXISTS account_balance;
CREATE TABLE account_balance
(
    account_no          VARCHAR(20),
    transaction_date    DATE,
    debit_credit        VARCHAR(10),
    transaction_amount  DECIMAL
);

INSERT INTO account_balance VALUES ('acc_1', '2022-01-20', 'credit', 100);
INSERT INTO account_balance VALUES ('acc_1', '2022-01-21', 'credit', 500);
INSERT INTO account_balance VALUES ('acc_1', '2022-01-22', 'credit', 300);
INSERT INTO account_balance VALUES ('acc_1', '2022-01-23', 'credit', 200);
INSERT INTO account_balance VALUES ('acc_2', '2022-01-20', 'credit', 500);
INSERT INTO account_balance VALUES ('acc_2', '2022-01-21', 'credit', 1100);
INSERT INTO account_balance VALUES ('acc_2', '2022-01-22', 'debit', 1000);
INSERT INTO account_balance VALUES ('acc_3', '2022-01-20', 'credit', 1000);
INSERT INTO account_balance VALUES ('acc_4', '2022-01-20', 'credit', 1500);
INSERT INTO account_balance VALUES ('acc_4', '2022-01-21', 'debit', 500);
INSERT INTO account_balance VALUES ('acc_5', '2022-01-20', 'credit', 900);

SELECT * FROM account_balance;

WITH account AS
(
	SELECT account_no,
		transaction_date,
        CASE WHEN debit_credit = 'debit' THEN transaction_amount * -1 ELSE transaction_amount END AS balance
	FROM account_balance
),

account_with_cumm_balance AS
(
	SELECT *,
		SUM(balance) OVER(PARTITION BY account_no ORDER BY transaction_date) AS current_balance,
        SUM(balance) OVER(PARTITION BY account_no ORDER BY transaction_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS total_balance
	FROM account
)

SELECT account_no, MIN(transaction_date) AS transaction_date
FROM account_with_cumm_balance
WHERE total_balance >= 1000
AND current_balance >= 1000
GROUP BY account_no;
