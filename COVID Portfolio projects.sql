Select *
from PortfolioProject..CovidDeaths$
order by 3,4

Select location, date, total_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

-- percentage of deaths to cases

Select location, date, total_cases,total_deaths, (cast(total_deaths as float)) / cast(total_cases as float)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
Where location like '%Nigeria%'
order by 1,2

-- ratio of total cases to total population
Select location, date, population, total_cases, (cast(total_cases as float)) / cast(population as float)*100 as InfectedPopulation
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
order by 1,2

--Highest population death case BY COUNTRY
Select Location, MAX (cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Highest population death case BY CONTINENT

Select continent, MAX (cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL DEATH TO CASES PERCENTAGE
Select SUM(new_cases) as total_cases, SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2


Select *
from PortfolioProject..CovidDeaths$
order by 3,4

Select location, date, total_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

-- percentage of deaths to cases

Select location, date, total_cases,total_deaths, (cast(total_deaths as float)) / cast(total_cases as float)*100 as DeathPercentage
from PortfolioProject..CovidDeaths$
Where location like '%Nigeria%'
order by 1,2

-- ratio of total cases to total population
Select location, date, population, total_cases, (cast(total_cases as float)) / cast(population as float)*100 as InfectedPopulation
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
order by 1,2

--Highest population death case BY COUNTRY
Select Location, MAX (cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Highest population death case BY CONTINENT

Select continent, MAX (cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
--Where location like '%Nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL DEATH TO CASES PERCENTAGE
Select SUM(new_cases) as total_cases, SUM(new_deaths) as totalDeath, SUM(new_deaths)/SUM(new_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2


Select *
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date

Select dth.date, dth.continent, dth.location,  dth.population, vacc.new_vaccinations
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null 
order by 3,1 


--ratio of population to new vaccinations
Select dth.date, dth.continent, dth.location,  dth.population, vacc.new_vaccinations
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null 
order by 3,1

--cumulative ratio of popuation to new vaccinations
Select dth.date, dth.continent, dth.Location, dth.population, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations as float)) OVER  (Partition By dth.Location order by dth.Location, dth.Date ) as cumulativevaccinationbylocation
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null
order by 3,1

--ratio of total people vaccinated to population
--Using CTE

With VaccinatedtoPopulation (date, continent, location, population, new_vaccinations, cumulativevaccinationbylocation)
as
(
Select dth.date, dth.continent, dth.Location, dth.population, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations as float)) OVER  (Partition By dth.Location order by dth.Location, dth.Date ) as cumulativevaccinationbylocation
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null
)
Select *,  (cumulativevaccinationbylocation/population)*100 percentagecumumlativetopopulation
From VaccinatedtoPopulation

--USING Temp table

DROP TABLE IF EXISTS  #PopulationVaccinated 
Create Table #PopulationVaccinated
(date datetime,
continent nvarchar (255),
location nvarchar (255),
population numeric,
new_vaccinations numeric,
cumulativevaccinationbylocation numeric
)

insert into  #PopulationVaccinated
Select dth.date, dth.continent, dth.Location, dth.population, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations as float)) OVER  (Partition By dth.Location order by dth.Location, dth.Date ) as cumulativevaccinationbylocation
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null
Select *,  (cumulativevaccinationbylocation/population)*100 percentagecumumlativetopopulation
From #PopulationVaccinated


--creating view for visualisations 

CREATE VIEW PopulationVaccinated 
as
Select dth.date, dth.continent, dth.Location, dth.population, vacc.new_vaccinations, 
SUM(CAST(vacc.new_vaccinations as float)) OVER  (Partition By dth.Location order by dth.Location, dth.Date ) as cumulativevaccinationbylocation
From PortfolioProject..CovidDeaths$ dth
join PortfolioProject..CovidVaccinations$ vacc
on dth.location=vacc.location
and dth.date=vacc.date 
where dth.continent is not null