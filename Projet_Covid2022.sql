
select*
from projetcovid.coviddeaths_csv cc 
where continent is not null
order by 3, 4

select*
from projetcovid.covidvaccinations_csv cc 
where continent is not null 
order by 3, 4

-- select Data that we are going to be using

select location, `date` , total_cases, new_cases , total_deaths , population 
from projetcovid.coviddeaths_csv cc 
where continent is not null 
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your contry

select location , `date`, total_cases ,  total_deaths , (total_deaths/total_cases)*100 as DeahtPercentage
from ProjetCovid.coviddeaths_csv cc 
where location  like  '%france%'
order by 1,2 

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

select location  , `date`, total_cases ,  population  , (total_cases /population)*100 as PercentagePopInfected
from ProjetCovid.coviddeaths_csv cc 
where location  like  '%france%'
-- where continent is not null 
order by 1,2 

-- looking at Countries with Highest Infection Rate compared to population 

select location , population  , MAX(total_cases)  as HighestInfectionCount, MAX((total_cases /population))*100 as PercentagePopInfected
from ProjetCovid.coviddeaths_csv cc 
 -- where location  like  '%france%'
where continent is not null 
group by location , population 
order by PercentagePopInfected desc 

-- Showing Countries with Highest Death count per population 

select location, max(total_deaths) as TotalDeathCount
from projetcovid.coviddeaths_csv cc 
where continent is not null 
group by location 
order by TotalDeathCount desc 

-- Let's break things down by continent 
-- Shoing continents with the highest death count per population

select continent  , max(total_deaths) as TotalDeathCount
from projetcovid.coviddeaths_csv cc 
where continent  is not null 
group by continent  
order by TotalDeathCount desc 

-- Global NUMBERS by date

select  date, sum(new_cases) as Total_cases, sum(new_deaths) as Total_death, sum(new_deaths)/sum(new_cases)*100 as DeahtPercentage 
from projetcovid.coviddeaths_csv cc 
-- where location like 'france'
where continent is not null 
group by `date` 
order by 1,2


-- Global NUMBERS

select  sum(new_cases) as Total_cases, sum(new_deaths) as Total_death, sum(new_deaths)/sum(new_cases)*100 as DeahtPercentage 
from projetcovid.coviddeaths_csv cc 
-- where location like 'france'
where continent is not null 
-- group by `date` 
order by 1,2


-- Vaccinations

-- Looking at total population vs vaccinations


select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations 
from projetcovid.coviddeaths_csv dea 
join  projetcovid.covidvaccinations_csv vac
	on dea.location  = vac.location 
	and dea.`date` = vac.`date` 
where dea.continent is not null
	and  vac.new_vaccinations is not null
order by 2,3

-- Looking at total population vs vaccinations over date

select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`) as RollingPeopleVaccinated
from projetcovid.coviddeaths_csv dea 
join  projetcovid.covidvaccinations_csv vac
	on dea.location  = vac.location 
	and dea.`date` = vac.`date` 
where dea.continent is not null
	-- and  vac.new_vaccinations is not null
order by 2,3


-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)

as 
(
select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`) as RollingPeopleVaccinated
from projetcovid.coviddeaths_csv dea 
join  projetcovid.covidvaccinations_csv vac
	on dea.location  = vac.location 
	and dea.`date` = vac.`date` 
where dea.continent is not null
	 -- and  vac.new_vaccinations is not null
-- order by 2,3
)

select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

	
	
	
-- Creating view to store data for later visualizations

create view PercentPopulationVaccinated 
as
select dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.`date`) as RollingPeopleVaccinated
from projetcovid.coviddeaths_csv dea 
join  projetcovid.covidvaccinations_csv vac
	on dea.location  = vac.location 
	and dea.`date` = vac.`date` 
where dea.continent is not null





