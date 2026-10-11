-- 3.2A.1 Broken query
-- Question: How many bookings have a cancellation reason
-- other than 'Passenger no show'?

-- Explanation: 
-- The broken query excludes NULL values because NULL != 'Passenger no show' evaluates to UNKNOWN,
-- not TRUE. The repaired query explicitly includes those records.

SELECT COUNT(*) AS other_reason_count
FROM bookings
WHERE cancellation_reason != 'Passenger no show';


-- 3.2A.2 Count the rows excluded by the comparison
-- Question: How many bookings have the excluded reason
-- or a NULL cancellation reason?

SELECT
    COUNT(*) AS total_bookings,
    COUNT(*) FILTER (
        WHERE cancellation_reason != 'Passenger no show'
    ) AS other_reason_count,
    COUNT(*) FILTER (
        WHERE cancellation_reason = 'Passenger no show'
    ) AS no_show_count,
    COUNT(*) FILTER (
        WHERE cancellation_reason IS NULL
    ) AS null_reason_count
FROM bookings;


-- 3.2A.3 Repair the query
-- Question: How many bookings are not marked
-- 'Passenger no show', including missing reasons?

SELECT COUNT(*) AS corrected_count
FROM bookings
WHERE cancellation_reason != 'Passenger no show'
   OR cancellation_reason IS NULL;

-- Part B 
-- The Alias that did not exist yet
-- 3.2B.1 Broken query
-- Question: Which bookings have a fare with
-- multiplier applied greater than 20?

-- Explanation: 
-- PostgreSQL reports an error similar to column "adjusted_fare" does not exist.
-- This happens because WHERE is evaluated before SELECT, so the alias adjusted_fare is not available yet.
SELECT
    booking_id,
    fare_paid,
    fare_multiplier,
    fare_paid * fare_multiplier AS adjusted_fare
FROM bookings
WHERE adjusted_fare > 20;


-- 3.2B.2 Corrected using the full expression
-- Question: Which bookings have an adjusted fare over 20?

SELECT
    booking_id,
    fare_paid,
    fare_multiplier,
    fare_paid * fare_multiplier AS adjusted_fare
FROM bookings
WHERE fare_paid * fare_multiplier > 20
ORDER BY booking_id;

-- 3.2B.3 Corrected using a CTE
-- Question: Which bookings have an adjusted fare over 20?


WITH fare_calculation AS (
    SELECT
        booking_id,
        fare_paid,
        fare_multiplier,
        fare_paid * fare_multiplier AS adjusted_fare
    FROM bookings
)
SELECT *
FROM fare_calculation
WHERE adjusted_fare > 20
ORDER BY booking_id;