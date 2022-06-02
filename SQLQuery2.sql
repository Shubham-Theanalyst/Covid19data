-- Select data
select * from covid_deaths order by 3;
select * from covid_vac order by 3;

select location, date, total_cases, new_cases, total_deaths, population 
from covid_deaths order by 1,2


select sum(total_cases) as 'sum of total cases' from covid_deaths;

--Total cases vs total deaths
select location, date, total_cases,  total_deaths, 
(total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths order by 1,2

--Total cases vs total deaths in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths where location = 'India'
order by 1,2;


select location, sum(total_cases) from covid_deaths 
group by location order by 1;

--Total Cases VS Population
select location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
from covid_deaths order by 1;

--Total Deaths VS Population
select location, date, population, total_cases, total_deaths, 
(total_deaths/population)*100 as DeathPercentage, (total_cases/population)*100 as CasePercentage
from covid_deaths order by 1;


select location, date, population, total_cases, total_deaths, 
(total_deaths/population)*100 as DeathPercentage, (total_cases/population)*100 as CasePercentage
from covid_deaths where location = 'India' order by 1;

--Country with maximum cases
select location, max(total_cases) from covid_deaths
group by location order by 2 desc;

--Country with maximum cases and high infection percentage
select location, max(total_cases) as HighestCase, max((total_cases/population))*100 as InfectedPercentage 
from covid_deaths group by location order by 3 desc;

--Countries with high infection rate compare to population
select location, sum(population) as SumOfPopulation,max(total_cases) as HighestCases, max((total_cases/population))*100 as 
InfectedPercentage from covid_deaths group by location
order by 2 desc;

--Country with highest death count
select location, sum(cast (total_deaths as int)) from covid_deaths
group by location order by 2 desc;

--Continent with maximum cases
select continent, max(total_cases)  from covid_deaths 
group by continent order by 2 desc;


--Global Data
select date, sum(total_cases) as total_cases, sum(cast(total_deaths as int)) as total_death,
sum(cast(total_deaths as int))/sum(total_cases)*100 as DeathPercentage
from covid_deaths group by date order by 1,2;

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from covid_deaths order by 1,2;

select sum(cast(new_deaths as int)) from covid_deaths;


select * from 
covid_deaths as dea
join covid_vac as vac
on dea.continent= vac.continent
and dea.date= vac.date
order by vac.location asc;


select dea.continent,dea.location,dea.date, dea.population,  vac.new_vaccinations
from covid_deaths dea
join covid_vac vac
on dea.continent = vac.continent
and dea.date = vac.date
where vac.continent is not null
order by 2,3;

--Country wise vaccination
select continent, location, date, population, new_vaccinations,
SUM(convert(int, new_vaccinations)) over (partition by location order by location,date )
from covid_vac 
order by location;


select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from covid_deaths dea join covid_vac vac
on dea.date= vac.date and dea.location= vac.location
order by 2,3;

select  location,  sum(population), sum(cast(new_vaccinations as int))
from covid_vac group by location
order by 1,2


select location, sum(cast(new_vaccinations as int))
from covid_vac group by location
order by 1;


--Temp Table
create table #PercentPeopleVaccinated(
continent varchar(20),
location varchar(30),
date date,
Population int,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from covid_deaths dea join covid_vac vac
on dea.date= vac.date and dea.location= vac.location


--Percentage of population recieve vaccination
select * , (RollingPeopleVaccinated/population)*100
from #PercentPeopleVaccinated