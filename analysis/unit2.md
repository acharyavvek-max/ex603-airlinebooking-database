# Task 2.2: Reasoning

## Constraints Table

  --------------------------------------------------------------------------------------------------------------
  Foreign Key                                                    ON DELETE               Reason
  -------------------------------------------------------------- ----------------------- -----------------------
  `flight_routes.origin_airport_id → airports.airport_id`        `RESTRICT`              An airport cannot be
                                                                                         deleted if it is being
                                                                                         used as the origin of a
                                                                                         flight route.

  `flight_routes.destination_airport_id → airports.airport_id`   `RESTRICT`              An airport cannot be
                                                                                         deleted if it is being
                                                                                         used as the destination
                                                                                         of a flight route.

  `flights.flight_route_id → flight_routes.flight_route_id`      `RESTRICT`              A flight route cannot
                                                                                         be deleted if a flight
                                                                                         is currently using it.

  `bookings.passenger_id → passengers.passenger_id`              `RESTRICT`              A passenger cannot be
                                                                                         deleted if they have an
                                                                                         existing booking.

  `bookings.flight_number → flights.flight_number`               `RESTRICT`              A flight cannot be
                                                                                         deleted if passengers
                                                                                         have bookings for it.
  --------------------------------------------------------------------------------------------------------------

## ON DELETE Choices

For the origin and destination airport foreign keys, I used
`ON DELETE RESTRICT`. If an airport is already being used in a flight
route, it should not be deleted. For example, if DFW is used as the
origin airport for a route, deleting DFW would leave that route without
a valid origin. `RESTRICT` prevents this from happening.

I also used `ON DELETE RESTRICT` between flights and flight routes. If
flights are using a route, that route should stay in the database. The
flights should be handled first before the route can be removed.
Otherwise, the flights would no longer have a valid route.

For passengers and bookings, I used `ON DELETE RESTRICT` because I do
not want a passenger to be deleted while they still have bookings. If
the passenger were deleted, the booking would lose the information about
who made it. Using `CASCADE` would also not be a good choice because
deleting a passenger could automatically delete all of their bookings.

I used the same approach for flights and bookings. A flight should not
be deleted if passengers already have bookings for it. The bookings need
to be handled first. If `CASCADE` were used instead, deleting a flight
could also delete all of its bookings.

## CHECK Constraints

### Email Format

The email check makes sure that the passenger's email looks like a valid
email address. For example, a value such as `johngmail.com` should not
be accepted because it is missing the `@` symbol. Without this check,
incorrect email addresses could be entered into the database.

### Origin and Destination Airports

``` sql
CHECK (origin_airport_id <> destination_airport_id)
```

This check makes sure the origin and destination airports are not the
same. Without it, someone could accidentally create a flight route where
the flight starts and ends at the same airport.

### Arrival and Departure Time

``` sql
CHECK (arrival_datetime > departure_datetime)
```

This check makes sure the arrival time is later than the departure time.
Without it, someone could enter an arrival time that is earlier than or
the same as the departure time.

### Seating Capacity

``` sql
CHECK (seating_capacity > 0)
```

This makes sure a flight has at least one seat. Without this check, a
seating capacity of `0` or a negative number could be entered by
mistake.

### Available Seats

``` sql
CHECK (number_of_available_seats >= 0)
```

This prevents the number of available seats from going below zero. A
negative number could happen because of incorrect data entry or an error
when updating the available seats.

### Available Seats and Seating Capacity

``` sql
CHECK (number_of_available_seats <= seating_capacity)
```

This makes sure the available seats are not greater than the total
seating capacity. For example, if a flight has 200 seats, it should not
be possible to enter 250 available seats.

### Fare Paid

``` sql
CHECK (fare_paid >= 0)
```

This prevents a negative fare from being entered for a booking. A
negative fare would not make sense and could happen because of incorrect
data entry or an application error.
