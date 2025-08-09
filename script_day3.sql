CREATE TABLE FILM (
    film_id varchar(10) NOT NULL PRIMARY KEY,
    name varchar(100),
    length_min int,
    genre varchar(50),
    country varchar(20)
);

CREATE TABLE ROOM (
    id varchar(10) NOT NULL PRIMARY KEY,
    name varchar(50)
);

CREATE TABLE SCREENING (
    screening_id varchar(10) NOT NULL PRIMARY KEY,
    film_id varchar(10),
    room_id varchar(10),
    start_time DATETIME,
    FOREIGN KEY (film_id) REFERENCES FILM(film_id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id)
);

CREATE TABLE CUSTOMER (
    customer_id varchar(10) NOT NULL PRIMARY KEY,
    name varchar(100),
    phone varchar(15)
);

CREATE TABLE BOOKING (
    booking_id varchar(10) NOT NULL PRIMARY KEY,
    customer_id varchar(10),
    screening_id varchar(10),
    booking_time DATETIME,
    total DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (screening_id) REFERENCES SCREENING(screening_id)
);


CREATE TABLE SEAT (
    seat_id varchar(10) NOT NULL PRIMARY KEY,
    room_id varchar(10),
    `row` CHAR(1),
    number int,
    x int,
    y int,
    FOREIGN KEY (room_id) REFERENCES ROOM(id)
);

INSERT INTO SEAT (seat_id, room_id, `row`, number, x, y)
VALUES 
('S001', 'T001', 'A', 1, 1, 1),
('S002', 'T001', 'A', 5, 1, 3),
('S003', 'T002', 'G', 4, 1, 1),
('S004', 'T003', 'F', 6, 2, 1);

CREATE TABLE RESERVED_SEAT (
    rs_id varchar(10) NOT NULL PRIMARY KEY,
    booking_id varchar(10),
    seat_id varchar(10),
    price DECIMAL(8,2),
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id),
    FOREIGN KEY (seat_id) REFERENCES SEAT(seat_id)
);

INSERT INTO RESERVED_SEAT (rs_id, booking_id, seat_id)
VALUES 
('RS001', 'B001', 'S001'),
('RS002', 'B002', 'S002'),
('RS003', 'B003', 'S004'),
('RS004', 'B003', 'S003');

INSERT INTO FILM (film_id, name, length_min, genre, country)
VALUES 
('FM001', 'Movie A', 120, 'Comedy', 'VN'),
('FM002', 'Movie B', 125, 'Horror', 'AU'),
('FM003', 'Movie C', 162, 'Horror', 'JP');

INSERT INTO ROOM (id, name)
VALUES 
('T001', 'Theater A'),
('T002', 'Theater B'),
('T003', 'Theater C');

INSERT INTO SCREENING (screening_id, film_id, room_id, start_time)
VALUES 
('SC001', 'FM003', 'T002', '2025-10-10 10:00:00'),
('SC002', 'FM002', 'T001', '2025-10-11 08:00:00'),
('SC003', 'FM002', 'T001', '2025-10-12 09:00:00'),
('SC004', 'FM001', 'T003', '2025-10-13 18:00:00');

INSERT INTO CUSTOMER (customer_id, name)
VALUES 
('C001', 'Leslie'),
('C002', 'Noah'),
('C003', 'Ivy'),
('C004', 'Jayden'),
('C005', 'Jonathan');

INSERT INTO BOOKING (booking_id, customer_id, screening_id)
VALUES 
('B001', 'C001', 'SC002'),
('B002', 'C001', 'SC003'),
('B003', 'C003', 'SC004'),
('B004', 'C004', 'SC004');