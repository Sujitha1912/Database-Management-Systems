use world;
show tables;
/*Question a
the most populated city in each country.*/
select name,countrycode,max(population) as population
from city
group by countrycode
order by countrycode;

/*question b 
the second most populated city in each country*/
select name,countrycode,max(population) as secondhighlypopulated
from city where population  not in (select max(population) from city group by countrycode)group by countrycode order by countrycode;

/*question c
the most populated city in each continent.*/
select c.name as cityname, ct.continent,max(c.population) as highestpopulation
from city c 
	inner join country ct on ct.code=c.countrycode
group by ct.continent;

/*question d
the most populated country in each continent.*/
select name as countryname,continent,max(population) as highestpopulation
from country 
group by continent;

/*question e
the most populated continent.*/
select continent,sum(population) as populationpercontinent
from country 
group by continent
order by populationpercontinent desc limit 1;

/*question f 
 the most spoken official language based on each continent. 
 (the language that has the highest number of people talking as their mother tongue)*/
select Continent,language,isofficial as official, ceiling(max(numberofpeoplespeaking)) as numberofpeopletalking  from (
select Continent,language,isofficial, sum(Population * Percentage *0.01) as numberofpeoplespeaking from country c
inner join countrylanguage cl on cl.CountryCode = c.Code
where cl.isofficial ='t'
group by cl.Language, c.Continent
order by population desc
) x
group by Continent
order by continent;

/*question g 
the country with the most (number of) unofficial languages based on each continent. 
(no matter how many people talking that language)*/
select name as countryname,continent,max(number) as maximum 
from (select name,continent,count(*) as number,countrycode,isofficial from countrylanguage cl
inner join country ct on ct.code=cl.countrycode
where isofficial='f' 
group by countrycode
order by number desc
)x
group by continent
order by continent;

/*question h
 the number of languages that are the official language of at least one country.*/
select distinct language, count(*)
from countrylanguage
where isofficial='t'
group by language;

/*question i 
the number of people speaking each language.*/
/*city wise*/
select cl.language,ceiling(sum(c.population*cl.percentage*0.01)) as numberofpeoplespeaking
from countrylanguage cl 
	inner join city c on c.countrycode=cl.CountryCode
group by cl.language;
/*country wise*/
select cl.language,ceiling(sum(c.population*cl.percentage*0.01)) as numberofpeoplespeaking
from countrylanguage cl 
inner join country c on c.code=cl.CountryCode
group by cl.language;

/*question J
the most spoken language in each continent. */
select Language, Continent, ceiling(max(numberofpeoplespeaking)) as count from (
select Language, Continent, sum(Population * Percentage *0.01) as numberofpeoplespeaking from country c
inner join countrylanguage cl on cl.CountryCode = c.Code
group by cl.Language, c.Continent
order by numberofpeoplespeaking desc
) x
group by Continent;

/*question k 
the countries that their capital is not the most populated city in the country.*/
select id,c.capital,ct.name,c.name as countryname, max(c.population) as mostpopulatedcity 
from city ct
inner join country c on c.code=ct.countrycode
group by countrycode 
having capital<>ct.id;

/*question l 
the countries with populations smaller than the United States but bigger than Denmark.*/
select code,name
from country 
where population < (select population from country where name='united states') 
and population > (select population from country where name='denmark');