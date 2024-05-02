USE Test_New;
-- Test trigger 1: Insert Route After insert an Airport
INSERT INTO airport(APCode, APName, City, Latitude, Longitude) VALUES ('AAA', 'American Airport Association', 'USA', 16.3457, 45.1234);
SELECT * FROM route;

-- Test trigger 2: Check before delete An Employee
SELECT * FROM test_new.operates;
DELETE FROM Employee WHERE SSN='2049569671';		-- Avoid delete flight attendant to ensure total constraint of `operates`
DELETE FROM Employee WHERE SSN='2552794347';		-- Avoid delete pilot to ensure total constraint of `operates`
SELECT * FROM test_new.tcshift;
DELETE FROM Employee WHERE SSN='3058929914';		-- Avoid delete ATC member who only controls one flight
SELECT * FROM test_new.expertise;
DELETE FROM Employee WHERE SSN='8660516635';		-- Avoid delete the engineer who is the sole expert of a model (Each model must have at least an engineer participated in)

-- Test trigger 3: Calculate the Base Price for the Flight based on the distance of the Route
INSERT INTO flight(RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT) VALUES (7,'Landed',14,9656325312,'QC0112','2024-05-02 23:00:00','2024-05-03 08:00:00','2024-05-02 23:10:10','2024-05-03 07:15:52');
SELECT f.FlightID, BasePrice, Distance FROM flight f JOIN route r on f.RID = r.ID WHERE FlightID = 51;

-- Test trigger 4: Check if the new employee's salary is greater than or equal to the supervisor's salary
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (0123456789,'Kirsten','A.','Babel',99852,1726864584,'F','1999-08-11','2018-11-24');
SELECT SSN, salary FROM Employee WHERE SSN = 1071916066;
INSERT INTO supervision(SSN, SuperSSN) VALUES (0123456789, 1071916066);

-- Test trigger 5: Update Status of the Seat after Update the Check-in Status of the Ticket
INSERT INTO seat(FlightID, SeatNum, Class, Status, Price) VALUES (1, '09A', 'Economy', 'Available', 100);
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (1001, 0778, 1, '2024-02-13 13:31:17', '09A', '1970-01-01', '1970-01-01', 'No');
SELECT * FROM Seat WHERE FlightID = 1 AND SeatNum = '09A';
UPDATE ticket SET CheckinStatus = 'Yes' WHERE TicketID = 1001;
SELECT * FROM Seat WHERE FlightID = 1 AND SeatNum = '09A';

-- Test trigger 6: Check before delete an Airline
DELETE FROM Airline WHERE AirlineID = 997;			-- Cannot delete an Airline if the deletion leads to an owner who do not own any airplane

-- Test trigger 7: Check before update an Airplane of an Owner
UPDATE airplane SET ownerID = 2 WHERE AirplaneID = 7;		-- Cannot update the owner of an airplane if that leads to some owner who do not own any airplane

-- Test trigger 8: Check before update an Airplane
UPDATE airplane SET airlineID = 988 WHERE AirplaneID = 7;		-- Cannot update airlineID of an airplane if that leads to some airlines not having any airplane

-- Test trigger 9: Check before delete an Airplane of an Owner
DELETE FROM airplane WHERE airplaneID = 7;

-- Test trigger 10: Check before delete an Airplane of the Airline
DELETE FROM airplane WHERE airplaneID = 11;

-- Test trigger 11: Trigger Create the PID_Decode, with the format of prefix + Auto Increment
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (1001, 163504525057, 'F','2004-04-18','Vietnam','Meow','A.','Wok', 6);
SELECT * FROM passenger WHERE PID=1001;

-- Test trigger 12: Update the Status after insert the Ticket that has been Checked in
INSERT INTO Seat(FlightID, SeatNum, Class, Status, Price) VALUES (1, '09B', 'First Class', 'Available', 400);
SELECT * FROM Seat WHERE FlightID = 1 AND SeatNum = '09B';
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (1002, 1001, 1, '2024-02-13 13:31:17', '09B', '1970-01-01', '2024-04-17 13:44:38', 'Yes');
SELECT * FROM Seat WHERE FlightID = 1 AND SeatNum = '09B';

