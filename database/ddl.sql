-- Note:
-- In this version, I have set "ON DELETE CASCADE" to all the referential integrity constraints
DROP SCHEMA IF EXISTS AMS;
CREATE SCHEMA AMS;

USE AMS;

SET SQL_SAFE_UPDATES = 0; -- note this for allow to not use the safe mode on update
-- --------------------------------------------------------------------
CREATE TABLE AMS.Employee
(
    SSN    CHAR(10),
    Fname  VARCHAR(50),
    Minit  CHAR(2),
    Lname  VARCHAR(50),
    Salary FLOAT,
    Phone  CHAR(10),
    DOB    DATE,
    Sex    ENUM ('F', 'M'),
    PRIMARY KEY (SSN)
);

CREATE TABLE AMS.Supervision
(
    SSN      CHAR(10),
    SuperSSN CHAR(10),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SuperSSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Employee_Address
(
    SSN      CHAR(10),
    Street   VARCHAR(50),
    City     VARCHAR(50),
    District VARCHAR(50),
    PRIMARY KEY (SSN, Street, City, District),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Administrative_Support
(
    SSN    CHAR(10),
    ASType ENUM ('Secretary', 'Data Entry', 'Receptionist', 'Communications', 'PR', 'Security', 'Ground Service', 'HR', 'Emergency Service'),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Engineer
(
    SSN   CHAR(10),
    EType ENUM ('Avionic Engineer', 'Mechanical Engineer', 'Electric Engineer'),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Traffic_Controller
(
    SSN CHAR(10),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.TCShift
(
    TCSSN CHAR(10),
    Shift ENUM ('Morning', 'Afternoon', 'Evening', 'Night'),
    PRIMARY KEY (TCSSN, Shift),
    FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Flight_Employee
(
    FESSN CHAR(10),
    PRIMARY KEY (FESSN),
    FOREIGN KEY (FESSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Pilot
(
    SSN     CHAR(10),
    License CHAR(12),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Flight_Attendant
(
    SSN             CHAR(10),
    Year_experience FLOAT,
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Route
(
    ID INT AUTO_INCREMENT,
    RName CHAR(7),
    Distance NUMERIC,
    PRIMARY KEY (ID)
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Passenger
(
    PID         INT(4) ZEROFILL AUTO_INCREMENT,
    PID_Decode 	VARCHAR(25),
    PassportNo  CHAR(12) NOT NULL UNIQUE,
    Sex         ENUM ('M', 'F'),
    DOB         DATE,
    Nationality VARCHAR(50),
    Fname       VARCHAR(50),
    Minit       CHAR(2),
    Lname       VARCHAR(50),
    PRIMARY KEY (PID)
);

CREATE TABLE AMS.Passenger_Phone
(
    PID   INT(4) ZEROFILL,
    Phone CHAR(10),
    PRIMARY KEY (PID, Phone),
    FOREIGN KEY (PID) REFERENCES Passenger (PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Owner
(
    OwnerID INT AUTO_INCREMENT,
    Phone   CHAR(10),
    PRIMARY KEY (OwnerID)
);

CREATE TABLE AMS.Cooperation
(
    Name    VARCHAR(50),
    Address VARCHAR(50),
    OwnerID INT,
    PRIMARY KEY (Name),
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.Person
(
    SSN     CHAR(10),
    Name    VARCHAR(50),
    Address VARCHAR(50),
    OwnerID INT,
    PRIMARY KEY (SSN),
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Airport
(
    APCode              CHAR(3),
    APName              VARCHAR(50),
    City                VARCHAR(50),
    Latitude          FLOAT,
    Longitude         FLOAT,
    PRIMARY KEY (APCode)
);

CREATE TABLE AMS.Airline
(
    AirlineID      CHAR(3),
    IATADesignator CHAR(2) UNIQUE NOT NULL,
    Name           VARCHAR(50),
    Country        VARCHAR(50),
    PRIMARY KEY (AirlineID)
);

CREATE TABLE AMS.Model
(
    ID        INT AUTO_INCREMENT,
    MName     VARCHAR(20),
    Capacity  INT,
    MaxSpeed  FLOAT,
    PRIMARY KEY (ID)
);

CREATE TABLE AMS.Airplane
(
    AirplaneID        INT AUTO_INCREMENT,
    License_plate_num VARCHAR(7) UNIQUE NOT NULL,
    AirlineID         CHAR(3)        NOT NULL,
    OwnerID           INT            NOT NULL,
    ModelID           INT,
    LeasedDate        DATETIME DEFAULT '1970-01-01 00:00:00' NOT NULL,
    PRIMARY KEY (AirplaneID),
    FOREIGN KEY (AirlineID) REFERENCES Airline (AirlineID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Consultant
(
    ID INT AUTO_INCREMENT,
    Name    VARCHAR(50),
    PRIMARY KEY (ID)
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.is_Destination
(
    RID INT,
    APCode  CHAR(3),
    PRIMARY KEY (RID, APCode),
    FOREIGN KEY (RID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AMS.is_Source
(
    RID INT,
    APCode  CHAR(3),
    PRIMARY KEY (RID, APCode),
    FOREIGN KEY (RID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE AMS.Flight
(
    FlightID        INT AUTO_INCREMENT,
    RID             INT,
    Status          ENUM ('On Air', 'Landed', 'Unassigned'),
    AirplaneID      INT       NOT NULL,
    TCSSN           CHAR(10)  NOT NULL, -- SSN of Traffic Controller
    FlightCode      VARCHAR(6)   NOT NULL,
    AAT             DATETIME DEFAULT '1970-01-01 00:00:00',
    EAT             DATETIME DEFAULT '1970-01-01 00:00:00',
    ADT             DATETIME DEFAULT '1970-01-01 00:00:00',
    EDT             DATETIME DEFAULT '1970-01-01 00:00:00',
    BasePrice       FLOAT,      -- ADD CONSTRAINT: between $0.05/km (0.05) to $0.2/km (0.2)
    PRIMARY KEY (FlightID),
    UNIQUE (RID, FlightCode),
    FOREIGN KEY (RID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AirplaneID) REFERENCES Airplane (AirplaneID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------ IMPORTANT --------------------------------------------------
-- Assumption: Passenger can still cancel his flight before his check-in time.
-- Case 1: Passenger SUCCESSFULLY booked his flight. CheckinTime = DEFAULT, CheckinStatus = 'No', Seat.Status = 'Unavailable'.
-- Case 2: Passenger cancels the flight. CheckinTime = DEFAULT, CheckinStatus = 'No', Seat.Status = 'Available'.
-- Case 3: Passenger did not check-in or late check-in. CheckinTime = DEFAULT, CheckinStatus = 'No',
--                                                      [Seat.Status = 'Available' AT THE TIME OF (Flight.EDT - 15MINUTES)]
-- Case 4: Passenger check-in on-time at the airport and certainly fly: CheckInStatus = 'Yes', Seat.Status = 'Unavailable'.
-- Every passenger must check-in their flight [at least 15 minutes and at most 24 hours] in advance of Flight.EDT.

CREATE TABLE AMS.Seat
(
    FlightID INT,
    SeatNum  VARCHAR(3),           -- Trigger SeatNum < ROUND(0.9*Model.Capacity), format: <row><[A-E]> e.g. 1A, 11E
    Class    ENUM ('Business', 'Economy', 'First Class'),
    Status   ENUM ('Unavailable', 'Available') DEFAULT 'Available',
    PRIMARY KEY (FlightID, SeatNum),
    FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE AMS.Seat
ADD INDEX idx_SeatNum (SeatNum),
ADD INDEX idx_FlightID (FlightID);

CREATE TABLE AMS.Ticket
(
    TicketID      INT AUTO_INCREMENT,
    PID           INT(4) ZEROFILL,
    Price         NUMERIC,
    CheckInTime   DATETIME DEFAULT '1970-01-01 00:00:00',
    CheckInStatus ENUM ('No', 'Yes') DEFAULT 'No',
    BookTime      DATETIME DEFAULT '1970-01-01 00:00:00' NOT NULL,
    SeatNum       VARCHAR(3),
    FlightID      INT,
    PRIMARY KEY (TicketID),
    FOREIGN KEY (PID) REFERENCES Passenger (PID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (SeatNum, FlightID) REFERENCES Seat (SeatNum, FlightID) ON DELETE CASCADE ON UPDATE CASCADE
    -- FOREIGN KEY (SeatNum) REFERENCES Seat (SeatNum) ON DELETE CASCADE ON UPDATE CASCADE,
	-- FOREIGN KEY (FlightID) REFERENCES Seat (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------

CREATE TABLE AMS.Expert_At
(
    ConsultID INT,
    APCode    CHAR(3),
    ModelID   INT,
    PRIMARY KEY (ConsultID, APCode, ModelID),
    FOREIGN KEY (ConsultID) REFERENCES Consultant (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------
CREATE TABLE AMS.Experience
(
    PilotSSN      CHAR(10),
    ModelID       INT,
    HoursOfFlying FLOAT,
    PRIMARY KEY (PilotSSN, ModelID),
    FOREIGN KEY (PilotSSN) REFERENCES Pilot (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
DROP TABLE AMS.Experience;

-- --------------------------------------------------------------------

CREATE TABLE AMS.Expertise
(
    ESSN    CHAR(10),
    ModelID INT,
    PRIMARY KEY (ESSN, ModelID),
    FOREIGN KEY (ESSN) REFERENCES Engineer (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------

CREATE TABLE AMS.Airport_Contains_Airplane
(
    APCode     CHAR(3),
    AirplaneID INT,
    PRIMARY KEY (APCode, AirplaneID),
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AirplaneID) REFERENCES Airplane (AirplaneID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------

CREATE TABLE AMS.Airport_Includes_Employee
(
    APCode CHAR(3),
    SSN    CHAR(10),
    Date   DATETIME DEFAULT '1970-01-01 00:00:00' NOT NULL,
    PRIMARY KEY (APCode, SSN),
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------

CREATE TABLE AMS.Operates
(
    FSSN     CHAR(10),
    FlightID INT,
    Role     VARCHAR(15),
    PRIMARY KEY (FSSN, FlightID),
    FOREIGN KEY (FSSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------
-- Start function
-- --------------------------------------------------------------------
delimiter //
CREATE FUNCTION AMS.getDuration (fid INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE aAT TIMESTAMP; 
    DECLARE aDT TIMESTAMP;
    
	SELECT AAT, ADT
    INTO aAT, aDT
    FROM AMS.flight AS f
    WHERE f.FlightID = fid;
    
    IF ISNULL(aAT) OR ISNULL(aDT) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Unknown actual arrival time or actual departure time";
	END IF;
    
    RETURN CONCAT(FLOOR(HOUR(TIMEDIFF(aDT, aAT)) / 24), ' days ',
				  MOD(HOUR(TIMEDIFF(aDT, aAT)), 24), ' hours ',
				  MINUTE(TIMEDIFF(aDT, aAT)), ' minutes');
END
//

-- ----------------------------------------------------------------------------------------------------------- 
delimiter //
CREATE FUNCTION AMS.getNoFEmployees (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE countFE INT;
    
	SELECT COUNT(*) INTO countFE
    FROM AMS.Operates AS o
    WHERE o.FSSN = fid;
    
    RETURN countFE;
END
//

-- ----------------------------------------------------------------------------------------------------------- 
delimiter //
CREATE FUNCTION AMS.getNoPassenger (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE countP INT;
    
	SELECT COUNT(*) INTO countP
    FROM AMS.Seat AS s
    WHERE s.FlightID = fid AND s.status = 'Unavailable';
    
    RETURN countP;
END
//

-- ----------------------------------------------------------------------------------------------------------- 

delimiter //
CREATE FUNCTION AMS.getAge (pid INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE age INT;
    
	SELECT TIMESTAMPDIFF(YEAR, NOW(), dob) INTO age
    FROM AMS.passenger AS p
    WHERE p.pid = pid;
    
    RETURN age;
END
//

-- ----------------------------------------------------------------------------------------------------------- 

delimiter //
CREATE PROCEDURE AMS.getPassengerOnFlight(fid INT)
BEGIN
	SELECT p.pid, CONCAT(p.fname, ' ', p.minit, ' ', p.lname) AS name, p.Nationality, p.PassportNo, p.DOB, p.Sex
    FROM AMS.passenger AS p
    JOIN AMS.ticket AS t ON t.PID = p.PID
    JOIN AMS.seat AS s ON s.ticketid = t.ticketid
    WHERE s.FlightID = fid AND s.status = 'Unavailable';
END
//

-- ----------------------------------------------------------------------------------------------------------- 

delimiter //
CREATE PROCEDURE AMS.getEmployeeOnFlight(fid INT)
BEGIN
	SELECT e.ssn, CONCAT(e.fname, ' ', e.minit, ' ', e.lname) AS name, p.phone, p.dob, p.sex, o.role
    FROM AMS.employee AS e
    JOIN AMS.operates AS o ON o.fssn = e.ssn
    WHERE o.FlightID = fid;
END
//

-- ----------------------------------------------------------------------------------------------------------- 
-- Trigger
-- ----------------------------------------------------------------------------------------------------------- 
-- Trigger of EXPERT_AT: total side CONSULTANT (ID)
-- This check before delete the last record in EXPERT_AT of a Consultant
delimiter //
CREATE TRIGGER AMS.Expert_At_BD BEFORE DELETE
ON AMS.Expert_At
FOR EACH ROW
BEGIN
	DECLARE numRecordConsult INT;
    
    SELECT COUNT(*) INTO numRecordConsult
    FROM AMS.Expert_At
    WHERE ConsultID = OLD.ConsultID;
    
    IF numRecordConsult = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from EXPERT_AT; Num Records Remaining of this Consultant is 1';
	END IF;
END //
delimiter ;

-- This check before delete the update record in EXPERT_AT of a Consultant
delimiter //
CREATE TRIGGER AMS.Expert_At_BU BEFORE UPDATE
ON AMS.Expert_At
FOR EACH ROW
BEGIN
	DECLARE numRecordConsult INT;
    
    SELECT COUNT(*) INTO numRecordConsult
    FROM AMS.Expert_At
    WHERE ConsultID = OLD.ConsultID;
    
    IF NEW.ConsultID <> OLD.ConsultID AND numRecordConsult = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from EXPERT_AT; Num Records Remaining of this Consultant is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the last record in Airport_Includes_Employee of an Airport
delimiter //
CREATE TRIGGER AMS.Airport_Includes_Employee_BD BEFORE DELETE
ON AMS.Airport_Includes_Employee
FOR EACH ROW
BEGIN
	DECLARE numRecordAirport INT;
    
    SELECT COUNT(*) INTO numRecordAirport
    FROM AMS.Airport_Includes_Employee
    WHERE APCode = OLD.APCode;
    
    IF numRecordAirport = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Airport_Includes_Employee; Num Records Remaining of this APCode is 1';
	END IF;
END //
delimiter ;

-- This check before update the last record in Airport_Includes_Employee of an Airport
delimiter //
CREATE TRIGGER AMS.Airport_Includes_Employee_BU BEFORE UPDATE
ON AMS.Airport_Includes_Employee
FOR EACH ROW
BEGIN
	DECLARE numRecordAirport INT;
    
    SELECT COUNT(*) INTO numRecordAirport
    FROM AMS.Airport_Includes_Employee
    WHERE APCode = OLD.APCode;
    
    IF NEW.APCode <> OLD.APCode AND numRecordAirport = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from Airport_Includes_Employee; Num Records Remaining of this APCode is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the last record in Airport_Contains_Airplane of an Airplane
delimiter //
CREATE TRIGGER AMS.Airport_Contains_Airplane_BD BEFORE DELETE
ON AMS.Airport_Contains_Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordAirplane INT;
    
    SELECT COUNT(*) INTO numRecordAirplane
    FROM AMS.Airport_Contains_Airplane
    WHERE AirplaneID = OLD.AirplaneID;
    
    IF numRecordAirplane = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Airport_Contains_Airplane; Num Records Remaining of this Airplane is 1';
	END IF;
END //
delimiter ;

-- This check before update the last record in Airport_Contains_Airplane of an Airplane
delimiter //
CREATE TRIGGER AMS.Airport_Contains_Airplane_BU BEFORE UPDATE
ON AMS.Airport_Contains_Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordAirplane INT;
    
    SELECT COUNT(*) INTO numRecordAirplane
    FROM AMS.Airport_Contains_Airplane
    WHERE AirplaneID = OLD.AirplaneID;
    
    IF NEW.AirplaneID <> OLD.AirplaneID AND numRecordAirplane = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from Airport_Contains_Airplane; Num Records Remaining of this Airplane is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Note: insert Owner before insert his/her airplanes
-- This check before delete the last airplane in Airplane of an Owner
delimiter //
CREATE TRIGGER AMS.Airplane_Owner_BD BEFORE DELETE
ON AMS.Airplane
FOR EACH ROW
BEGIN
	DECLARE numAirplaneOfOwner INT;
    
    SELECT COUNT(*) INTO numAirplaneOfOwner
    FROM AMS.Airplane
    WHERE OwnerID = OLD.OwnerID;
    
    IF numAirplaneOfOwner = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Airplane; Num Records Remaining of this Owner of the Airplane is 1';
	END IF;
END //
delimiter ;

-- In case we change the owner of an airplane
-- This check before udpate the last airplane in Airplane of an Owner
delimiter //
CREATE TRIGGER AMS.Airplane_Owner_BU BEFORE UPDATE
ON AMS.Airplane
FOR EACH ROW
BEGIN
	DECLARE numAirplaneOfOwner INT;
    
    SELECT COUNT(*) INTO numAirplaneOfOwner
    FROM AMS.Airplane
    WHERE OwnerID = OLD.OwnerID;
    
    IF NEW.OwnerID <> OLD.OwnerID AND numAirplaneOfOwner = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from Airplane; Num Records Remaining of this Owner of the Airplane is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the last record in Expertise of an Model
delimiter //
CREATE TRIGGER AMS.Expertise_BD BEFORE DELETE
ON AMS.Expertise
FOR EACH ROW
BEGIN
	DECLARE numModelInExpertise INT;
    
    SELECT COUNT(*) INTO numModelInExpertise
    FROM AMS.Expertise 
    WHERE ModelID = OLD.ModelID;
    
    IF numModelInExpertise = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Expertise; Num Records Remaining of this Model of the Expertise is 1';
	END IF;
END //
delimiter ;

-- This check before update the last record in Expertise of an Model
delimiter //
CREATE TRIGGER AMS.Expertise_BU BEFORE UPDATE
ON AMS.Expertise
FOR EACH ROW
BEGIN
	DECLARE numModelInExpertise INT;
    
    SELECT COUNT(*) INTO numModelInExpertise
    FROM AMS.Expertise 
    WHERE ModelID = OLD.ModelID;
    
    IF NEW.ModelID <> OLD.ModelID AND numModelInExpertise = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from Expertise; Num Records Remaining of this Model of the Expertise is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the record in Operate of a Flight
-- Now define the trigger:
-- A flight must have at least 2 pilots and 2 flight attendants
delimiter //
CREATE TRIGGER AMS.Operate_2_Pilot_FA_AD AFTER DELETE
ON AMS.Operates
FOR EACH ROW
BEGIN
	DECLARE numFAOfFlight INT;
    DECLARE numPilotOfFlight INT;
    
    SELECT COUNT(*) INTO numFAOfFlight
    FROM AMS.Operates JOIN AMS.Flight_Attendant ON FSSN = SSN
    WHERE FlightID = OLD.FlightID;
    
    SELECT COUNT(*) INTO numPilotOfFlight
    FROM AMS.Operates JOIN AMS.Pilot ON FSSN = SSN
    WHERE FlightID = OLD.FlightID;
    
    IF numPilotOfFlight < 2 OR numFAOfFlight < 2 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Operate; Num FA must be >= 2 and Num Pilot must be >= 2';
	END IF;
END //
delimiter ;

-- A flight must have at least 2 pilots and 2 flight attendants
delimiter //
CREATE TRIGGER AMS.Operate_2_Pilot_FA_AU AFTER UPDATE
ON AMS.Operates
FOR EACH ROW
BEGIN
	DECLARE numFAOfFlight INT;
    DECLARE numPilotOfFlight INT;
    
    SELECT COUNT(*) INTO numFAOfFlight
    FROM AMS.Operates JOIN AMS.Flight_Attendant ON FSSN = SSN
    WHERE FlightID = OLD.FlightID;
    
    SELECT COUNT(*) INTO numPilotOfFlight
    FROM AMS.Operates JOIN AMS.Pilot ON FSSN = SSN
    WHERE FlightID = OLD.FlightID;
    
    IF numPilotOfFlight < 2 OR numFAOfFlight < 2 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot update from Operate; Num FA must be >= 2 and Num Pilot must be >= 2';
	END IF;
END //
delimiter ;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the last record in Airplane of a Airline
delimiter //
CREATE TRIGGER AMS.Airplane_Airline_BD BEFORE DELETE
ON AMS.Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordOfAirline INT;
    
    SELECT COUNT(*) INTO numRecordOfAirline
    FROM AMS.Airplane 
    WHERE AirlineID = OLD.AirlineID;
    
    IF numRecordOfAirline = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Airplane; Num Records Remaining of this Airline of the Airplane is 1';
	END IF;
END //
delimiter ;

-- This check before update the last record in Airplane of a Airline
delimiter //
CREATE TRIGGER AMS.Airplane_Airline_BU BEFORE UPDATE
ON AMS.Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordOfAirline INT;
    
    SELECT COUNT(*) INTO numRecordOfAirline
    FROM AMS.Airplane 
    WHERE AirlineID = OLD.AirlineID;
    
    IF numRecordOfAirline = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Airplane; Num Records Remaining of this Airline of the Airplane is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Trigger: Passenger cannot travel on more than 1 flight at the same time
-- A flight must have at least 2 pilots and 2 flight attendants
delimiter //

CREATE TRIGGER AMS.Ticket_Before_Insert BEFORE INSERT
ON AMS.Ticket
FOR EACH ROW
BEGIN
    DECLARE flight_count INT;
    DECLARE EAT1 TIMESTAMP;
    DECLARE EDT1 TIMESTAMP;
    
    SELECT (EDT) INTO EDT1
    FROM AMS.Seat AS s 
    JOIN AMS.Flight AS f ON s.FlightID = f.FlightID
    WHERE NEW.TicketID = s.TicketID;
    
    SELECT (EAT) INTO EAT1
    FROM AMS.Seat AS s 
    JOIN AMS.Flight AS f ON s.FlightID = f.FlightID
    WHERE NEW.TicketID = s.TicketID;

    -- Count the number of overlapping flights for the given passenger
    SELECT COUNT(*) INTO flight_count
    FROM AMS.Ticket AS t
    JOIN AMS.Seat AS s ON t.TicketID = s.TicketID AND t.SeatNum = s.SeatNum
    JOIN AMS.Flight AS f ON s.FlightID = f.FlightID
    WHERE t.PID = NEW.PID
        AND (
            (f.EAT BETWEEN EAT1 AND EDT1)
            OR (f.EDT BETWEEN EAT1 AND EDT1)
        );

    -- If the count is greater than 0, it means there is an overlap
    IF flight_count > 0 THEN
        SIGNAL SQLSTATE '50001'
        SET MESSAGE_TEXT = 'Passenger is already booked on another flight during this time.';
    END IF;
END;
//
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check the age of employee >= 18
delimiter //
CREATE TRIGGER AMS.Employee_BI BEFORE INSERT
ON AMS.Employee
FOR EACH ROW
BEGIN
	IF TIMESTAMPDIFF(YEAR, NOW(), NEW.DOB) < 18 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot insert to Employee; Employee Age must be at least 18';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- SSN of Person, SSN of Employee must not be overlapped
-- insert person must not have ssn overlapped with emp
delimiter //
CREATE TRIGGER AMS.Employee_SSN_BI BEFORE INSERT
ON AMS.Employee
FOR EACH ROW
BEGIN
	DECLARE c INT;
    
    SELECT COUNT(*) INTO c
    FROM AMS.Person AS p
    WHERE p.SSN = NEW.SSN;
    
    IF c = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot insert to Employee; His/Her SSN one Owner has already';
	END IF;
END //
delimiter ;

-- insert person must not have ssn overlapped with emp
delimiter //
CREATE TRIGGER AMS.Person_SSN_BI BEFORE INSERT
ON AMS.Person
FOR EACH ROW
BEGIN
	DECLARE c INT;
    
    SELECT COUNT(*) INTO c
    FROM AMS.Employee AS e
    WHERE e.SSN = NEW.SSN;
    
    IF c = 1 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot insert to Person; His/Her SSN one Owner has already';
	END IF;
END //
delimiter ;


-- --------------------------------------------------------------------
-- Trigger ATC cannot work in 2 consecutive shift

-- --------------------------------------------------------------------
-- Every model must be maintained by at least 1 engineer of each EType
-- Model PK: ID
-- 'Avionic Engineer', 'Mechanical Engineer', 'Electric Engineer'
delimiter //
CREATE TRIGGER AMS.Engineer_BD BEFORE DELETE
ON AMS.Expertise
FOR EACH ROW
BEGIN
	DECLARE type1 INT;
    DECLARE type2 INT;
    DECLARE type3 INT;
    
    SELECT COUNT(*) INTO type1
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Avionic Engineer';
    
    SELECT COUNT(*) INTO type2
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Mechanical Engineer';
    
    SELECT COUNT(*) INTO type3
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Electric Engineer';
    
    IF type1 = 0 OR type2 = 0 OR type3 = 0 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Engineer; Every model must be maintained by at least 1 engineer of each EType';
	END IF;
END //
delimiter ;

delimiter //
CREATE TRIGGER AMS.Engineer_BU BEFORE UPDATE
ON AMS.Expertise
FOR EACH ROW
BEGIN
	DECLARE type1 INT;
    DECLARE type2 INT;
    DECLARE type3 INT;
    
    SELECT COUNT(*) INTO type1
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Avionic Engineer';
    
    SELECT COUNT(*) INTO type2
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Mechanical Engineer';
    
    SELECT COUNT(*) INTO type3
    FROM AMS.Engineer AS engi JOIN AMS.Expertise AS ex ON engi.SSN = ex.ESSN AND ex.ESSN <> OLD.ESSN
    WHERE OLD.ModelID = ex.ModelID AND engi.EType = 'Electric Engineer';
    
    IF NEW.ESSN <> OLD.ESSN AND type1 = 0 OR type2 = 0 or type3 = 0 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Cannot delete from Engineer; Every model must be maintained by at least 1 engineer of each EType';
	END IF;
END //
delimiter ;

DELIMITER //
CREATE TRIGGER AMS.passenger_pid BEFORE INSERT
ON AMS.Passenger
FOR EACH ROW
BEGIN
    DECLARE pass_pid VARCHAR(25);
	SET pass_pid = CONCAT('P', NEW.PID);
    
    SET NEW.PID_Decode = pass_pid;
END;
//
DELIMITER ;
-- --------------------------------------------------------------------
-- Airport includes all types of emp

DELIMITER //
CREATE TRIGGER update_seat_status AFTER INSERT
ON Ticket
FOR EACH ROW
BEGIN
	UPDATE Seat
    SET Status = 'Unavailable'
    WHERE SeatNum = NEW.SeatNum AND FlightID = NEW.FlightID;
END;
//
DELIMITER ;

-- --------------------------------------------------------------------

DELIMITER //
CREATE FUNCTION count_available_seats(FID INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE cnt INT;
    SELECT COUNT(*) INTO cnt
    FROM Flight JOIN Seat on Flight.FlightID = Seat.FlightID
    WHERE Seat.Status = 'Available';
    
    RETURN cnt;
END;
//
DELIMITER ; 

-- --------------------------------------------------------------------
-- TRIGGER TO MAKE SURE AN OWNER ISN'T AN AIRPORT EMPLOYEE
DELIMITER //
CREATE TRIGGER Owner_Employee_BI BEFORE INSERT
ON Person
FOR EACH ROW
BEGIN 
	DECLARE cntEmp INT;
    
    SELECT COUNT(*) INTO cntEmp
    FROM Employee
    WHERE SSN = NEW.SSN;
    
    IF cntEmp > 0 THEN
		SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Oner cannot be employee';
	END IF;
END;
//
DELIMITER ;


-- --------------------------------------------------------------------


