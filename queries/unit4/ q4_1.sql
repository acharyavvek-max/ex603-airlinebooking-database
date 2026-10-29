
-- Event: Booking
-- Producer: Flight (flight_id)
-- Metric: Fare paid (fare_paid)

-- Task 4.1.1
-- Calculate the following statistics across the entire event table using your theme's metric:
--the count, total, average, minimum, and maximum 
--of your theme’s metric across the whole event table, and how many distinct actors appear. 
--Review your results carefully. For example, 
--if your metric should never be zero but your minimum value is zero, 
--this may indicate another data-quality issue that needs investigation.
SELECT
    COUNT(*) AS event_count,
    SUM(fare_paid) AS total_fare,
    AVG(fare_paid) AS average_fare,
    MIN(fare_paid) AS minimum_fare,
    MAX(fare_paid) AS maximum_fare,
    COUNT(DISTINCT passenger_id) AS distinct_actors
FROM public.bookings;

-- Task 4.1.2
-- Write a query that calculates the event count and average metric for each producer. 
-- Sort the results from the producer with the most events to the producer with the fewest. 
-- Consider what these results tell you about differences in activity and performance across producers.

SELECT
    flight_id,
    COUNT(*) AS total_bookings,
    ROUND(AVG(fare_paid), 2) AS average_fare
FROM public.bookings
GROUP BY flight_id
ORDER BY total_bookings DESC;

-- Task 4.1.3
-- Which producers have enough volume for their rate to mean anything? 
-- A producer with only a few events may have a high failure rate that
-- is not representative of their usual performance.
-- Choose a minimum event-count threshold and 
-- use HAVING to include only producers who meet that threshold. 
-- Explain why you selected your threshold.

-- Reasoning:
-- I selected the average
-- number of bookings per flight 
-- as the minimum volume threshold.
-- This allows the analysis to focus on flights with booking activity at or above the dataset's average, while excluding lower-volume flights whose failure rates may be more sensitive to individual events. However, this threshold does not guarantee statistical reliability, 
-- so additional investigation
-- may be needed before drawing conclusions about flight performance.

SELECT
    flight_id,
    COUNT(*) AS total_bookings
FROM public.bookings
GROUP BY flight_id
HAVING COUNT(*) >= (
    SELECT AVG(booking_count)
    FROM (
        SELECT COUNT(*) AS booking_count
        FROM public.bookings
        GROUP BY flight_id
    ) AS flight_counts
)
ORDER BY total_bookings DESC;

-- Task 4.1.4
-- How does the picture change along two dimensions at once? Leadership also wants
-- to understand how performance varies across regions.
-- Write a query that groups the data by two dimensions, including region, and calculates the relevant summary statistics.
-- Your results should contain one row for each combination of the 
-- two dimensions so that regional leaders can review their results.

select 
booking_country,
booking_status,
count(*) as total_booking
from  public.bookings
group by booking_country,booking_status



