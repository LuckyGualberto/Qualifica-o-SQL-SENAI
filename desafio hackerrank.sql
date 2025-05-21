-- https://www.hackerrank.com/challenges/select-all-sql/problem?isFullScreen=true
select * from city;
-- https://www.hackerrank.com/challenges/select-by-id/problem?isFullScreen=true

select * from city where ID = '1661';
-- https://www.hackerrank.com/challenges/weather-observation-station-1/problem?isFullScreen=true

select city,state from station;
select * from CITY where COUNTRYCODE = 'JPN';

-- https://www.hackerrank.com/challenges/revising-the-select-query/problem?isFullScreen=true
select * from city where population >'100000' and CountryCode ='USA';

-- https://www.hackerrank.com/challenges/revising-the-select-query-2/problem?isFullScreen=true
select name from city where population > 120000 and CountryCode ='USA';

-- https://www.hackerrank.com/challenges/weather-observation-station-6/problem?isFullScreen=true
select distinct city from station where city like 'A%';
select distinct city from station where city like 'E%';
select distinct city from station where city like 'I%';
select distinct city from station where city like 'O%';
select distinct city from station where city like 'U%';


-- https://www.hackerrank.com/challenges/weather-observation-station-7/problem?isFullScreen=true

select distinct city from station where city like '%A';
select distinct city from station where city like '%E';
select distinct city from station where city like '%I';
select distinct city from station where city like '%O';
select distinct city from station where city like '%U';

-- https://www.hackerrank.com/challenges/weather-observation-station-8/problem?isFullScreen=true
select distinct city from station where (city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%')
 and  (city like '%A' or city like '%E' or city like '%I' or city like '%O' or city like '%U');