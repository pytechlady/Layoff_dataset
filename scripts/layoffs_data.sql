
# Data Cleaning

SELECT *
FROM layoffs;

# Create a staging DB 
CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

INSERT layoff_staging
SELECT *
FROM layoffs;

-- 1. Remove duplicate
WITH cte_duplicate2 AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_in_millions) as row_num
FROM layoff_staging
)

SELECT * 
FROM cte_duplicate2
WHERE row_num > 1;

CREATE TABLE `layoff_staging2` (
  `company` varchar(29) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `location` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `total_laid_off` decimal(6,1) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `percentage_laid_off` decimal(3,0) DEFAULT NULL,
  `industry` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `source` varchar(416) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `stage` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `funds_raised_in_millions` varchar(7) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `country` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff_staging2
SELECT *, ROW_NUMBER() OVER (PARTITION BY company, location, total_laid_off, `date`, percentage_laid_off,
industry, `source`, stage, funds_raised_in_millions, country, date_added) as row_num
FROM layoff_staging;

SELECT * FROM layoff_staging2;

-- 2. Standardise the data
SELECT company, TRIM(company)
FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);

SELECT *
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoff_staging2
SET industry = "Crypto"
WHERE industry LIKE 'CRYPTO%';

UPDATE layoff_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1;

SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date` = NULL
WHERE `date` = "NULL";

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoff_staging2
WHERE company LIKE "Airbnb%";

-- 3. Null values and Blank values
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 4. Remove unnecessary columns and rows
ALTER TABLE layoff_staging2
DROP COLUMN row_num;

-- 5. Exploratory data analysislayoffs

# Identify company with the highest number of layoffs
SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

# Identify the sum total layoffs by months
WITH Rolling_Total AS (
SELECT SUBSTRING(`date`, 1, 7) `MONTH`, SUM(total_laid_off) AS rolling_total
FROM layoff_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC
)
SELECT `MONTH`,rolling_total, SUM(rolling_total) OVER(ORDER BY `MONTH`) AS rolling_off
FROM Rolling_Total;

# Rank the top 5 companies with the highest layoffs by year
WITH company_year(company, years,total_laid_off ) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
), company_yearly_ranks AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT * 
FROM company_yearly_ranks
WHERE RANKING <= 5;

# Analyse layoff trends by Industry
SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY 2 DESC; 

# Analyse layoff trends by Geography
SELECT country, SUM(total_laid_off)
FROM layoff_staging2
WHERE country IS NOT NULL
GROUP BY country
ORDER BY 2 DESC;

# Analyse layoff trends by company stage
SELECT stage, SUM(total_laid_off)
FROM layoff_staging2
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY 1; 

# Assess correlation between funds raised and layoffs
SELECT 
  company, CAST(REPLACE(REPLACE(funds_raised_in_millions, '$', ''), ',', '') AS DECIMAL) as funds_raised, percentage_laid_off,
  ROUND(AVG(percentage_laid_off), 2) AS avg_percentage_laid_off,
  ROUND(AVG(
  CASE 
      WHEN funds_raised_in_millions LIKE '$%' THEN 
        CAST(REPLACE(REPLACE(funds_raised_in_millions, '$', ''), ',', '') AS DECIMAL)
      ELSE 0
    END), 2) AS avg_funds_raised,
  SUM(total_laid_off) AS total_laid_off
FROM 
  layoff_staging2
GROUP BY company, funds_raised, percentage_laid_off
HAVING avg_percentage_laid_off AND avg_funds_raised IS NOT NULL
ORDER BY 3 DESC;

SELECT *
FROM layoff_staging2;






