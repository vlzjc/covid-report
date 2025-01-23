use reportcovid;
SELECT * FROM reportcovid.cases_deaths;

SELECT * FROM reportcovid.region_country;

SELECT * FROM reportcovid.vaxxed;

SELECT * FROM reportcovid.tests_covid;

-- Selecting Philippines
SELECT region_country.region, country, cd_date, new_cases, new_deaths 
FROM reportcovid.cases_deaths
JOIN reportcovid.region_country
WHERE region = 'Asia' AND country = 'Philippines';

-- Selecting only countries in Asia
SELECT distinct country
FROM cases_deaths
JOIN region_country
WHERE region = 'Asia';

-- Selecting the max count of cases in a day | also had to exclude some of the rows
SELECT distinct country, cd_date, new_cases as highest_case
FROM cases_deaths
JOIN region_country
WHERE new_cases = (SELECT MAX(new_cases)
				FROM cases_deaths
                WHERE country NOT IN ("World", "World excl. China",
									"World excl. China and South Korea",
                                    "World excl. China, South Korea, Japan and Singapore",
                                    "Asia", "High-income countries", "Upper-middle-income countries"
                                    ))
;

-- total cases and deaths per country
SELECT country, SUM(new_cases) AS Total_Cases, sum(new_deaths) AS Total_Deaths
from cases_deaths
GROUP BY country;

-- Mortality Rate
SELECT country, ROUND(((sum(new_deaths)/SUM(new_cases))*100),2)AS Mortality_Rate 
from cases_deaths
GROUP BY country;

-- TOP 10 new cases recorded by day
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY new_cases DESC) AS 'row', country, new_cases, cd_date
FROM cases_deaths
WHERE country NOT IN ("World", "World excl. China",
					  "World excl. China and South Korea",
                      "World excl. China, South Korea, Japan and Singapore",
                      "Asia", "High-income countries", "Upper-middle-income countries",
                      "Europe", "European Union (27)", "Asia excl. China", "Lower-middle-income countries"
					  )
LIMIT 10
;

-- TOP 10 new cases recorded by day PER country
WITH CTE AS(
		SELECT country, MAX(new_cases) AS MaxCase
		FROM cases_deaths
		GROUP BY country
)
SELECT
	ROW_NUMBER() OVER(ORDER BY MaxCase DESC) AS 'Rank', country, MaxCase
FROM CTE
WHERE country NOT IN ("World", "World excl. China",
					  "World excl. China and South Korea",
                      "World excl. China, South Korea, Japan and Singapore",
                      "Asia", "High-income countries", "Upper-middle-income countries",
                      "Europe", "European Union (27)", "Asia excl. China", "Lower-middle-income countries"
					  )
LIMIT 10;

-- CREATES the main continuity 
DROP table IF EXISTS `date_table`;
CREATE TABLE date_table (
    date_main DATE
);

-- CREATES A STORED PROCEDURE WHERE WE FILL FROM 01/01/2019 to 12/31/2024 FOR THE date_table
DROP PROCEDURE IF EXISTS filldates;
DELIMITER |
CREATE PROCEDURE filldates(dateStart DATE, dateEnd DATE)
BEGIN
  WHILE dateStart <= dateEnd DO
    INSERT INTO date_table (date_main) VALUES (dateStart);
    SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
  END WHILE;
END;
|
DELIMITER ;
CALL filldates('2019-01-01','2024-12-31');
;


