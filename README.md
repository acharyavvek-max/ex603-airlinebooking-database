# Airline Booking System

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
