-- =====================================================
-- Task 6.3 Part A: Top N per category
-- Question: What are the three highest-paying bookings
-- for each flight?
-- =====================================================

-- ROW_NUMBER returns at most three bookings per flight.
-- Ties at third place are resolved using booking_id
-- to ensure consistent results and limit the output
-- to a maximum of three bookings per flight.

WITH ranked_bookings AS (
    SELECT
        booking_id,
        flight_id,
        fare_paid,

        ROW_NUMBER() OVER (
            PARTITION BY flight_id
            ORDER BY fare_paid DESC NULLS LAST, booking_id
        ) AS fare_rank,

        FIRST_VALUE(fare_paid) OVER (
            PARTITION BY flight_id
            ORDER BY fare_paid DESC NULLS LAST, booking_id
        ) AS highest_flight_fare

    FROM bookings
)
SELECT
    booking_id,
    flight_id,
    fare_paid,
    fare_rank,
    highest_flight_fare
FROM ranked_bookings
WHERE fare_rank <= 3
ORDER BY flight_id, fare_rank;


-- =====================================================
-- Task 6.3 Part B: Period-over-period analysis
-- Question: Is the airline booking platform getting
-- better or worse in terms of monthly booking volume,
-- fare amounts, and booking failure rates?
-- =====================================================

-- Failure is defined as a cancelled or disputed booking.
-- The overall platform failure rate is 22%.
-- Month-over-month comparisons are calculated only
-- when the previous calendar month exists.

WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', booked_at) AS booking_month,
        COUNT(*) AS total_bookings,
        SUM(fare_paid) AS total_fare_paid,

        SUM(
            CASE
                WHEN booking_status = 'confirmed' THEN 1
                ELSE 0
            END
        ) AS confirmed_bookings,

        SUM(
            CASE
                WHEN booking_status = 'cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN booking_status = 'disputed' THEN 1
                ELSE 0
            END
        ) AS disputed_bookings,

        SUM(
            CASE
                WHEN booking_status IN ('cancelled', 'disputed')
                THEN 1
                ELSE 0
            END
        ) AS total_failures,

        100.0 * SUM(
            CASE
                WHEN booking_status IN ('cancelled', 'disputed')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS failure_rate_pct

    FROM bookings
    GROUP BY DATE_TRUNC('month', booked_at)
),
monthly_comparison AS (
    SELECT
        *,

        LAG(booking_month) OVER (
            ORDER BY booking_month
        ) AS previous_month,

        LAG(total_bookings) OVER (
            ORDER BY booking_month
        ) AS previous_bookings,

        LAG(total_fare_paid) OVER (
            ORDER BY booking_month
        ) AS previous_fare_paid,

        LAG(failure_rate_pct) OVER (
            ORDER BY booking_month
        ) AS previous_failure_rate

    FROM monthly_metrics
)
SELECT
    booking_month,
    total_bookings,
    total_fare_paid,
    confirmed_bookings,
    cancelled_bookings,
    disputed_bookings,
    total_failures,

    ROUND(failure_rate_pct, 2) AS failure_rate_pct,

    previous_month,
    previous_bookings,
    previous_fare_paid,

    ROUND(previous_failure_rate, 2)
        AS previous_failure_rate_pct,

    -- Month-over-month booking volume change
    CASE
        WHEN booking_month = previous_month + INTERVAL '1 month'
        THEN ROUND(
            100.0 * (total_bookings - previous_bookings)
            / NULLIF(previous_bookings, 0), 2
        )
    END AS booking_change_pct,

    -- Month-over-month fare amount change
    CASE
        WHEN booking_month = previous_month + INTERVAL '1 month'
        THEN ROUND(
            100.0 * (total_fare_paid - previous_fare_paid)
            / NULLIF(previous_fare_paid, 0), 2
        )
    END AS fare_change_pct,

    -- Failure rate change in percentage points
    CASE
        WHEN booking_month = previous_month + INTERVAL '1 month'
        THEN ROUND(
            failure_rate_pct - previous_failure_rate, 2
        )
    END AS failure_rate_change_pp,

    -- Relative percentage change in failure rate
    CASE
        WHEN booking_month = previous_month + INTERVAL '1 month'
        THEN ROUND(
            100.0 * (failure_rate_pct - previous_failure_rate)
            / NULLIF(previous_failure_rate, 0), 2
        )
    END AS failure_rate_change_pct,

    -- Check for missing calendar months
    CASE
        WHEN previous_month IS NULL
            THEN 'First Month'
        WHEN booking_month = previous_month + INTERVAL '1 month'
            THEN 'No Gap'
        ELSE 'Missing Month'
    END AS month_gap_status

FROM monthly_comparison
ORDER BY booking_month;