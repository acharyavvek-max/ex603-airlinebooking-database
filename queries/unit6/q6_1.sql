-- Task 6.1.1
-- How does each booking fare compare to its flight's average fare?

SELECT
    booking_id,
    flight_id,
    fare_paid,
    AVG(fare_paid) OVER (
        PARTITION BY flight_id
    ) AS avg_flight_fare
FROM bookings
ORDER BY flight_id, booking_id;

-- Task 6.1.1
-- What is the average fare paid for each flight?

SELECT
    flight_id,
    AVG(fare_paid) AS avg_flight_fare
FROM bookings
GROUP BY flight_id
ORDER BY flight_id;

--Compare 
SELECT
    COUNT(*) AS window_function_rows,
    COUNT(DISTINCT flight_id) AS group_by_rows
FROM bookings;

-- Task 6.1.2
-- Rank flights by total bookings using three ranking methods.

WITH flight_bookings AS (
    SELECT
        flight_id,
        COUNT(*) AS total_bookings
    FROM bookings
    GROUP BY flight_id
)
SELECT
    flight_id,
    total_bookings,
    ROW_NUMBER() OVER (
        ORDER BY total_bookings DESC, flight_id
    ) AS row_num,
	
    RANK() OVER (
        ORDER BY total_bookings DESC
    ) AS booking_rank,
	
    DENSE_RANK() OVER (
        ORDER BY total_bookings DESC
    ) AS dense_booking_rank
FROM flight_bookings
ORDER BY total_bookings DESC, flight_id;


-- Task 6.1.3
-- Divide flights into four bands based on booking volume.

WITH flight_bookings AS (
    SELECT
        flight_id,
        COUNT(*) AS total_bookings
    FROM bookings
    GROUP BY flight_id
)
SELECT
    flight_id,
    total_bookings,
    NTILE(4) OVER (
        ORDER BY total_bookings DESC, flight_id
    ) AS booking_band
FROM flight_bookings
ORDER BY booking_band, total_bookings DESC, flight_id;