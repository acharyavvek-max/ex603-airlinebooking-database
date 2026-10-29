-- Part A: 
-- Two numbers in one pass
-- For each producer, compute the total number of events and the total number of events classified as failures, 
-- in a single pass over the event table, without a WHERE clause filtering the whole query. 
-- The outliers here are the producers you will name in your finding.
-- CASE used inside an aggregate — for example SUM(CASE WHEN ... THEN 1 ELSE 0 END) or COUNT(CASE WHEN ... END).
-- Both totals appearing as separate columns in one result set.

SELECT
    flight_id,
    COUNT(*) AS total_number_of_events,
    COUNT(
        CASE
            WHEN booking_status = 'no_show' THEN 1
        END
    ) AS failures
FROM public.bookings
GROUP BY flight_id
ORDER BY failures DESC;


-- Part B:
-- Subtotals and a grand total
-- The regional director wants subtotals per region and a platform grand total, not the detail rows. 
-- Write a query that produces regional subtotals and a platform-wide grand total without including the individual detail rows.
-- GROUP BY ROLLUP (...), or GROUPING SETS or CUBE.
-- A written note identifying which rows are the subtotals and which is the grand total.

--Grand Total is grand total, others are by region(country)
select
case when grouping(booking_country) = 1 then 'Grand Total'
else booking_country end as booking_country
, sum(fare_paid)
FROM public.bookings
GROUP BY ROLLUP (booking_country)


-- Part C: 
-- A two-step pipeline
-- Leadership wants to establish a baseline for evaluating high-volume producers. 
-- That needs two steps: use a WITH clause to create an intermediate result that summarizes performance for each producer, then use a second aggregation or filter on that intermediate result to calculate a baseline for high-volume producers.
-- A WITH clause producing an intermediate aggregate.
-- A second aggregation or filter applied to that intermediate result.

-- Solution:
-- What is the overall failure rate among
-- Which flights have high booking volumes,
-- and how do their failure rates compare to the baseline?

WITH flight_summary AS (
    SELECT
        flight_id,
        COUNT(*) AS total_bookings,
        SUM(CASE
            WHEN cancellation_reason = 'Passenger no show' THEN 1
            ELSE 0
        END) AS total_failures
    FROM public.bookings
    GROUP BY flight_id
)

SELECT
    flight_id,
    total_bookings,
    total_failures,
    ROUND(
        100.0 * total_failures / total_bookings, 2
    ) AS failure_rate_pct,
    ROUND(
        100.0 * SUM(total_failures) OVER ()
        / SUM(total_bookings) OVER (), 2
    ) AS baseline_failure_rate_pct
FROM flight_summary
WHERE total_bookings >= 1
ORDER BY failure_rate_pct DESC;

-- write up
-- ### Part A: Conditional Aggregation
-- The query answers two questions: How many total bookings does each flight have, and how many resulted in passenger no-shows? It helps identify flights with the highest number of failures.

-- ### Part B: Subtotals and Grand Total
-- The regional director needs revenue subtotals by country instead of individual booking records. The grand total shows overall platform revenue and supports company-wide financial evaluation.

-- ### Part C: Two-Step Pipeline
-- The query identifies flights meeting the booking-volume threshold and compares their individual no-show rates against the overall baseline. This helps leadership identify flights with unusually high failure rates.
