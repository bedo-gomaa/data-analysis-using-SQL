use covid
--select *from CovidDeaths
--select *from CovidVaccinations$



select location,date, total_cases ,new_cases,total_deaths,population
from CovidDeaths order by 1,2

-- total cases vs total deathes

select location,date, total_cases ,total_deaths,(total_deaths/total_cases )*100 as "deth %"
from CovidDeaths  where location  like '%state%' order by 1,2 
 

 -- find out total cases vs population 
 select location,date, total_cases ,total_deaths, population, (total_cases/population )*100 as "effected population  %"
from CovidDeaths  where location  like '%state%' order by 1,2 


-- countries with highest infection rate regarding to  population 

 select location, population, max(total_cases) as "highst infection " , max ((total_cases/population ))*100 as "effected population  %"
from CovidDeaths  group by location,population  order by "effected population  %" desc

-- the largest country which has th largest deth rate 

select location,MAX(cast ("total_deaths"as int) ) as "total deth count"
from CovidDeaths where location is not null group by location ,population order by "total deth count" desc


-- sperate world to continent  
select continent,MAX(cast ("total_deaths"as int) ) as "total deth count" 
from CovidDeaths where continent is not null  group by continent  order by "total deth count" desc


--global prosbective

 select date, sum(new_cases) as "totla cases" ,sum (cast (new_deaths as int )) as "total dethes ",sum (cast (new_deaths as int ))/sum (new_cases )*100 as "deth perce"
from CovidDeaths where continent is not null  group by date 
order by 1,2 


-- the over all  total cases for whole world 

 select  sum(new_cases) as "totla cases" ,sum (cast (new_deaths as int )) as "total dethes ",sum (cast (new_deaths as int ))/sum (new_cases )*100 as "deth perce"
from CovidDeaths where continent is not null 
order by 1,2 

-- join to tables together

select * from  CovidDeaths dea join CovidVaccinations$ vac  on dea.location = vac.location and dea.date = vac.date 


-- total vacsenation vs population        ==> we but dea. becouse date and location and population are in the same table so if i but it without dea or alias for which table i mean it will bring error

select dea.continent, dea.location, dea.date ,dea.population  , vac.new_vaccinations ,sum(cast(vac.new_vaccinations as int )) over (partition by dea.location)
from  CovidDeaths dea join CovidVaccinations$ vac  on dea.location = vac.location and dea.date = vac.date 
where dea.continent is not null order by 2,3