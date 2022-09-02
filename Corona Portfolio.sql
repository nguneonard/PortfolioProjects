select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--select data we are going to use

select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at total cases Vs total deaths
-- Shows likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%state%'
AND continent is not null
order by 1,2

-- total cases vs population
-- show what percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%state%'
order by 1,2

--looking at countries with highest infection rate compared to population
select Location, population, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100  
as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%state%'
group by location, population
order by PercentPopulationInfected desc

-- Showing countries with highest death count
select Location, MAX(cast(total_deaths as int)) as Totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
group by location
order by Totaldeathcount desc


--	LET'S BREAK THINGS BY CONTINENT
select location, MAX(cast(total_deaths as int)) as Totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is null
group by location
order by Totaldeathcount desc

-- showing the continent with the highest deathcount
select continent, MAX(cast(total_deaths as int)) as Totaldeathcount
from PortfolioProject..CovidDeaths
--where location like '%state%'
where continent is not null
group by continent
order by Totaldeathcount desc

-- GLOBAL NUMBER
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) as DeathPercentage
from PortfolioProject..CovidDeaths
-- where location like '%state%'
where continent is not null
GROUP BY date
order by 1,2

-- Looking at Total Population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

-- USE CITY
with PopvsVac (continent, location, date, Population,new_vaccinations, RollingPeopleVaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccination/Population)*100
from PopvsVac


-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccination numeric
)
insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccination/Population)*100
from #PercentPopulationVaccinated


--creating views to store data for later visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

select *
from  PercentPopulationVaccinated






































