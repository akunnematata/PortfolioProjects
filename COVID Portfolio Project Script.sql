SELECT
 *
FROM `portfolio-project-372502.Covid19.CovidDeaths`
WHERE
 NOT continent = 'NULL'
ORDER BY
3,4;


--SELECT
-- *
--FROM
--`portfolio-project-372502.Covid19.CovidVaccinations`
--ORDER BY
-- 3,4;


-- Select Data that we are going to be using


SELECT
 Location, date, total_cases, new_cases, total_deaths, population
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
 NOT continent = 'NULL'
ORDER BY
 1,2;


-- Looking at total cases vs total deaths
-- Shows likelihood of death if you contract COVID in your country
SELECT
 Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
location like '%States%'
AND NOT continent = 'NULL'
ORDER BY
 1,2;


-- Looking at total cases vs population
-- Shows percent of population that has contracted COVID
SELECT
 Location, date, population,total_cases, (total_cases/population)*100 AS PercentPopulationContract
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
location like '%States%'
AND NOT continent = 'NULL'
ORDER BY
 1,2;


-- Looking at countries with highest infection rate compared to population


SELECT
 Location,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationContract
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
 NOT continent = 'NULL'
GROUP BY
location,population
ORDER BY
4 DESC;


-- Showing Countries with the highest death count per population


SELECT
 Location,population, MAX(total_deaths) AS TotalDeathCount, MAX((total_deaths/population))*100 AS PercentPopulationDied
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
 NOT continent = 'NULL'
GROUP BY
location,population
ORDER BY
3 DESC;


-- Showing continents with the highest death count per popoulation


SELECT
 continent,MAX(total_deaths) AS TotalDeathCount
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE
 continent is not null
GROUP BY
continent
ORDER BY
TotalDeathCount DESC;


-- GLOBAL DEATH PERCENTAGE


SELECT
SUM(new_cases) as global_total_cases,SUM(new_deaths) as global_total_deaths, (SUM(new_deaths)/SUM(new_cases)) * 100 AS GlobalDeathPercentage
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE NOT
 continent = 'NULL'


ORDER BY
 1,2;


-- GLOBAL DEATH PERCENTAGE BY DATE


SELECT
date, SUM(new_cases) as global_total_cases,SUM(new_deaths) as global_total_deaths, (SUM(new_deaths)/SUM(new_cases)) * 100 AS GlobalDeathPercentage
FROM
`portfolio-project-372502.Covid19.CovidDeaths`
WHERE NOT
 continent = 'NULL'
GROUP BY
 date
ORDER BY
 1,2;


--Looking at Total Population vs Vaccinations
SELECT
 dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY
 dea.location ORDER BY dea.location, dea.date)  AS RollingVaccinations,
FROM
`portfolio-project-372502.Covid19.CovidDeaths` AS dea
JOIN
 `portfolio-project-372502.Covid19.CovidVaccinations`AS vac
  ON dea.location= vac.location
  AND dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
 2,3;


-- USE CTE


WITH
 PopsvsVac
 as
 (
   SELECT
 dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY
 dea.location ORDER BY dea.location, dea.date)  AS RollingVaccinations
FROM
`portfolio-project-372502.Covid19.CovidDeaths` AS dea
JOIN
 `portfolio-project-372502.Covid19.CovidVaccinations`AS vac
  ON dea.location= vac.location
  AND dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
 2,3
 )
SELECT
 continent, location,date, population,new_vaccinations,SUM(new_vaccinations) OVER (PARTITION BY
 location ORDER BY location,date)  AS RollingVaccinations, (RollingVaccinations/population) * 100 AS PercentVaccinated
FROM
 PopsvsVac;




-- Creating Table
DROP TABLE portfolio-project-372502.Covid19.PercentPopulationVaccinated;


-- Dropping table to avoid errors when re-running code


CREATE TABLE portfolio-project-372502.Covid19.PercentPopulationVaccinated AS


SELECT
 dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY
 dea.location ORDER BY dea.location, dea.date)  AS RollingVaccinations
FROM
`portfolio-project-372502.Covid19.CovidDeaths` AS dea
JOIN
 `portfolio-project-372502.Covid19.CovidVaccinations`AS vac
  ON dea.location= vac.location
  AND dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
 2,3;


SELECT
 continent, location,date, population,new_vaccinations,SUM(new_vaccinations) OVER (PARTITION BY
 location ORDER BY location,date)  AS RollingVaccinations, (RollingVaccinations/population) * 100 AS PercentVaccinated
FROM
 portfolio-project-372502.Covid19.PercentPopulationVaccinated;


-- Creating view to store data for later viz RollingVaccinations


CREATE VIEW portfolio-project-372502.Covid19.RollingVaccinationsView AS
SELECT
 dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY
 dea.location ORDER BY dea.location, dea.date)  AS RollingVaccinations
FROM
`portfolio-project-372502.Covid19.CovidDeaths` AS dea
JOIN
 `portfolio-project-372502.Covid19.CovidVaccinations`AS vac
  ON dea.location= vac.location
  AND dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
 2,3;


-- Percent Population Vaccinated View


CREATE VIEW portfolio-project-372502.Covid19.PercentVaccinatedView AS
WITH
 PopsvsVac
 as
 (
   SELECT
 dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (PARTITION BY
 dea.location ORDER BY dea.location, dea.date)  AS RollingVaccinations
FROM
`portfolio-project-372502.Covid19.CovidDeaths` AS dea
JOIN
 `portfolio-project-372502.Covid19.CovidVaccinations`AS vac
  ON dea.location= vac.location
  AND dea.date = vac.date
WHERE
dea.continent is not null
ORDER BY
 2,3
 )
SELECT
 continent, location,date, population,new_vaccinations,SUM(new_vaccinations) OVER (PARTITION BY
 location ORDER BY location,date)  AS RollingVaccinations, (RollingVaccinations/population) * 100 AS PercentVaccinated
FROM
 PopsvsVac;