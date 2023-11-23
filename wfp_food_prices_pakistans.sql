#Answering all the questions of wfp_prices_pakistan

#Update the date in the wfp_food_prices_pakistan
SET SQL_SAFE_UPDATES = 0;
UPDATE wfp_food_prices_pakistan 
SET date = STR_TO_DATE(date,'%m/%d/%Y');

#Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal 50 PKR

#Select * from wfp_food_prices_pakistan
SELECT price, date, mktname as cities
FROM wfp_food_prices_pakistan
WHERE mktname IN ('Quetta', 'Karachi', 'Peshawar') AND price <= 50;

#Query to check number of observations against each market/city in PK
SELECT mktname, COUNT(*) as observation_count
FROM wfp_food_prices_pakistan
GROUP BY mktname;

#Show number of distinct cities
SELECT COUNT(DISTINCT mktname) as distinct_city_count
FROM wfp_food_prices_pakistan;

#List down/show the names of cities in the table
SELECT DISTINCT mktname as cities
FROM wfp_food_prices_pakistan;

#List down/show the names of commodities in the table
SELECT DISTINCT cmname
FROM wfp_food_prices_pakistan;

#List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.
SELECT mktname, ROUND(AVG(price), 2) as avg_price
FROM wfp_food_prices_pakistan
WHERE cmname = 'Wheat flour - Retail'
GROUP BY mktname;

#Calculate summary stats (avg price, max price) for each city 
#separately for all cities except Karachi and sort alphabetically the city names, 
#commodity names where commodity is Wheat (does not matter which one) with separate rows for each commodity

SELECT mktname, cmname, round(avg(price),2) as avg_price, MAX(price) as max_price
FROM wfp_food_prices_pakistan
WHERE mktname != 'Karachi' AND cmname LIKE 'Wheat%'
GROUP BY mktname, cmname
ORDER BY mktname, cmname;

#Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less than 30
SELECT mktname, Round(AVG(price),2) as avg_price
FROM wfp_food_prices_pakistan
WHERE cmname = 'Wheat - Retail'
GROUP BY mktname
HAVING AVG(price) < 30;

#Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 is HIGH, in between are FAIR)
SELECT mktname, cmname, price,
    CASE 
        WHEN price < 30 THEN 'LOW'
        WHEN price > 250 THEN 'HIGH'
        ELSE 'FAIR'
    END as price_category
FROM wfp_food_prices_pakistan;

#Create a query showing date, cmname, category, city, price, city_category where Logic for city category is:
#Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'

SELECT date, cmname, 
    CASE 
        WHEN mktname IN ('Karachi', 'Lahore') THEN 'Big City'
        WHEN mktname IN ('Multan', 'Peshawar') THEN 'Medium-sized City'
        WHEN mktname = 'Quetta' THEN 'Small City'
        ELSE 'Other'
    END as city_category,
    mktname, price
FROM wfp_food_prices_pakistan;


#Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price is fair if less than 100, 
#unfair if more than or equal to 100, if > 300 then 'Speculative'
SELECT date, cmname, mktname, price,
    CASE 
        WHEN price < 100 THEN 'Fair'
        WHEN price >= 100 AND price <= 300 THEN 'Unfair'
        WHEN price > 300 THEN 'Speculative'
        ELSE NULL
    END as price_fairness
FROM wfp_food_prices_pakistan;

#Join the food prices and commodities table with a left join. 
SELECT *
FROM wfp_food_prices_pakistan
LEFT JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;

#Join the food prices and commodities table with an inner join
SELECT *
FROM wfp_food_prices_pakistan
INNER JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;


