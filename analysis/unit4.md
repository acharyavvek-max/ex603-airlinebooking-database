
### Task 4.1: Aggregate Analysis

An airline operations manager would use the per-flight breakdown to compare booking volumes and average fares across flights and identify differences in performance.

However, aggregate statistics can hide important details. Average fare does not show the distribution of ticket prices, while total booking counts do not reveal which passengers are booking or whether bookings result in cancellations or no-shows.

To investigate further, I would examine fare distributions, booking statuses, and passenger no-show rates for individual flights. I would also focus on flights with booking volumes at or above the average to make more meaningful comparisons.

### Task 4.1: 
### Part A: Conditional Aggregation
The query answers two questions: How many total bookings does each flight have, and how many resulted in passenger no-shows? It helps identify flights with the highest number of failures.

### Part B: Subtotals and Grand Total
The regional director needs revenue subtotals by country instead of individual booking records. The grand total shows overall platform revenue and supports company-wide financial evaluation.

### Part C: Two-Step Pipeline
The query identifies flights meeting the booking-volume threshold and compares their individual no-show rates against the overall baseline. This helps leadership identify flights with unusually high failure rates.



### Reflection: Conditional Aggregation vs. Separate Queries

Conditional aggregation is an efficient way to calculate multiple metrics in a single SQL query. In my airline booking dataset, I used `COUNT(*)` to calculate total bookings for each flight and `COUNT(CASE WHEN...)` to count passenger no-shows. This allowed me to retrieve both results side by side while grouping the data by `flight_id`.

An alternative approach would be to run two separate queries: one to count all bookings and another with a `WHERE` clause to count only passenger no-shows. However, this approach may require scanning the bookings table twice and combining the results afterward to compare them by flight.

When working with a million rows, this difference becomes important because scanning large datasets requires additional processing time and system resources. Conditional aggregation can reduce repeated data access and avoid unnecessary query execution overhead. It also makes the SQL easier to maintain because related calculations are handled together.

Although database optimizers and indexes can affect actual performance, conditional aggregation is generally a practical approach for reporting multiple related metrics. It improves efficiency, simplifies comparisons, and makes the results easier for leadership to interpret when analyzing booking volumes and passenger no-show rates.