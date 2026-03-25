-- exploring and analysing the cleaned data in the staging table
SELECT *
FROM trans_staging;

-- the number of transactions
SELECT COUNT(*) AS count_transactions
FROM trans_staging;

-- total sum of transactions of the whole dataset
SELECT SUM(amount_clean) AS total_amount
FROM trans_staging;

-- average amount of transactions
SELECT AVG(amount_clean) AS average_amount
FROM trans_staging;

-- minimum and maximum transaction amounts
SELECT MIN(amount_clean) AS min_amount, MAX(amount_clean) AS max_amount
FROM trans_staging;

-- highest transaction amount and the corresponding transaction details
SELECT *
FROM trans_staging
ORDER BY amount_clean DESC
LIMIT 1;

SELECT *
FROM trans_staging
WHERE amount_clean = (
        SELECT MAX(amount_clean) 
            FROM trans_staging);

-- lowest transaction amount and the corresponding transaction details which is not null
SELECT *
FROM trans_staging
WHERE amount_clean IS NOT NULL
ORDER BY amount_clean ASC
LIMIT 1;

SELECT *
FROM trans_staging
WHERE amount_clean = (
        SELECT MIN(amount_clean)
        FROM trans_staging
        WHERE amount_clean IS NOT NULL)
        LIMIT 1;

-- number of transactions per category
SELECT category, COUNT(category) AS count_category_transactions
FROM trans_staging
GROUP BY category
ORDER BY count_category_transactions DESC;

-- total amount of transactions per category
SELECT category, SUM(amount_clean) AS total_amount_category
FROM trans_staging
GROUP BY category
ORDER BY total_amount_category DESC;

-- average amount of transactions per category
SELECT category, AVG(amount_clean) AS average_amount_category
FROM trans_staging
GROUP BY category
ORDER BY average_amount_category DESC;

-- number of transactions per month of each year
SELECT MONTH(transaction_date) AS month, YEAR(transaction_date) AS year, COUNT(*) AS count_monthly
FROM trans_staging
GROUP BY month, year
ORDER BY year, MONTH(transaction_date);

-- total amount of transactions per month of each year
SELECT MONTH(transaction_date) AS month, YEAR(transaction_date) AS year, SUM(amount_clean) AS total_amount
FROM trans_staging
GROUP BY month, year
ORDER BY year, MONTH(transaction_date);

-- sum of transactions per month of each year for each category
SELECT category, MONTH(transaction_date) AS month, YEAR(transaction_date) AS year, SUM(amount_clean) AS total_amount
FROM trans_staging
GROUP BY category, month, year
ORDER BY year, MONTH(transaction_date), category;

-- number of transactions, total sum, averaage amount, minimum and maximum amount of transactions per each year for each category
SELECT category, YEAR(transaction_date) AS year, COUNT(*) AS total_num_transactions, 
    SUM(amount_clean) AS total_amount, AVG(amount_clean) AS average_amount, MIN(amount_clean) AS min_amount, 
    MAX(amount_clean) AS max_amount
FROM trans_staging
GROUP BY category, year
ORDER BY year, category;

-- number of transactions, total sum, averaage amount, minimum and maximum amount of transactions for 2020 for each category
SELECT category, COUNT(*) AS total_num_transactions, 
    SUM(amount_clean) AS total_amount, AVG(amount_clean) AS average_amount, MIN(amount_clean) AS min_amount, 
    MAX(amount_clean) AS max_amount
FROM trans_staging
WHERE YEAR(transaction_date) = 2020
GROUP BY category
ORDER BY category;

-- total, average, minimum and maximum amount of transactions for each year
SELECT YEAR(transaction_date) AS year, SUM(amount_clean) AS total_amount, 
    AVG(amount_clean) AS average_amount, MIN(amount_clean) AS min_amount, MAX(amount_clean) AS max_amount
FROM trans_staging
GROUP BY year
ORDER BY year;

-- total, average, minimum and maximum amount of transactions for travel category for each year
SELECT YEAR(transaction_date) AS year, SUM(amount_clean) AS total_amount, 
    AVG(amount_clean) AS average_amount, MIN(amount_clean) AS min_amount, MAX(amount_clean) AS max_amount
FROM trans_staging
WHERE category = 'Travel'
GROUP BY year
ORDER BY year;

-- how many transactions have null values in the amount column
SELECT COUNT(*) AS count_null_amount
FROM trans_staging
WHERE amount_clean IS NULL;