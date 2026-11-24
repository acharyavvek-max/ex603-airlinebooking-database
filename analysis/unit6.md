# Unit 6: Window Functions and Analytical Reporting

## Platform Overview

- **Platform:** Airline Booking System
- **Producer:** flight_id
- **Event:** Individual booking
- **Metric:** fare_paid
- **Timestamp:** booked_at
- **Failure:** Bookings with a status of cancelled or disputed

## Task 6.1: Compute Across a Window Without Collapsing

### 1. Write a question that needs each row shown next to its group's average. Explain why the group average alone (GROUP BY) cannot answer it.

How does the fare paid for each booking compare with the average fare paid for the same flight?

This question requires both the individual booking fare and the average fare for the corresponding flight. Using GROUP BY collapses all bookings associated with a flight into a single row, resulting in the loss of individual booking details. In contrast, using AVG() with a window function preserves all 200 booking records while displaying the average fare for each flight alongside each individual booking. This allows the airline to identify bookings with unusually high or low fares and investigate potential pricing inconsistencies.

### 2. Name a platform feature that would use your ranking, and explain which of the three functions it should use and why.

A flight popularity leaderboard could use ranking functions to display flights based on their total number of bookings. I would use DENSE_RANK() because flights with the same number of bookings should receive the same rank. Unlike ROW_NUMBER(), which assigns a unique number to every flight, DENSE_RANK() treats tied flights equally. It also avoids gaps in the ranking sequence, unlike RANK(). This makes the leaderboard fair and easier for management to interpret.

### Additional Observation: NTILE and Ties

NTILE(4) divides flights into four approximately equal-sized groups based on their booking volumes. However, flights with identical booking counts can be assigned to different bands when they fall on a group boundary. This happens because NTILE prioritizes maintaining approximately equal group sizes rather than keeping tied values together. Management should consider this limitation when using booking bands to classify flight performance.

## Task 6.2: Compare Each Row to Its Neighbors

### 1. What would a large delta tell someone about your platform, and what should they do about it?

A large delta between consecutive booking fares indicates a significant difference in the amount paid by passengers booking the same flight. This could result from dynamic pricing, promotional discounts, differences in ticket classes, or changes in passenger demand. The airline should investigate the factors contributing to these differences to determine whether they are expected pricing variations or potential pricing inconsistencies. Understanding these changes could help management improve its pricing strategies.

### 2. Why does a running total answer a question that a plain SUM cannot?

A plain SUM calculates the total fare amount for an entire period but does not show how that amount accumulated over time. A running total preserves individual booking records and calculates the cumulative fare amount after each booking. In my analysis, I selected a hypothetical quarterly target of $1,000. The running total allows management to monitor progress toward this target throughout the quarter rather than waiting until the quarter ends. It also helps identify periods when fare accumulation is slower or faster than expected.

### 3. Why did you pick your moving-average window size? A different size tells a different story.

I selected a seven-booking moving average because it helps smooth short-term fluctuations in booking fares while remaining responsive to recent changes. A smaller window could be overly sensitive to individual booking amounts, whereas a larger window could hide meaningful short-term pricing changes. Since my dataset contains only 200 bookings, a seven-booking window provides a reasonable balance between smoothing fluctuations and preserving recent trends.

Because the window uses ROWS rather than a calendar-based interval, it represents seven consecutive bookings, not seven calendar days.

### ROWS versus RANGE

ROWS defines a window based on the number of individual rows relative to the current row, whereas RANGE defines a window based on the ORDER BY value. When ordering by booked_at alone, RANGE can include multiple bookings with identical timestamps in the same cumulative calculation, while ROWS processes individual booking records according to their ordering.

### 4. What does a gap mean in your platform: a data quality problem, a real stop in activity, or a side effect of how events were recorded?

In my airline booking platform, a gap represents a period during which no booking events were recorded for a particular flight. I selected seven days as the threshold for identifying significant gaps between consecutive bookings.

These gaps could indicate low passenger demand, limited flight availability, booking restrictions, or missing records caused by data ingestion problems. However, the booking data alone does not provide enough evidence to determine the actual cause. Therefore, I interpret these gaps as interruptions in recorded booking activity rather than confirmed data quality problems or actual interruptions in flight operations.

To determine the cause, I would compare the identified gaps with flight schedules, seat availability, and data ingestion logs.

## Task 6.3: Build the Reporting Patterns

### 1. Name the feature in your platform that top-N would power. Explain why three is the right number, rather than one or ten.

The top-N query could power a fare analysis feature within the airline's management dashboard that displays the three highest-paying bookings for each flight. This would allow management to examine high-value bookings and better understand premium pricing opportunities.

Displaying only one booking would provide limited insight and could place too much emphasis on a single unusual transaction. Displaying ten bookings could introduce unnecessary information and make comparisons between flights more difficult. Selecting three bookings provides a reasonable balance between detail and simplicity.

I used ROW_NUMBER() to ensure that each flight returns a maximum of three bookings. When multiple bookings have the same fare, booking_id is used as a secondary sorting column to ensure consistent and deterministic results.

### 2. What would a large month-over-month change mean in your domain, and what should someone do about it?

A significant month-over-month change in booking volume or total fare amounts could indicate changes in passenger demand, seasonal travel patterns, promotional campaigns, ticket pricing, or flight availability.

The monthly analysis identified a 47.62% decline in booking volume and a 70.01% decline in total fare amounts in March compared to February 2023. Management should investigate passenger demand, pricing strategies, and flight availability during this period to understand the reasons behind the decline.

A significant increase in the booking failure rate could also indicate declining booking reliability. In my analysis, a failure is defined as a booking with a status of either cancelled or disputed. The overall dataset contains 44 failed bookings out of 200 total bookings, resulting in a baseline failure rate of 22%.

Management should investigate flights and booking categories that contribute disproportionately to failures and determine whether changes to booking policies, customer communication, or dispute resolution procedures could improve performance.

Additionally, I included a missing-month check because LAG() compares the current row with the previous available row, which may not necessarily represent the previous calendar month. This ensures that month-over-month comparisons are only calculated for consecutive months.

## Reflection

One reporting question in my airline booking platform that is easy to answer using window functions but difficult to answer using GROUP BY alone is how the fare paid for each booking compares with the average fare paid for the same flight.

A traditional GROUP BY query can calculate the average fare for each flight, but it collapses multiple booking records into a single row. As a result, individual booking details are lost, making it difficult to identify bookings with unusually high or low fares. Although this problem could be addressed using a subquery and a join, window functions provide a simpler and more readable solution.

By using AVG(fare_paid) OVER (PARTITION BY flight_id), I can calculate the average fare for each flight while preserving every individual booking record. This allows management to investigate unusual pricing patterns and better understand differences in passenger spending.

I also learned how window functions can support trend analysis and operational reporting. LAG() and LEAD() allow comparisons between consecutive bookings, while running totals and moving averages provide visibility into changes over time. Ranking functions also help build leaderboards without losing relevant details.

Overall, this assignment helped me understand that the choice between aggregation and window functions depends on whether the business question requires summarized information or individual records with additional analytical context.