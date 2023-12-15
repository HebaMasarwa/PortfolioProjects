-- Selecting Data

select  *
From coviddeath 
where continent  is not null 
order by 1,2

-- Total Cases vs Total Deaths per Country
-- likelihood of dying after conracting covid per Country

select  location, `date` , total_cases, total_deaths,
		(total_deaths/total_cases)*100 as DeathPercentage
From coviddeath 
where continent  is not null 
order by 1,2

-- Total Cases vs Population 
-- likelihood of getting covid per Country

select  location, `date` , total_cases,population, 
		(total_cases/population)*100 as InfectedPercentage
From coviddeath 
where continent  is not null 
order by 1,2

-- Countries with Highest Infection Rate compared to Population

select  location, MAX(total_cases) as HighestCases,population, 
		MAX((total_cases/population))*100 as MaxInfectedPercentage
From coviddeath 
where continent  is not null 
group by location, population 
order by MaxInfectedPercentage desc 

-- Showcasing the Countries with the Highest Death Count per Population

select  location, MAX(total_deaths) as TotalDeathCount
From coviddeath 
where continent  is not null 
group by location 
order by TotalDeathCount desc 

-- continent with highest deathcount per population
 
select  continent, MAX(total_deaths) as TotalDeathCount
From coviddeath 
where continent  is not null 
group by continent 
order by TotalDeathCount desc 

-- Global numbers 

-- likelihood of dying after conracting covid WORLDWIDE per DAY
select  `date` , SUM(new_cases) as TotalCases ,
		SUM(new_deaths) as TotalDeath,
		(SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From coviddeath 
where continent  is not null 
group by `date` 
order by DeathPercentage desc

-- Covid Vac table
select  *
From covidvacc  
where continent  is not null 
order by 1,2

-- Total Population VS vaccinations
select  CD.continent,cd.location,cd.`date` ,CD.population ,CV.new_vaccinations ,
		SUM(CAST(CV.new_vaccinations AS INT)) over (partition by CD.location)
		as RollingPeopleVaccinated
--		(RollingPeopleVaccinated/population)*100
From coviddeath  CD
join covidvacc CV 
	on CD.location = CV.location 
	and cd.`date`  = CV.`date`  
where CD.continent  is not null 
order by 2,3

-- CTE

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as 
(
select  CD.continent,cd.location,cd.`date` ,CD.population ,CV.new_vaccinations ,
		SUM(CAST(CV.new_vaccinations AS INT)) over (partition by CD.location)
		as RollingPeopleVaccinated
--		,(RollingPeopleVaccinated/population)*100
From coviddeath  CD
join covidvacc CV 
	on CD.location = CV.location 
	and cd.`date`  = CV.`date`  
where CD.continent  is not null 
-- order by 2,3
) select  *, (RollingPeopleVaccinated/population)*100 
from PopvsVac

-- creating view to store data for later visualizations

create view PercentPopulationVacc as 
select  CD.continent,cd.location,cd.`date` ,CD.population ,CV.new_vaccinations ,
		SUM(CAST(CV.new_vaccinations AS INT)) over (partition by CD.location)
		as RollingPeopleVaccinated
--		,(RollingPeopleVaccinated/population)*100
From coviddeath  CD
join covidvacc CV 
	on CD.location = CV.location 
	and cd.`date`  = CV.`date`  
where CD.continent  is not null 

select * from PercentPopulationVacc