-- Test trigger 13: generate all seats after inserting a flight into database
SELECT * FROM seat WHERE FlightID = 51;

-- Test constraint "check-salary": salary must be > 0
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (0123456788,'Cat','M.','Mr',-99852,1726864584,'M','1999-08-11','2018-11-24');

-- Test constraint "check-valid-date": Check legitimate value of EAT/EDT/AAT/ADT when isnerting a flight
INSERT INTO flight(RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT) 
VALUES (7,'Landed',14,9656325312,'QC0113','2024-05-03 23:00:00','2024-05-03 08:00:00','2024-05-02 23:10:10','2024-05-03 07:15:52');		-- fail
INSERT INTO flight(RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT) 
VALUES (7,'Landed',14,9656325312,'QC0114','2024-05-02 23:00:00','2024-05-03 08:00:00','2024-05-03 23:10:10','2024-05-03 07:15:52');		-- fail
INSERT INTO flight(RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT) 
VALUES (7,'Landed',14,9656325312,'QC0115','2024-05-02 23:00:00','2024-05-03 08:00:00','2024-05-03 23:10:10','1970-01-01 00:00:00');		-- work
INSERT INTO flight(RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT) 
VALUES (7,'Landed',14,9656325312,'QC0116','2024-05-02 23:00:00','2024-05-03 08:00:00','1970-01-01 00:00:00','1970-01-01 00:00:00');		-- work

-- Test trigger 14: check insert ticket when seat is unavailable
INSERT INTO ticket(PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus)		-- overlap unavailable seat
VALUES (999, 1, '2024-02-13 13:31:17', '03D', '1970-01-01', '2024-04-17 13:44:38', 'Yes');
INSERT INTO ticket(PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus)		-- overlap PID
VALUES (999, 1, '2024-02-13 13:32:17', '03E', '2024-04-17 13:44:38', '1970-01-01 00:00:00', 'No');
INSERT INTO ticket(PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus)		-- available seat -> should work
VALUES (1000, 1, '2024-02-13 13:33:17', '03E', '1970-01-01', '2024-04-17 13:44:38', 'Yes');


-- Test trigger 15: Check consecutive shifts for ATC crew
INSERT INTO tcshift(TCSSN, Shift) VALUES (1443933295, 'Afternoon');			-- Will not work because this member already works in the morning
INSERT INTO tcshift(TCSSN, Shift) VALUES (1443933295, 'Night');				-- Will not work because this member already works in the morning
INSERT INTO tcshift(TCSSN, Shift) VALUES (1443933295, 'Evening');			-- Will work

-- Test trigger 17: ensureEmployeeAge
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1723073016,'Neo','X.','Martin',26182,6767209659,'F','2008-01-18','2017-01-18');

-- Test function getAge (of passenger):
SELECT getAge(1000);

SELECT CalculateTotalSpent(1000);

SELECT getNoFlightAttendants(1);

sELECT getNoPilots(1);

SELECT getNoFEmployees(1);

SELECT revenue_flights(1);

SELECT count_available_seats(1);

SELECT getNoPassenger(1);

SELECT getDuration(1);

-- Test trigger 16: check-flight-constraints: Check legitimate value of EAT/EDT/AAT/ADT when UPDATING a flight
-- PHẢI LÀM TEST TRIGGER 3 TRƯỚC VÌ flightID là auto-increment
UPDATE flight SET EDT = '2024-05-04 09:00:00' WHERE FlightID = 1;		-- will fail
UPDATE flight SET EAT = '2024-04-04 08:00:00' WHERE FlightID = 1;		-- will fail
UPDATE flight SET ADT = '2024-05-18 23:30:00' WHERE FlightID = 2;		-- will fail
UPDATE flight SET AAT = '2024-04-01 22:30:00' WHERE FlightID = 2;		-- will fail
UPDATE flight SET AAT = '2024-05-01 09:00:00' WHERE FlightID = 2;		-- will work