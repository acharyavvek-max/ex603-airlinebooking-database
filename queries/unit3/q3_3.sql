-- 3.3A: Subquery using IN
-- Question: Which passengers had bookings marked
-- as 'Passenger no show'?


SELECT passenger_id, passenger_name
FROM passengers
WHERE passenger_id IN (
    SELECT passenger_id
    FROM bookings
    WHERE cancellation_reason = 'Passenger no show'
)
ORDER BY passenger_id;

-- 3.3B: Common Table Expression
-- Question: Which passengers had bookings marked
-- as 'Passenger no show'?

WITH no_show_passengers AS (
    SELECT DISTINCT passenger_id
    FROM bookings
    WHERE cancellation_reason = 'Passenger no show'
)
SELECT p.passenger_id, p.passenger_name
FROM passengers p
JOIN no_show_passengers n
    ON p.passenger_id = n.passenger_id
ORDER BY p.passenger_id;


-- 3.3C: Correlated subquery using EXISTS
-- Question: Which passengers had bookings marked
-- as 'Passenger no show'?

SELECT p.passenger_id, p.passenger_name
FROM passengers p
WHERE EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.passenger_id = p.passenger_id
      AND b.cancellation_reason = 'Passenger no show'
)
ORDER BY p.passenger_id;




-- 3.3D: Verify all three queries return identical rows
-- Question: Do the IN, CTE, and EXISTS approaches
-- return exactly the same passenger records?

WITH
query_in AS (
    SELECT passenger_id, passenger_name
    FROM passengers
    WHERE passenger_id IN (
        SELECT passenger_id
        FROM bookings
        WHERE cancellation_reason = 'Passenger no show'
    )
),
query_cte AS (
    SELECT p.passenger_id, p.passenger_name
    FROM passengers p
    JOIN (
        SELECT DISTINCT passenger_id
        FROM bookings
        WHERE cancellation_reason = 'Passenger no show'
    ) n ON p.passenger_id = n.passenger_id
),
query_exists AS (
    SELECT p.passenger_id, p.passenger_name
    FROM passengers p
    WHERE EXISTS (
        SELECT 1
        FROM bookings b
        WHERE b.passenger_id = p.passenger_id
          AND b.cancellation_reason = 'Passenger no show'
    )
)
SELECT 'IN vs CTE' AS comparison,
       (SELECT COUNT(*) FROM (
           (SELECT * FROM query_in EXCEPT SELECT * FROM query_cte)
           UNION ALL
           (SELECT * FROM query_cte EXCEPT SELECT * FROM query_in)
       ) differences) AS different_rows

UNION ALL

SELECT 'IN vs EXISTS',
       (SELECT COUNT(*) FROM (
           (SELECT * FROM query_in EXCEPT SELECT * FROM query_exists)
           UNION ALL
           (SELECT * FROM query_exists EXCEPT SELECT * FROM query_in)
       ) differences);


-- 3.3E: Equivalence explanation
-- All three queries return the same passengers because
-- passenger_id is a primary key and the CTE uses DISTINCT.
--
-- If DISTINCT were removed from the CTE and a passenger
-- had multiple no-show bookings, the JOIN could return
-- duplicate passenger rows.
--
-- IN and EXISTS would still return each passenger once.
-- Therefore, duplicates are one condition that could
-- make the three approaches produce different results.

	   