# Airline Booking System
## Unit 4: Aggregation and Reporting — Query Catalogue

| Task | Query | Business Question |
|---|---|---|
| 4.1.1 | Overall Booking Statistics | What are the total bookings, total revenue, average fare, minimum and maximum fares, and number of unique passengers? |
| 4.1.2 | Per-Flight Aggregation | Which flights have the highest booking volumes, and how do their average fares compare? |
| 4.1.3 | High-Volume Flights | Which flights have booking volumes at or above the average bookings per flight? |
| 4.1.4 | Regional Booking Breakdown | How do booking volumes and statuses vary across countries? |
| 4.2 Part A | Conditional Aggregation | How many bookings and passenger no-shows does each flight have? |
| 4.2 Part B | Regional Subtotals and Grand Total | How much booking revenue does each country generate, and what is the total platform revenue? |
| 4.2 Part C | Two-Step CTE Pipeline | Which flights meet the booking-volume threshold, and how do their no-show rates compare with the overall baseline? |

## Schema

The Airline Booking System database contains five main tables:

-   **airports** -- Stores airport information such as airport name,
    airport code, city, and country.
-   **passengers** -- Stores passenger information including first name,
    last name, and email address.
-   **flight_routes** -- Defines routes between an origin airport and a
    destination airport.
-   **flights** -- Stores individual flights, including the route,
    departure and arrival times, seating capacity, and available seats.
-   **bookings** -- Connects passengers to flights and stores booking
    information such as booking date and fare paid.

### Design Decisions

The tables are connected using foreign keys to maintain relationships
between the data. A flight route must reference valid origin and
destination airports, a flight must reference an existing flight route,
and a booking must reference both an existing passenger and an existing
flight.

`ON DELETE RESTRICT` is used on the foreign keys so that records that
are still being used cannot be deleted. For example, an airport cannot
be deleted if a flight route references it, and a passenger or flight
cannot be deleted if there are existing bookings.

The schema also uses `CHECK` constraints to prevent invalid data. The
origin and destination airports cannot be the same, the arrival time
must be later than the departure time, seating capacity must be greater
than zero, available seats cannot be negative or greater than the
seating capacity, and the fare paid cannot be negative.

Unique constraints are used for values that should not be duplicated.
Airport codes are unique because each airport should have its own code,
and passenger email addresses are unique to prevent duplicate passenger
accounts.
