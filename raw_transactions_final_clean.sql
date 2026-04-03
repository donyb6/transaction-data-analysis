-- CLEANING THE DATASET
SELECT *
FROM raw_transactions_final;

-- create a staging table for data cleaning
CREATE TABLE trans_staging LIKE raw_transactions_final;

-- insert data inot the staging table
INSERT INTO trans_staging
SELECT *
FROM  raw_transactions_final;

SELECT *
FROM trans_staging;

-- convert transaction_date to date format
SELECT transaction_date, STR_TO_DATE(transaction_date, '%Y-%m-%d')
FROM trans_staging;

UPDATE trans_staging
SET transaction_date = STR_TO_DATE(transaction_date, '%Y-%m-%d');

ALTER TABLE trans_staging
MODIFY `transaction_date` DATE;

-- check for inconsistencies in category
SELECT DISTINCT category
FROM trans_staging;
-- there were no inconsistencies


-- standardise the amount column, remove any irregularities
SELECT amount
FROM trans_staging;

SELECT amount, TRIM(amount)
FROM trans_staging;

UPDATE trans_staging
SET amount = TRIM(amount);

SELECT amount, REPLACE(REPLACE(amount, '$', ''), ',', '')
FROM trans_staging
WHERE amount NOT IN ('Refunded', 'TBD', 'Waived', 'No Charge', 'Declined', 'N/A');

UPDATE trans_staging
SET amount = REPLACE(REPLACE(amount, '$', ''), ',', '');

SELECT amount, TRIM(amount)
FROM trans_staging;

UPDATE trans_staging
SET amount = TRIM(amount);

ALTER TABLE trans_staging
ADD COLUMN amount_clean DECIMAL(10, 2); -- create a new table for amount which is cleaned and converted to decimal format

UPDATE trans_staging
SET amount_clean = 
	CASE
		WHEN amount REGEXP '^[0-9]+(\\.[0-9]+)?$' 
        THEN CAST(amount AS DECIMAL(10, 2))
        ELSE NULL
	END;
    
SELECT amount, amount_clean
FROM trans_staging;

SELECT *
FROM trans_staging;

-- create a new column for transaction status based on the amount column
ALTER TABLE trans_staging
ADD COLUMN transaction_status VARCHAR(20);
-- update the transaction status based on the amount column
UPDATE trans_staging
SET transaction_status = 
	CASE
		WHEN amount_clean IS NOT NULL 
			THEN 'Completed'
		ELSE amount
        END;

SELECT amount, amount_clean, transaction_status
FROM trans_staging;


SELECT *
FROM trans_staging;