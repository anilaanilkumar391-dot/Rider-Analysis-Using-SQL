
-- =========================================
-- RIDERS DATA ANALYSIS USING SQL
-- =========================================

create database riders_analysis;
use riders_analysis;
show tables;
describe drivers;
select name from drivers;


-- Q1. Total number of rides
SELECT COUNT(*) AS total_rides
FROM rides;

-- Q2. Rides by starting location
SELECT start_location, COUNT(*) AS total_rides
FROM rides
GROUP BY start_location
ORDER BY total_rides DESC;

-- Q3. Analyze ride fares
SELECT
    SUM(fare_amount) AS total_revenue,
    AVG(fare_amount) AS average_fare
FROM rides;

-- Q4. Top 10 drivers by number of rides
SELECT
    d.driver_id,
    d.name,
    COUNT(r.ride_id) AS total_rides
FROM drivers d
JOIN rides r
    ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.name
ORDER BY total_rides DESC
LIMIT 10;

-- Q5. Top 10 users by ride count
SELECT
    u.user_id,
    u.name,
    COUNT(r.ride_id) AS total_rides
FROM users u
JOIN rides r
    ON u.user_id = r.user_id
GROUP BY u.user_id, u.name
ORDER BY total_rides DESC
LIMIT 10;

-- Q6. Most popular routes
SELECT
    start_location,
    end_location,
    COUNT(*) AS total_rides
FROM rides
GROUP BY start_location, end_location
ORDER BY total_rides DESC
LIMIT 10;

-- Q7. Vehicle usage analysis
SELECT
    v.make,
    v.model,
    COUNT(r.ride_id) AS total_rides
FROM vehicles v
JOIN drivers d
    ON v.vehicle_id = d.vehicle_id
JOIN rides r
    ON d.driver_id = r.driver_id
GROUP BY v.make, v.model
ORDER BY total_rides DESC;

-- Q8. Find highly rated drivers
SELECT
    d.driver_id,
    d.name,
    AVG(rt.rating_value) AS average_rating
FROM drivers d
JOIN rides r
    ON d.driver_id = r.driver_id
JOIN ratings rt
    ON r.ride_id = rt.ride_id
GROUP BY d.driver_id, d.name
HAVING AVG(rt.rating_value) > 3;

-- Q9. Users without rides
SELECT
    u.user_id,
    u.name
FROM users u
LEFT JOIN rides r
    ON u.user_id = r.user_id
WHERE r.ride_id IS NULL;

-- Q10. Find the average ride distance for each driver

SELECT
    d.driver_id,
    d.name,
    AVG(r.distance_km) AS average_distance
FROM drivers d
INNER JOIN rides r
    ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.name
ORDER BY average_distance DESC;

-- Q11. Find long-distance rides
SELECT
    ride_id,
    distance_km,
    fare_amount
FROM rides
WHERE distance_km > 20
ORDER BY distance_km DESC;

-- Q12. Find rides above average fare
SELECT AVG(fare_amount)
    FROM rides;

SELECT
    ride_id,
    user_id,
    driver_id,
    fare_amount
FROM rides
WHERE fare_amount > (
    SELECT AVG(fare_amount)
    FROM rides
);

-- Q13. Highest and lowest ride fares
SELECT
    MAX(fare_amount) AS highest_fare,
    MIN(fare_amount) AS lowest_fare
FROM rides;

-- Q14. Analyze customer ratings
SELECT
    rating_value,
    COUNT(*) AS total_ratings
FROM ratings
GROUP BY rating_value
ORDER BY rating_value;

-- Q15. Find drivers with ratings above the average rating
SELECT AVG(rating_value)
    FROM ratings;

SELECT
    d.driver_id,
    d.name,
    AVG(rt.rating_value) AS average_rating
FROM drivers d
JOIN rides r
    ON d.driver_id = r.driver_id
JOIN ratings rt
    ON r.ride_id = rt.ride_id
GROUP BY d.driver_id, d.name
HAVING AVG(rt.rating_value) > (
    SELECT AVG(rating_value)
    FROM ratings
);

-- Q16. Find the driver who received the maximum fare amount

SELECT
    d.driver_id,
    d.name,
    r.fare_amount
FROM drivers d
INNER JOIN rides r
    ON d.driver_id = r.driver_id
WHERE r.fare_amount = (
    SELECT MAX(fare_amount)
    FROM rides
);