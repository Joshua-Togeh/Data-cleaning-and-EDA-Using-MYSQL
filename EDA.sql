-- Exploratory data analysis

SELECT * 
FROM stagging_layoff;

-- exploring the maximum of the total laid off and the percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM stagging_layoff;

-- selecting everything where the percentage laif off is 1
SELECT * 
FROM stagging_layoff
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- selecting each company with it corresponding total laid off
SELECT company, SUM(total_laid_off)  AS total
FROM stagging_layoff
GROUP BY company
ORDER BY total  DESC;

-- checking the minimum and the maximum date
SELECT MIN(`date`), MAX(`date`)
FROM stagging_layoff;

-- selecting each industry with it corresponding total laid off
SELECT industry, SUM(total_laid_off) 
FROM stagging_layoff
GROUP BY industry
ORDER BY 2  DESC;


-- selecting each country with it corresponding total laid off
SELECT country, SUM(total_laid_off) 
FROM stagging_layoff
GROUP BY country
ORDER BY 2  DESC
-- LIMIT 5
;

-- selecting each date with it corresponding total laid off
SELECT MONTH(`date`), SUM(total_laid_off) 
FROM stagging_layoff
GROUP BY MONTH(`date`)
ORDER BY 1 DESC;

-- selecting each stage with it corresponding total laid off
SELECT stage, SUM(total_laid_off) 
FROM stagging_layoff
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off)
FROM stagging_layoff
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH rolling_total AS (
	SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
	FROM stagging_layoff
	WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
	GROUP BY `MONTH`
	ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM rolling_total
;


SELECT company, YEAR(`date`), SUM(total_laid_off) AS total
FROM stagging_layoff
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH company_year (company, years, total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off) AS total
FROM stagging_layoff
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
 FROM company_year
 WHERE years IS NOT NULL
 )
 SELECT * FROM company_year_rank
 WHERE ranking<=5
 ;