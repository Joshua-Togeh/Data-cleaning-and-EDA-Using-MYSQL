-- CHECKING AND REMOVING DUPLCATES RECORDS
-- create the stagging_layoffs table
CREATE TABLE stagging_layoffs
LIKE layoffs;

-- inserting into the stagging_layoffs table
INSERT stagging_layoffs
SELECT *
FROM layoffs;

-- assigning row number to a duplicate column
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY  company, location, industry, total_laid_off, percentage_laid_off, 
	`date`, stage, country, funds_raised_millions) AS row_num
	FROM stagging_layoffs;
    
-- using CTE to check for  the duplicate  records
WITH  duplicate_cte  AS (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY  company, location, industry, total_laid_off, percentage_laid_off, 
	`date`, stage, country, funds_raised_millions) AS row_num
	FROM stagging_layoffs
)
SELECT *
	FROM duplicate_cte
    WHERE row_num>1
;

-- confirming if the casper is duplicated
SELECT * 
	FROM stagging_layoffs
    WHERE company = 'Casper'
    ;
    
-- creating table to hold the records including the row_num
CREATE TABLE stagging_layoff
LIKE stagging_layoffs;

-- adding row num column to the table holding the record with the row num
ALTER TABLE stagging_layoff
ADD COLUMN row_num INT;

-- insert the records including the row_num from the stagging layoffs
INSERT INTO stagging_layoff(
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY  company, location, industry, total_laid_off, percentage_laid_off, 
	`date`, stage, country, funds_raised_millions) AS row_num
	FROM stagging_layoffs
);

-- deleting the duplicate records
DELETE
	FROM stagging_layoff
    WHERE row_num > 1;
   ;
   
   
-- STANDARDIZING DATA
-- checking for white spaces then update it 
SELECT company, TRIM(company)
	FROM stagging_layoff;
    
UPDATE stagging_layoff
SET company = TRIM(company)
;

-- checking the individual industries and update similar one's
SELECT DISTINCT(industry) FROM stagging_layoff
-- WHERE industry LIKE 'Crypto'
ORDER BY 1
;

UPDATE stagging_layoff
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- fixing countries issues(the country with the dot at the end)
SELECT  DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM stagging_layoff
ORDER BY 1;

UPDATE stagging_layoff
SET  country = TRIM(TRAILING '.' FROM country)
WHERE  country LIKE 'United States%';

-- updating the columns to it particular format
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%y')
FROM stagging_layoff;

UPDATE stagging_layoff
SET `date` = STR_TO_DATE(`date`, '%m/%d/%y')
;

-- updating datatype
ALTER TABLE stagging_layoff
MODIFY COLUMN `date` DATE;

-- CHECKING AND UPDATING NULL AND MISSING(BLANK) VALUES
SELECT * FROM stagging_layoff
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- update the missing values in the industry column to NULL
UPDATE stagging_layoff
SET industry = NULL
WHERE industry = '';

-- checking for null and missing values in industry column
SELECT * FROM stagging_layoff
WHERE industry IS NULL
OR industry ='';

SELECT * FROM stagging_layoff
WHERE company = 'Airbnb';

-- create self join to hold the company that has it company appearing twice but
-- the one of the company has null value for the industry so we populate or update it with the same records
SELECT t1.industry, t2.industry
FROM stagging_layoff t1
JOIN stagging_layoff t2
		ON t1.company = t2.company
	WHERE(t1.industry IS NULL OR t1.industry = '')
    AND t2.industry IS NOT NULL;
    
UPDATE stagging_layoff t1
JOIN stagging_layoff t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;	

SELECT * FROM stagging_layoff;

DELETE FROM stagging_layoff
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- deleting the row num column
ALTER TABLE stagging_layoff
DROP COLUMN row_num
;

