DROP TABLE tickets;
DROP TABLE screenings;
DROP TABLE customers;
DROP TABLE films CASCADE;

CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT
);

CREATE TABLE films (
  id SERIAL8 PRIMARY KEY,
  title VARCHAR(255),
  price INT
);

CREATE TABLE screenings (
  id SERIAL8 PRIMARY KEY,
  time TIME,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
  tickets_available INT
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  customer_id INT8 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE,
  screening_id INT8 REFERENCES screenings(id) ON DELETE CASCADE
);
