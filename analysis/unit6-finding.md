# Unit 6: Leadership Findings and Recommendations

## Executive Summary

The objective of this analysis is to evaluate the performance of the airline booking platform, determine whether booking failures are increasing or decreasing over time, and provide actionable recommendations for the next quarter.

In this analysis, a booking failure is defined as a booking with a status of either cancelled or disputed. SQL aggregations, common table expressions (CTEs), and window functions were used to evaluate booking performance, identify trends, and compare performance across different periods.

## 1. Overall Platform Performance

The analysis identified the following booking status distribution:

| Booking Status | Total Bookings | Percentage |
|---|---:|---:|
| Confirmed | 156 | 78% |
| Cancelled | 34 | 17% |
| Disputed | 10 | 5% |
| Total | 200 | 100% |

The overall platform failure rate is calculated by dividing the total number of cancelled and disputed bookings by the total number of bookings.

**Overall failure rate = (34 + 10) / 200 × 100 = 22%**

The results indicate that 22% of all bookings resulted in either a cancellation or a dispute. Cancellations account for approximately 77.27% of all booking failures, making them the largest contributor to the platform's failure rate.

**Supporting query:** Booking status aggregation and overall failure rate validation query.

## 2. Is the Failure Problem Getting Better or Worse?

The period-over-period query developed in Task 6.3 Part B uses monthly aggregation and the LAG() window function to compare booking failure rates across consecutive calendar months.

The overall failure rate of 22% establishes a baseline for evaluating platform performance. However, the overall failure rate alone does not indicate whether booking reliability is improving or worsening over time.

The corrected monthly failure rate results must be evaluated before determining the direction of the failure trend. Comparing monthly and quarterly failure rates will help distinguish sustained performance changes from temporary fluctuations.

The analysis also includes a missing-month check to ensure that comparisons are made between consecutive calendar months rather than simply consecutive available records.

**Supporting query:** `queries/unit6/q6_3.sql` — Task 6.3 Part B.

## 3. Booking Volume and Fare Performance

The monthly analysis identified significant fluctuations in booking volume and total fare amounts throughout 2023.

In March 2023, booking volume decreased by 47.62%, while total fare amounts decreased by 70.01% compared to February.

| Metric | February | March | Change |
|---|---:|---:|---:|
| Total bookings | 21 | 11 | -47.62% |
| Total fare paid | $453.44 | $135.98 | -70.01% |

Another interesting observation is that booking volume remained unchanged between March and April, while total fare amounts increased by approximately 91.02%.

| Metric | March | April | Change |
|---|---:|---:|---:|
| Total bookings | 11 | 11 | 0% |
| Total fare paid | $135.98 | $259.75 | +91.02% |

These findings demonstrate that increases in total fare amounts are not necessarily driven by increases in booking volume. Changes in ticket prices or the mix of bookings may also contribute significantly.

Management should investigate passenger demand, seasonal travel patterns, flight availability, and pricing strategies to understand these fluctuations.

**Supporting query:** `queries/unit6/q6_3.sql` — Task 6.3 Part B.

## 4. What Should the Team Do Next Quarter?

### 4.1 Prioritize Reducing Booking Cancellations

Cancellations account for 34 of the 44 booking failures, representing approximately 77.27% of all failures.

Management should prioritize investigating cancellation reasons and evaluate whether improvements in booking policies, passenger communication, flight scheduling, or customer support could reduce cancellation rates.

### 4.2 Investigate High-Failure Flights

Management should identify flights with failure rates above the platform baseline of 22%.

Flights with both high booking volumes and high failure rates should receive greater attention because they may contribute disproportionately to the overall platform failure rate.

However, flights with very few bookings should be evaluated carefully because a small number of failures can produce misleadingly high failure rates.

### 4.3 Improve Dispute Resolution

Disputed bookings account for 5% of all bookings. Management should investigate the underlying reasons for disputes and evaluate potential improvements in payment processing, pricing transparency, refund policies, and customer support.

Reducing disputes could improve customer satisfaction and contribute to a lower overall failure rate.

### 4.4 Investigate Booking and Fare Fluctuations

The significant decline in booking volume and total fare amounts in March suggests that management should investigate changes in passenger demand, seasonal travel patterns, ticket prices, and flight availability.

Management should also evaluate whether targeted promotional campaigns or pricing adjustments could improve booking performance during periods of low demand.

### 4.5 Implement Monthly Performance Monitoring

Management should establish a performance dashboard that monitors the following metrics:

- Total booking volume
- Total fare paid
- Average booking fare
- Cancellation rate
- Dispute rate
- Overall booking failure rate
- Month-over-month percentage changes
- Flight-level failure rates

The window functions developed in Unit 6 can support this dashboard by providing period-over-period comparisons, rankings, running totals, and moving averages.

### 4.6 Establish a Measurable Improvement Target

I recommend establishing an initial target of reducing the overall booking failure rate from the historical baseline of 22% to 18% in the next quarter.

This represents a reduction of four percentage points, or approximately 18.18% relative to the historical baseline.

Management should monitor progress toward this proposed target through monthly performance reports and evaluate whether operational improvements are producing measurable results.

## 5. Limitations and Future Improvements

The dataset contains only 200 bookings, which limits the ability to draw strong conclusions about long-term trends and seasonal patterns.

Additionally, the dataset does not provide detailed information about the underlying reasons for booking cancellations or disputes. Therefore, the analysis can identify patterns and potential areas of concern but cannot establish the root causes of booking failures.

Total fare paid also does not necessarily represent realized revenue because cancelled or disputed bookings may involve refunds.

Future analysis would benefit from additional information, including:

- Cancellation and dispute reasons
- Historical booking data covering multiple years
- Passenger booking behavior
- Flight schedules and seat availability
- Ticket classes and promotional discounts
- Payment and refund information
- Data ingestion and processing logs

These additional data sources would help management identify the underlying causes of booking failures and develop more targeted improvement strategies.

## 6. Supporting SQL Queries

| Query | Purpose |
|---|---|
| `queries/unit6/q6_1.sql` | Compare individual booking fares with flight averages, rank flights by booking volume, and categorize flights into performance bands. |
| `queries/unit6/q6_2.sql` | Analyze consecutive booking fares, cumulative fare amounts, moving averages, and gaps in booking activity. |
| `queries/unit6/q6_3.sql` | Identify the highest-paying bookings for each flight and analyze monthly booking performance and failure rates. |
| Booking status validation query | Validate booking statuses and establish the overall failure rate of 22%. |

## Conclusion

The analysis demonstrates how SQL aggregations and window functions can transform individual airline booking records into meaningful business insights.

The overall booking failure rate of 22% highlights an opportunity to improve booking reliability, particularly by addressing cancellations, which represent the largest contributor to booking failures.

The analysis also identified significant fluctuations in booking volume and total fare amounts, suggesting that management should investigate passenger demand and pricing patterns.

For the next quarter, the team should prioritize reducing cancellations, investigating high-failure flights, improving dispute resolution, and implementing monthly performance monitoring.

By establishing measurable performance targets and continuously evaluating booking trends, the airline can make more informed decisions and improve the overall reliability of its booking platform.