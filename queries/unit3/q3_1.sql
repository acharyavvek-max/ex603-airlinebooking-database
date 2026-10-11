
--Q1
--Find active, highly rated producers. Use your theme’s 
--filter condition from the appendix. Sort them and return the first ten.

select 
flight_id,
flight_number,
seat_capacity 
from flights
where is_active = true AND seat_capacity >= 180
order by seat_capacity desc
limit 10



--Q2
--Find all possible event statuses. 
--Display the distinct values in the event status column. 
--Look carefully at the results. Are there more statuses than you expected?


SELECT DISTINCT booking_status
FROM bookings
ORDER BY booking_status;



-- Q3
-- Filter the events in two different ways. 
-- Write: one query that filters a numeric range, 
-- and one query that filters using an explicit list of values with IN.

--fare_multiplier  between 1 and 2
select  *
from bookings
where  fare_multiplier between 1 and 2
-- where fare_multiplier > 1 and fare_multiplier < 2


-- using IN
select  *
from bookings
where booking_country in ('vietnam', 'Japan')


-- Q4
-- Passenger names matching a pattern
-- Requirement: LIKE.
-- Question: Which passenger names begin with Passenger_0?

SELECT passenger_id, passenger_name
FROM passengers
WHERE passenger_name like 'Passenger/_0%' ESCAPE '/'


-- Bookings with missing cancellation reasons
-- Requirement: IS NULL.
-- Question: Which bookings have no cancellation reason recorded?

SELECT booking_id, booking_status, cancellation_reason
FROM bookings
WHERE cancellation_reason IS NULL
ORDER BY booking_id;


-- Display readable cancellation reasons
-- Requirement: COALESCE.
-- Question: How can missing cancellation reasons be displayed clearly?

SELECT
    booking_id,
    booking_status,
    COALESCE(cancellation_reason, 'No reason provided') AS reason
FROM bookings
ORDER BY booking_id;


-- Q5
-- Classify bookings by fare multiplier
-- Requirement: Computed columns and CASE.
-- Question: What is each booking's fare category and estimated base fare?

SELECT
    booking_id,
    fare_paid,
    fare_multiplier,
    ROUND(fare_paid / fare_multiplier, 2) AS estimated_base_fare,
    CASE
        WHEN fare_multiplier = 1 THEN 'Standard fare'
        WHEN fare_multiplier <= 1.5 THEN 'Moderate fare'
        ELSE 'High fare'
    END AS fare_category
FROM bookings
ORDER BY booking_id;
