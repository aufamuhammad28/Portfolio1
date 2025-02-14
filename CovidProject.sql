SELECT *
FROM PortfolioProject1..CovidDeaths
Where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject1..CovidVaccinations
--ORDER BY 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject1..CovidDeaths
Where continent is not null
Order By 1,2

Select location,date,total_cases,total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order By 1,2

Select location,date,population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
Where continent is not null
--Where location like '%states%'
Order By 1,2

Select location,population,MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths
Where continent is not null
--Where location like '%states%'
Group by location,population
Order By PercentPopulationInfected DESC

Select location,MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfolioProject1..CovidDeaths
Where continent is not null
--Where location like '%states%'
Group by location
Order By TotalDeathsCount DESC

--By continent


--Showing continents with the highest death count per population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathsCount
From PortfolioProject1..CovidDeaths
Where continent is not null
Group by continent
Order By TotalDeathsCount DESC

--Global
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_cases as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where continent is not null
Group by date
Order By 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_cases as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where continent is not null
--Group by date
Order By 1,2


--Looking at Total Population vs Total vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order By 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations))  OVER (Partition By dea.location)
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order By 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations))  OVER (Partition By dea.location Order By dea.location, dea.date) 
as RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order By 2,3

--Use CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations))  OVER (Partition By dea.location Order By dea.location, dea.date) 
as RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Table
Drop Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert into #PercentagePopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations))  OVER (Partition By dea.location Order By dea.location, dea.date) 
as RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From  #PercentagePopulationVaccinated

--Creating view for later visualizations 

Create View PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations))  OVER (Partition By dea.location Order By dea.location, dea.date) 
as RollingPeopleVaccinated
FROM PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3

Select *
From PercentagePopulationVaccinated