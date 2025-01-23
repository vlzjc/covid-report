USE `reportcovid`;
	

CREATE TABLE cases_deaths (
	country text,
	date datetime,
    new_cases bigint,
    new_deaths bigint
);

CREATE TABLE tests_covid (
	country text,
	date datetime,
    new_tests bigint
);

CREATE TABLE vaxxed (
	country text,
	date datetime,
    people_vaccinated bigint,
    people_fully_vaccinated bigint,
    daily_vaccinations bigint
);

ALTER TABLE cases_deaths
RENAME COLUMN date to cd_date;

ALTER TABLE tests_covid
RENAME COLUMN date to test_date;

ALTER TABLE vaxxed
RENAME COLUMN date to vax_date;

ALTER TABLE cases_deaths
MODIFY COLUMN cd_date date;

ALTER TABLE tests_covid
MODIFY COLUMN test_date date;

ALTER TABLE vaxxed
MODIFY COLUMN vax_date date;