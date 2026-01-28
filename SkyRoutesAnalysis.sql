-- Import Data
CREATE DATABASE IF NOT EXISTS SkyRoutesAirlines;

USE SkyRoutesAirlines;

DROP TABLE IF EXISTS AirlineRoutesData;

CREATE TABLE AirlineRoutesData (
	FlightID INTEGER PRIMARY KEY,
	RouteCode TEXT,
	Origin TEXT,
	Destination TEXT,
	FlightDate DATE,
	SeatsAvailable INTEGER,
	SeatsSold INTEGER,
	Revenue REAL,
	OperationalCost REAL,
	FlightDurationMins INTEGER
);

-- Insert data from AirlineRoutesData.csv
LOAD DATA LOCAL INFILE 'D:/PRATH LAPTOP DATA/Business_Case_Study_Practical-Exam/AirlineRoutesData.csv' INTO TABLE AirlineRoutesData FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 ROWS;

-- SkyRoutes Airlines SQL Analysis
-- 1. Top 10 most frequent routes
SELECT
	RouteCode,
	COUNT(*) AS TotalFlights
FROM
	AirlineRoutesData
GROUP BY
	RouteCode
ORDER BY
	TotalFlights DESC
LIMIT
	10;

-- 2. Average revenue, cost, and profit per route
SELECT
	RouteCode,
	AVG(Revenue) AS AvgRevenue,
	AVG(OperationalCost) AS AvgCost,
	AVG(Revenue - OperationalCost) AS AvgProfit
FROM
	AirlineRoutesData
GROUP BY
	RouteCode;

-- 3. Underperforming routes
SELECT
	RouteCode,
	AVG(Revenue - OperationalCost) AS AvgProfit
FROM
	AirlineRoutesData
GROUP BY
	RouteCode
HAVING
	AvgProfit < 0;

-- 4. Seat occupancy %
SELECT
	RouteCode,
	AVG((SeatsSold * 100.0) / SeatsAvailable) AS AvgOccupancy
FROM
	AirlineRoutesData
GROUP BY
	RouteCode;

-- 5. Monthly profit trend
SELECT
	strftime('%Y-%m', FlightDate) AS Month,
	RouteCode,
	SUM(Revenue - OperationalCost) AS MonthlyProfit
FROM
	AirlineRoutesData
GROUP BY
	Month,
	RouteCode;

-- 6. Domestic vs International profitability
SELECT
	CASE
		
		WHEN Origin IN ('BOM', 'DEL', 'BLR', 'HYD', 'MAA')
		AND Destination IN ('BOM', 'DEL', 'BLR', 'HYD', 'MAA') THEN 'Domestic'
		ELSE 'International'
	END AS RouteType,
	AVG(Revenue - OperationalCost) AS AvgProfit
FROM
	AirlineRoutesData
GROUP BY
	RouteType;

-- 7. Revenue per minute ranking
SELECT
	RouteCode,
	AVG(Revenue / FlightDurationMins) AS RevenuePerMinute
FROM
	AirlineRoutesData
GROUP BY
	RouteCode
ORDER BY
	RevenuePerMinute DESC;