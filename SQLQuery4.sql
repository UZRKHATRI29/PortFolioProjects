SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--select *
--FROM PortfolioProject..CovidVaccinations

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2


Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPer
FROM PortfolioProject..CovidDeaths
WHERE location like '%States'
order by 1,2

Select Location, date, population,total_cases  , (total_cases/population)*100 as PopulationPer
FROM PortfolioProject..CovidDeaths
WHERE location like '%States'
and continent is not null
order by 1,2


Select Location,  population,MAX(total_cases) as highestInfectioncount ,max((total_cases/population))*100 as PopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%States'
GROUP BY LOCATION, POPULATION
order by PopulationInfected  desc

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--WHERE location like '%States'
GROUP BY LOCATION
order by TotalDeathCount  desc



Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is  null
--WHERE location like '%States'
GROUP BY location
order by TotalDeathCount  desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not  null
--WHERE location like '%States'
GROUP BY continent
order by TotalDeathCount  desc



Select  SUM(cast(new_cases as int)) as totalCases, Sum(cast(new_deaths as int))as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage --, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%States'
where continent is not null
--Group by date
order by 1,2

select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.Date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


With PopvsVac (Continent,Location, Date, Population ,New_Vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.Date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentage
From PopvsVac






DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated

select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.Date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
 
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPercentage
From #PercentPopulationVaccinated

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not  null
--WHERE location like '%States'
GROUP BY continent
order by TotalDeathCount  desc

create view  PercentPopulationVaccinated as
select dea.continent,dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.Date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated
