-- =====================================================
-- Task 6.2 Part A: Row-to-row comparison
-- Question: How does the fare paid change between
-- consecutive bookings for the same flight?
-- =====================================================

WITH booking_trends AS (
    SELECT
        booking_id,
        flight_id,
        booked_at,
        fare_paid,
        LAG(fare_paid) OVER (
            PARTITION BY flight_id
            ORDER BY booked_at, booking_id
        ) AS previous_fare,
        LEAD(fare_paid) OVER (
            PARTITION BY flight_id
            ORDER BY booked_at, booking_id
        ) AS next_fare
    FROM bookings
)
SELECT
    *,
    fare_paid - previous_fare AS fare_delta
FROM booking_trends
WHERE flight_id = (
    SELECT flight_id
    FROM bookings
    GROUP BY flight_id
    ORDER BY COUNT(*) DESC, flight_id
    LIMIT 1
)
ORDER BY booked_at, booking_id;


-- =====================================================
-- Task 6.2 Part B: Cumulative and smoothed
-- Question: How does the cumulative fare amount grow
-- over time, and how close does it get to the quarterly
-- target of $1,000?
-- =====================================================

-- The quarterly target of $1,000 is an assumed target.
-- The moving average covers seven consecutive bookings,
-- not seven calendar days.

WITH booking_metrics AS (
    SELECT
        booking_id,
        flight_id,
        booked_at,
        fare_paid,
        DATE_TRUNC('quarter', booked_at) AS booking_quarter,

        SUM(fare_paid) OVER (
            PARTITION BY DATE_TRUNC('quarter', booked_at)
            ORDER BY booked_at, booking_id
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_total,

        AVG(fare_paid) OVER (
            ORDER BY booked_at, booking_id
            ROWS BETWEEN 6 PRECEDING
                     AND CURRENT ROW
        ) AS moving_avg_7_bookings

    FROM bookings
)
SELECT
    booking_id,
    flight_id,
    booked_at,
    booking_quarter,
    fare_paid,
    ROUND(running_total, 2) AS running_total,
    ROUND(moving_avg_7_bookings, 2) AS moving_avg_7_bookings,
    1000 AS quarterly_target,
    ROUND(
        100.0 * running_total / 1000, 2
    ) AS target_achievement_pct,
    ROUND(
        1000 - running_total, 2
    ) AS remaining_to_target
FROM booking_metrics
ORDER BY booked_at, booking_id;


-- ROWS defines the window based on individual rows.
-- RANGE defines the window based on the ORDER BY value.
-- When ordered only by booked_at, RANGE can include
-- multiple bookings with the same timestamp, whereas
-- ROWS processes each booking individually.


-- =====================================================
-- Task 6.2 Part C: Where the series stops
-- Question: Which flights experienced gaps greater
-- than seven days between consecutive bookings?
-- =====================================================

WITH previous_bookings AS (
    SELECT
        booking_id,
        flight_id,
        booked_at,
        LAG(booked_at) OVER (
            PARTITION BY flight_id
            ORDER BY booked_at, booking_id
        ) AS previous_booked_at
    FROM bookings
),
booking_gaps AS (
    SELECT
        *,
        booked_at - previous_booked_at AS booking_gap
    FROM previous_bookings
)
SELECT
    flight_id,
    booking_id,
    previous_booked_at,
    booked_at,
    booking_gap
FROM booking_gaps
WHERE booking_gap > INTERVAL '7 days'
ORDER BY booking_gap DESC;