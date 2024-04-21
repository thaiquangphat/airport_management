-- Note:
-- In this version, I have set "ON DELETE CASCADE" to all the referential integrity constraints
DROP SCHEMA IF EXISTS Test_New;
CREATE SCHEMA Test_New;

USE Test_New;

SET SQL_SAFE_UPDATES = 0; -- note this for allow to not use the safe mode on update
SET GLOBAL log_bin_trust_function_creators = 1;		# ko them thi loi :)))
-- --------------------------------------------------------------------
CREATE TABLE `system_settings` (
  `id` INT NOT NULL,
  `name` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `cover_img` text NOT NULL
);

--
-- Dumping data for table `system_settings`
--
INSERT INTO `system_settings` (`id`, `name`, `email`, `contact`, `address`, `cover_img`) VALUES
(1, 'Airport Management System', 'info@sample.comm', '+6123 4567 899', '123  ABC DEF, GHI, MNP, 123123', '');

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`);
-- --------------------------------------------------------------------
-- CREATE TABLE `users` (
--   `id` int(30) AUTO_INCREMENT,
--   `firstname` varchar(200) NOT NULL,
--   `lastname` varchar(200) NOT NULL,
--   `email` varchar(200) NOT NULL,
--   `password` text NOT NULL,
--   `type` tinyint(1) NOT NULL DEFAULT 2 COMMENT '1 = admin, 2 = staff',
--   `avatar` text NOT NULL DEFAULT 'no-image-available.png',
--   `date_created` datetime NOT NULL DEFAULT current_timestamp(),
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

-- Admin: admin@admin.com; Pass: admin123
-- Manager: pauthai@pauthai.com; Pass: pauthai123
-- Manager: khoinguyen@khoinguyen.com; Pass: khoinguyen123
-- User: abc@abc.com; Pass: abc123
-- User: def@def.com; Pass: def123
-- User: ghi@ghi.com; Pass: ghi123

-- Khoi generate data cua thg Passenger thi attribute userid cua passenger lay random
-- trong set 3 so (4 or 5 or 6) thoi

-- INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password`, `type`, `avatar`, `date_created`) VALUES
-- (1, 'Administrator', '', 'admin@admin.com', '0192023a7bbd73250516f069df18b500', 1, 'no-image-available.png', '2024-04-12 09:09:09'),
-- (2, 'Pau', 'Thai', 'pauthai@pauthai.com', '00e4d823dc5548d4b65cd958fe787828', 2, '1606978560_avatar.jpg', '2024-04-12 09:09:09'),
-- (3, 'Khoi', 'Nguyen', 'khoinguyen@khoinguyen.com', '349dc27260635ac9bfed779848d25ab0', 2, '1606978560_avatar.jpg', '2024-04-12 09:09:09'),
-- (4, 'abc', 'abc', 'abc@abc.com', 'e99a18c428cb38d5f260853678922e03', 3, 'no-image-available.png', '2024-04-12 09:09:09'),
-- (5, 'def', 'def', 'def@def.com', 'e88ebfe1ae982a6da01436e48af6eb74', 3, 'no-image-available.png', '2024-04-12 09:09:09'),
-- (6, 'ghi', 'ghi', 'ghi@ghi.com', '118e0bfeafaae5544f3f486533cf56db', 3, 'no-image-available.png', '2024-04-12 09:09:09');

CREATE TABLE Employee
(
    SSN    		CHAR(10),
    Fname  		VARCHAR(50),
    Minit  		CHAR(2),
    Lname  		VARCHAR(50),
    Salary 		FLOAT,
    Phone  		CHAR(10),
    DOB    		DATE,
    Sex    		ENUM ('F', 'M'),
    Date_Start  DATE,
    PRIMARY KEY (SSN),
    CONSTRAINT `check-salary` CHECK (( Salary > 0 ))
);

CREATE TABLE Supervision
(
    SSN      	CHAR(10),
    SuperSSN 	CHAR(10),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (SuperSSN) REFERENCES Employee (SSN) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Employee_Address
(
    SSN      	CHAR(10),
    Street   	VARCHAR(50),
    City     	VARCHAR(50),
    District 	VARCHAR(50),
    PRIMARY KEY (SSN, Street, City, District),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Administrative_Support
(
    SSN    		CHAR(10),
    ASType 		ENUM ('Secretary', 
					'Data Entry', 
                    'Receptionist', 
                    'Communications', 
                    'PR', 'Security', 
                    'Ground Service', 
                    'HR', 
                    'Emergency Service'),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Engineer
(
    SSN   		CHAR(10),
    EType 		ENUM ('Avionic Engineer', 
					'Mechanical Engineer', 
                    'Electric Engineer'),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Traffic_Controller
(
    SSN 		CHAR(10),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TCShift
(
    TCSSN 		CHAR(10),
    Shift 		ENUM ('Morning', 
					'Afternoon', 
                    'Evening', 
                    'Night'),
    PRIMARY KEY (TCSSN, Shift),
    FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Flight_Employee
(
    FESSN 		CHAR(10),
    PRIMARY KEY (FESSN),
    FOREIGN KEY (FESSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Pilot
(
    SSN     	CHAR(10),
    License 	CHAR(12),
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Flight_Attendant
(
    SSN             CHAR(10),
    Year_experience FLOAT,
    PRIMARY KEY (SSN),
    FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE Passenger
(
    PID         INT(4) 		ZEROFILL 	AUTO_INCREMENT,
    PID_Decode 	VARCHAR(25),
    PassportNo  CHAR(12) 	NOT NULL 	UNIQUE,
    Sex         ENUM ('M', 'F'),
    DOB         DATE,
    Nationality VARCHAR(50),
    Fname       VARCHAR(50),
    Minit       CHAR(2),
    Lname       VARCHAR(50),
    -- Tao nghi la phai them 1 attribute de biet thg user (type 3: emp/user) nao` tao.
    UserID 		INT,
    
    -- Nay la tao them vao` tao nghi la can nen cu tao data co no di
    PRIMARY KEY (PID)
    -- FOREIGN KEY (UserID) REFERENCES users (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Passenger_Phone
(
    PID   		INT(4) 		ZEROFILL,
    Phone 		CHAR(10),
    PRIMARY KEY (PID, Phone),
    FOREIGN KEY (PID) REFERENCES Passenger (PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE Owner
(
    OwnerID 	INT 		AUTO_INCREMENT,
    Phone   	CHAR(10),
    PRIMARY KEY (OwnerID)
);

CREATE TABLE Cooperation
(
    Name   		VARCHAR(50),
    Address 	VARCHAR(50),
    OwnerID 	INT,
    PRIMARY KEY (Name),
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Person
(
    SSN     	CHAR(10),
    Name    	VARCHAR(50),
    Address 	VARCHAR(50),
    OwnerID 	INT,
    PRIMARY KEY (SSN),
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE Airport
(
    APCode		CHAR(3),
    APName		VARCHAR(50),
    City		VARCHAR(50),
    Latitude	FLOAT,
    Longitude	FLOAT,
    PRIMARY KEY (APCode)
);

CREATE TABLE Route
(
    ID 			INT AUTO_INCREMENT,
    SourceAP    CHAR(3),
    DestAP      CHAR(3),
    RName 		CHAR(7),
    Distance 	FLOAT,
    APCode		CHAR(3),
    PRIMARY KEY (ID),
    FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Airline
(
    AirlineID      CHAR(3),
    IATADesignator CHAR(2) 	UNIQUE 	NOT NULL,
    Name           VARCHAR(50),
    Country        VARCHAR(50),
    PRIMARY KEY (AirlineID)
);

CREATE TABLE Model
(
    ID        		INT AUTO_INCREMENT,
    MName     		VARCHAR(20),
    Capacity  		INT,
    MaxSpeed  		FLOAT,
    PRIMARY KEY (ID)
);

CREATE TABLE Airplane
(
    AirplaneID        INT 			AUTO_INCREMENT,
    License_plate_num VARCHAR(7) 	UNIQUE 		NOT NULL,
    AirlineID         CHAR(3)		NOT NULL,
    OwnerID           INT			NOT NULL,
    ModelID           INT,
    LeasedDate        DATETIME 		DEFAULT '1970-01-01 00:00:00' NOT NULL,
    PRIMARY KEY (AirplaneID),
    FOREIGN KEY (AirlineID) REFERENCES Airline (AirlineID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE Consultant
(
    ID 		INT 	AUTO_INCREMENT,
    Name    VARCHAR(50),
    PRIMARY KEY (ID)
);
-- --------------------------------------------------------------------
CREATE TABLE Flight
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
    BasePrice       FLOAT,
    PRIMARY KEY (FlightID),
    UNIQUE (RID, FlightCode),
    FOREIGN KEY (RID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AirplaneID) REFERENCES Airplane (AirplaneID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `check-valid-date` CHECK (( EAT > EDT ))
);

-- ------------------------------------------ IMPORTANT --------------------------------------------------
-- Assumption: Passenger can still cancel his flight before his check-in time.
-- Case 1: Passenger SUCCESSFULLY booked his flight. CheckinTime = DEFAULT, CheckinStatus = 'No', Seat.Status = 'Unavailable'.
-- Case 2: Passenger cancels the flight. CheckinTime = DEFAULT, CheckinStatus = 'No', Seat.Status = 'Available'.
-- Case 3: Passenger did not check-in or late check-in. CheckinTime = DEFAULT, CheckinStatus = 'No',
--                                                      [Seat.Status = 'Available' AT THE TIME OF (Flight.EDT - 15MINUTES)]
-- Case 4: Passenger check-in on-time at the airport and certainly fly: CheckInStatus = 'Yes', Seat.Status = 'Unavailable'.
-- Every passenger must check-in their flight [at least 15 minutes and at most 24 hours] in advance of Flight.EDT.

CREATE TABLE Seat
(
    FlightID INT,
    SeatNum  VARCHAR(3),           -- Trigger SeatNum < ROUND(0.9*Model.Capacity), format: <row><[A-F]> e.g. 01A, 11E
    Class    ENUM ('Business', 'Economy', 'First Class'),
    Status   ENUM ('Unavailable', 'Available') DEFAULT 'Available',
    Price    NUMERIC,
    PRIMARY KEY (FlightID, SeatNum),
    FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Seat
ADD INDEX idx_SeatNum (SeatNum),
ADD INDEX idx_FlightID (FlightID);

CREATE TABLE Ticket
(
    TicketID      	INT AUTO_INCREMENT,
    PID           	INT(4) ZEROFILL,
    SeatNum       	VARCHAR(3),
    CheckInTime   	DATETIME DEFAULT '1970-01-01 00:00:00',
    CheckInStatus 	ENUM ('No', 'Yes') DEFAULT 'No',
    BookTime      	DATETIME DEFAULT '1970-01-01 00:00:00' NOT NULL,
    CancelTime		DATETIME,
    FlightID      	INT,
    PRIMARY KEY (TicketID),
    FOREIGN KEY (PID) REFERENCES Passenger (PID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (SeatNum, FlightID) REFERENCES Seat (SeatNum, FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------

CREATE TABLE Expert_At
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

CREATE TABLE Expertise
(
    ESSN    CHAR(10),
    ModelID INT,
    PRIMARY KEY (ESSN, ModelID),
    FOREIGN KEY (ESSN) REFERENCES Engineer (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------------------

CREATE TABLE Operates
(
    FSSN     CHAR(10),
    FlightID INT,
    Role     VARCHAR(20),
    PRIMARY KEY (FSSN, FlightID),
    FOREIGN KEY (FSSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP USER IF EXISTS 'sManager'@'localhost';
DROP USER IF EXISTS 'rUser'@'localhost';
-- SELECT User, Host FROM mysql.user WHERE User='sManager' AND Host='localhost';
CREATE USER 'sManager'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON Test_New.* TO 'sManager'@'localhost';
CREATE USER 'rUser'@'localhost' IDENTIFIED BY '123456';
GRANT SELECT ON Test_new.* TO 'rUser'@'localhost';

-- --------------------------------------------------------------------
-- Start function
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
DELIMITER //

CREATE FUNCTION CalculateAgeBySSN(employeeSSN CHAR(10))
RETURNS INT
BEGIN
    DECLARE birthDate DATE;
    DECLARE age INT;
    
    -- Retrieve the DOB of the employee using the provided SSN
    SELECT DOB INTO birthDate FROM Employee WHERE SSN = employeeSSN;
    
    -- Calculate the age based on the retrieved DOB
    SET age = TIMESTAMPDIFF(YEAR, birthDate, CURDATE());
    
    RETURN age;
END //

DELIMITER ;

-- --------------------------------------------------------------------
-- Function for getting the duration of a FLight 
delimiter //
CREATE FUNCTION getDuration (fid INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
	DECLARE aAT TIMESTAMP; 
    DECLARE aDT TIMESTAMP;
    
	SELECT AAT, ADT
    INTO aAT, aDT
    FROM flight AS f
    WHERE f.FlightID = fid;
    
    IF ISNULL(aAT) OR ISNULL(aDT) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Unknown actual arrival time or actual departure time";
	END IF;
    
    RETURN CONCAT(FLOOR(HOUR(TIMEDIFF(aDT, aAT)) / 24), ' days ',
				  MOD(HOUR(TIMEDIFF(aDT, aAT)), 24), ' hours ',
				  MINUTE(TIMEDIFF(aDT, aAT)), ' minutes');
END
//
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

-- ----------------------------------------------------------------------------------------------------------- 
-- Function for getting the total number of employee working on a flight
-- Number of Pilots and Flight Attendants
delimiter //
CREATE FUNCTION getNoFEmployees (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE countFE INT;
    
	SELECT COUNT(*) INTO countFE
    FROM Operates AS o
    WHERE o.FlightID = fid;
    
    RETURN countFE;
END
//

-- ----------------------------------------------------------------------------------------------------------- 
-- Get number of Passenger of a FLight
delimiter //
CREATE FUNCTION getNoPassenger (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE countP INT;
    
	SELECT COUNT(*) INTO countP
    FROM Seat AS s
    WHERE s.FlightID = fid AND s.status = 'Unavailable';
    
    RETURN countP;
END
//

DELIMITER //
CREATE FUNCTION revenue_flights(flight_id INT)
RETURNS FLOAT
BEGIN
    DECLARE revenue FLOAT;
    SET revenue = 0;

    SELECT SUM(Price) INTO revenue
    FROM Seat
    WHERE FlightID = flight_id AND Status = 'Unavailable';

    RETURN revenue;
END
//
DELIMITER ;
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
-- Nay tao moi Add vao de lam cho dep dep dui dui :))
DELIMITER //
CREATE FUNCTION getNoPilots (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE countPilots INT;
    
    SELECT COUNT(*) INTO countPilots
    FROM Operates AS o
    JOIN Pilot AS p ON o.FSSN = p.SSN
    WHERE o.FlightID = fid;
    
    RETURN countPilots;
END
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION getNoFlightAttendants (fid INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE countFlightAttendants INT;
    
    SELECT COUNT(*) INTO countFlightAttendants
    FROM Operates AS o
    JOIN Flight_Attendant AS fa ON o.FSSN = fa.SSN
    WHERE o.FlightID = fid;
    
    RETURN countFlightAttendants;
END
//
DELIMITER ;

DELIMITER //

CREATE FUNCTION CalculateTotalSpent(PassengerID INT)
RETURNS FLOAT
BEGIN
    DECLARE total_spent FLOAT;
    
    SELECT SUM(Price) INTO total_spent
    FROM Ticket
    JOIN Seat ON Ticket.SeatNum = Seat.SeatNum AND Ticket.FlightID = Seat.FlightID
    WHERE Ticket.PID = PassengerID;
    
    RETURN total_spent;
END;
//
-- ----------------------------------------------------------------------------------------------------------- 
-- ----------------------------------------------------------------------------------------------------------- 
DELIMITER //

CREATE FUNCTION CalculateAge(birthDate DATE)
RETURNS INT
BEGIN
    DECLARE age INT;
    SET age = TIMESTAMPDIFF(YEAR, birthDate, CURDATE());
    RETURN age;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------- 
-- Get the age of the Passenger
delimiter //
CREATE FUNCTION getAge (pid_input INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE age INT;
    
	SELECT TIMESTAMPDIFF(YEAR, NOW(), dob) INTO age
    FROM passenger AS p
    WHERE p.pid = pid_input;
    
    RETURN age;
END
//

delimiter //
CREATE FUNCTION CheckEmployeeAge(DOB DATE) RETURNS BOOLEAN
BEGIN
    DECLARE emp_age INT;
    SET emp_age = YEAR(CURRENT_DATE()) - YEAR(DOB);
    
    IF (emp_age < 18) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
//

ALTER TABLE Employee
ADD CONSTRAINT CheckAge CHECK (CheckEmployeeAge(DOB));

-- ----------------------------------------------------------------------------------------------------------- 
-- Trigger
-- ----------------------------------------------------------------------------------------------------------- 
DELIMITER //

CREATE TRIGGER EnsureEmployeeAge
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    DECLARE employeeAge INT;
    SET employeeAge = CalculateAge(NEW.DOB);
    
    IF employeeAge < 18 OR employeeAge > 75 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Employee must be between 18 and 75 years old.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER CheckSalaryAgainstSupervisor
BEFORE INSERT ON Supervision
FOR EACH ROW
BEGIN
    DECLARE supervisorSalary FLOAT;
    DECLARE empSalary FLOAT;
    
    -- Get the salary of the supervisor
    SELECT Salary INTO supervisorSalary
    FROM Employee
    WHERE SSN = NEW.SuperSSN;
    
    SELECT Salary INTO empSalary
    FROM Employee
    WHERE SSN = NEW.SSN;
    
    -- Check if the new employee's salary is greater than or equal to the supervisor's salary
    IF empSalary >= supervisorSalary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee salary must be less than supervisor salary; Cannot let this Employee be Supervise by the Supervisor';
    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------- 
-- A flight must have at least 2 pilots and 2 flight attendants
delimiter //
CREATE TRIGGER Operate_2_Pilot_FA_AU AFTER UPDATE
ON Flight_Employee
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE FlightID INT; -- Define FlightID variable
    DECLARE numPilots INT;
    DECLARE numFlightAttendants INT;
    DECLARE curFlight CURSOR FOR
        SELECT DISTINCT FlightID
        FROM Operates
        WHERE FSSN = OLD.FESSN;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN curFlight;
    read_loop: LOOP
        FETCH curFlight INTO FlightID;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Count the number of pilots for the current flight
        SELECT COUNT(*) INTO numPilots
        FROM Operates o
        JOIN Pilot p ON o.FSSN = p.SSN
        WHERE o.FlightID = FlightID;

        -- Count the number of flight attendants for the current flight
        SELECT COUNT(*) INTO numFlightAttendants
        FROM Operates o
        JOIN Flight_Attendant fa ON o.FSSN = fa.SSN
        WHERE o.FlightID = FlightID;

        -- Check if the current flight violates the constraint
        IF numPilots < 2 OR numFlightAttendants < 2 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Each flight must have at least 2 pilots and 2 flight attendants.';
        END IF;
    END LOOP;
    CLOSE curFlight;
END //
delimiter ;
-- --------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------- 
DELIMITER //

CREATE TRIGGER before_delete_employee
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN
    DECLARE tc_count INT;
    DECLARE engineer_count INT;
    DECLARE pilot_count INT;
    DECLARE flight_attendant_count INT;

    -- Check if the employee is a Traffic Controller and controls only one flight
    IF EXISTS (
        SELECT 1
        FROM Traffic_Controller
        WHERE SSN = OLD.SSN
    ) THEN
        SELECT COUNT(*)
        INTO tc_count
        FROM Flight
        WHERE TCSSN = OLD.SSN;

        IF tc_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete the Traffic Controller. There is a flight controlled by only this Traffic Controller.';
        END IF;
    END IF;

    -- Check if the employee is an Engineer and has expertise in only one model
    IF EXISTS (
        SELECT 1
        FROM Engineer
        WHERE SSN = OLD.SSN
    ) THEN
		SELECT COUNT(*) INTO engineer_count
		FROM Expertise
		WHERE ESSN = OLD.SSN
		AND ModelID IN (
			SELECT ModelID
			FROM Expertise
			GROUP BY ModelID
			HAVING COUNT(ESSN) = 1
		);

        IF engineer_count = 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete the Engineer. There is a model where the engineer is the only expert.';
        END IF;
    END IF;

    -- Check if the employee is a Pilot and is one of only two pilots for a flight
    IF EXISTS (
        SELECT 1
        FROM Pilot
        WHERE SSN = OLD.SSN
    ) THEN
		-- SELECT COUNT(*) INTO engineer_count
-- 		FROM Expertise
-- 		WHERE ESSN = OLD.SSN
-- 		AND ModelID IN (
-- 			SELECT ModelID
-- 			FROM Expertise
-- 			GROUP BY ModelID
-- 			HAVING COUNT(ESSN) = 1
-- 		);
		
        SELECT COUNT(*)
        INTO pilot_count
        FROM Operates
        WHERE FSSN = OLD.SSN AND Role = 'Pilot' AND FlightID IN (
			SELECT O.FlightID
            FROM Operates AS O
            WHERE O.Role = 'Pilot'
            GROUP BY O.FlightID
            HAVING COUNT(O.FSSN) = 2
        );

        IF pilot_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete the Pilot. There is a flight with only two pilots.';
        END IF;
    END IF;

    -- Check if the employee is a Flight Attendant and is one of only two flight attendants for a flight
    IF EXISTS (
        SELECT 1
        FROM Flight_Attendant
        WHERE SSN = OLD.SSN
    ) THEN
        SELECT COUNT(*)
        INTO flight_attendant_count
        FROM Operates
        WHERE FSSN = OLD.SSN AND Role = 'Flight Attendant' AND FlightID IN (
			SELECT O.FlightID
            FROM Operates AS O
            WHERE O.Role = 'Flight Attendant'
            GROUP BY O.FlightID
            HAVING COUNT(O.FSSN) = 2
        );

        IF flight_attendant_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete the Flight Attendant. There is a flight with only two flight attendants.';
        END IF;
    END IF;

END;
//

DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------- 
-- DELIMITER //

-- CREATE TRIGGER before_flight_insert
-- BEFORE INSERT ON Flight
-- FOR EACH ROW
-- BEGIN
-- 	IF TIMESTAMPDIFF(SECOND, NEW.EDT, NEW.EAT) <= 0 THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'EAT must be greater than EDT';
--     END IF;
-- END;
-- //

-- DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------- 
DELIMITER //

CREATE TRIGGER check_delete_airline
BEFORE DELETE ON Airline
FOR EACH ROW
BEGIN
    DECLARE airplane_count INT;
    DECLARE owner_count INT;
    
    -- Check the number of airplanes associated with the airline
    SELECT COUNT(*) INTO airplane_count
    FROM Airplane
    WHERE AirlineID = OLD.AirlineID;
    
    -- If there are airplanes associated with the airline
    IF airplane_count > 0 THEN
        -- Check the number of airplanes owned by each owner associated with the airline
        SELECT COUNT(*)
        INTO owner_count
        FROM (
            SELECT OwnerID
            FROM Airplane
            WHERE AirlineID = OLD.AirlineID
            GROUP BY OwnerID
            HAVING COUNT(*) = 1
        ) AS owners_with_single_airplane;
        
        -- If there is any owner with only one airplane, prevent the deletion
        IF owner_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete airline. Some owners have only one airplane.';
        END IF;
    END IF;
END;
//

DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------- 
-- This trigger is for checking EAT EDT AAT ADT of a Flight
DELIMITER //

CREATE TRIGGER check_flight_constraints
BEFORE UPDATE ON Flight
FOR EACH ROW
BEGIN
    DECLARE error_message VARCHAR(255);

    IF NEW.EAT <> OLD.EAT AND NEW.EDT <> OLD.EDT AND NEW.EAT <= NEW.EDT THEN
        SET error_message = 'EAT must be larger than EDT';
    ELSEIF NEW.EAT <> OLD.EAT AND NEW.EDT = OLD.EDT AND NEW.EAT <= OLD.EDT THEN
        SET error_message = 'EAT must be larger than EDT';
    ELSEIF NEW.AAT <> OLD.AAT AND NEW.ADT <> OLD.ADT AND NEW.AAT <= NEW.ADT THEN
        SET error_message = 'AAT must be larger than ADT';
    ELSEIF NEW.AAT <> OLD.AAT AND NEW.AAT <= NEW.ADT THEN
        SET error_message = 'AAT must be larger than ADT';
    ELSE
        SET error_message = NULL; -- No error
    END IF;

    IF error_message IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
END;
//

DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------- 
-- Trigger of EXPERT_AT: total side CONSULTANT (ID)
-- This check before delete the last record in EXPERT_AT of a Consultant
delimiter //
CREATE TRIGGER Expert_At_BD BEFORE DELETE
ON Expert_At
FOR EACH ROW
BEGIN
	DECLARE numRecordConsult INT;
    
    SELECT COUNT(*) INTO numRecordConsult
    FROM Expert_At
    WHERE ConsultID = OLD.ConsultID;
    
    IF numRecordConsult = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from EXPERT_AT; Num Records Remaining of this Consultant is 1';
	END IF;
END //
delimiter ;

-- This check before delete the update record in EXPERT_AT of a Consultant
delimiter //
CREATE TRIGGER Expert_At_BU BEFORE UPDATE
ON Expert_At
FOR EACH ROW
BEGIN
	DECLARE numRecordConsult INT;
    
    SELECT COUNT(*) INTO numRecordConsult
    FROM Expert_At
    WHERE ConsultID = OLD.ConsultID;
    
    IF NEW.ConsultID <> OLD.ConsultID AND numRecordConsult = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update from EXPERT_AT; Num Records Remaining of this Consultant is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Note: insert Owner before insert his/her airplanes
-- This check before delete the last airplane in Airplane of an Owner
delimiter //
CREATE TRIGGER Airplane_Owner_BD BEFORE DELETE
ON Airplane
FOR EACH ROW
BEGIN
	DECLARE numAirplaneOfOwner INT;
    
    SELECT COUNT(*) INTO numAirplaneOfOwner
    FROM Airplane
    WHERE OwnerID = OLD.OwnerID;
    
    IF numAirplaneOfOwner = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from Airplane; Num Records Remaining of this Owner of the Airplane is 1';
	END IF;
END //
delimiter ;

-- In case we change the owner of an airplane
-- This check before udpate the last airplane in Airplane of an Owner
delimiter //
CREATE TRIGGER Airplane_Owner_BU BEFORE UPDATE
ON Airplane
FOR EACH ROW
BEGIN
	DECLARE numAirplaneOfOwner INT;
    
    SELECT COUNT(*) INTO numAirplaneOfOwner
    FROM Airplane
    WHERE OwnerID = OLD.OwnerID;
    
    IF NEW.OwnerID <> OLD.OwnerID AND numAirplaneOfOwner = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update from Airplane; Num Records Remaining of this Owner of the Airplane is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before update an Engineer 
-- -It must check the relationship with Model through Expertise
-- -If exists a model that has this Engineer that is the only one expertise
-- that model --> no update
delimiter //
CREATE TRIGGER Expertise_BU BEFORE UPDATE
ON Engineer
FOR EACH ROW
BEGIN
    DECLARE num INT;
    
    SELECT COUNT(*) INTO num
    FROM Expertise AS E1
    WHERE E1.ESSN = OLD.SSN AND E1.ModelID IN (
		SELECT E2.ModelID
        FROM Expertise AS E2
        WHERE E2.ModelID IN (SELECT E3.ModelID FROM Expertise AS E3 WHERE E3.ESSN = OLD.SSN)
        GROUP BY E2.ModelID
        HAVING COUNT(*) = 1
    );
    
    IF num >= 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from Engineer; Exist Model has only be expertized by this Engineer';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- This check before delete the last record in Airplane of a Airline
delimiter //
CREATE TRIGGER Airplane_Airline_BD BEFORE DELETE
ON Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordOfAirline INT;
    
    SELECT COUNT(*) INTO numRecordOfAirline
    FROM Airplane 
    WHERE AirlineID = OLD.AirlineID;
    
    IF numRecordOfAirline = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete from Airplane; Num Records Remaining of this Airline of the Airplane is 1';
	END IF;
END //
delimiter ;

-- This check before update the last record in Airplane of a Airline
delimiter //
CREATE TRIGGER Airplane_Airline_BU BEFORE UPDATE
ON Airplane
FOR EACH ROW
BEGIN
	DECLARE numRecordOfAirline INT;
    
    SELECT COUNT(*) INTO numRecordOfAirline
    FROM Airplane 
    WHERE AirlineID = OLD.AirlineID;
    
    IF OLD.AirlineID <> NEW.AirlineID AND numRecordOfAirline = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update from Airplane; Num Records Remaining of this Airline of the Airplane is 1';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Trigger: Passenger cannot travel on more than 1 flight at the same time
-- A flight must have EXACTLY 2 pilots and 2 flight attendants
# delimiter //
#
# CREATE TRIGGER Ticket_Before_Insert BEFORE INSERT
# ON Ticket
# FOR EACH ROW
# BEGIN
#     DECLARE flight_count INT;
#     DECLARE EAT1 TIMESTAMP;
#     DECLARE EDT1 TIMESTAMP;
#
#     SELECT (EDT) INTO EDT1
#     FROM Seat AS s
#     JOIN Flight AS f ON s.FlightID = f.FlightID
#     WHERE NEW.TicketID = s.TicketID;        # nhớ sửa lại là có đúng 2 FA, 2pilot
#
#     SELECT (EAT) INTO EAT1
#     FROM Seat AS s
#     JOIN Flight AS f ON s.FlightID = f.FlightID
#     WHERE NEW.TicketID = s.TicketID;
#
#     -- Count the number of overlapping flights for the given passenger
#     SELECT COUNT(*) INTO flight_count
#     FROM Ticket AS t
#     JOIN Seat AS s ON t.TicketID = s.TicketID AND t.SeatNum = s.SeatNum
#     JOIN Flight AS f ON s.FlightID = f.FlightID
#     WHERE t.PID = NEW.PID
#         AND (
#             (f.EAT BETWEEN EAT1 AND EDT1)
#             OR (f.EDT BETWEEN EAT1 AND EDT1)
#         );
#
#     -- If the count is greater than 0, it means there is an overlap
#     IF flight_count > 0 THEN
#         SIGNAL SQLSTATE '45000'
#         SET MESSAGE_TEXT = 'Passenger is already booked on another flight during this time.';
#     END IF;
# END;
# //
# delimiter ;
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Trigger ATC cannot work in 2 consecutive shift
DELIMITER //
CREATE TRIGGER CheckConsecutiveShifts BEFORE INSERT ON TCShift
FOR EACH ROW
BEGIN
    DECLARE lastShift ENUM('Morning', 'Afternoon', 'Evening', 'Night');
    
    -- Get the last shift assigned to the ATC
    SELECT Shift INTO lastShift
    FROM TCShift
    WHERE TCSSN = NEW.TCSSN
    ORDER BY Shift DESC
    LIMIT 1;
    
    -- Night, Morning, Evening, Afternoon;   
    -- Check if the new shift is consecutive to the last shift
    IF (
        (lastShift = 'Morning' AND NEW.Shift = 'Afternoon') OR
        (lastShift = 'Afternoon' AND NEW.Shift = 'Evening') OR
        (lastShift = 'Evening' AND NEW.Shift = 'Night') 
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ATC cannot work in two consecutive shifts';
    END IF;
END //
DELIMITER ;

-- --------------------------------------------------------------------
-- Every model must be maintained by at least 1 engineer of each EType
-- Model PK: ID
-- 'Avionic Engineer', 'Mechanical Engineer', 'Electric Engineer'
DELIMITER //

CREATE TRIGGER check_engineer_after_delete
AFTER DELETE ON Engineer
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE model_id INT;
    DECLARE e_type ENUM('Avionic Engineer', 'Mechanical Engineer', 'Electric Engineer');
    -- This loop over the type of Engineer
    DECLARE e_type_cursor CURSOR FOR SELECT DISTINCT EType FROM Engineer;
    -- This loop over the Model that the deleted engineer has expertise on
    DECLARE model_cursor CURSOR FOR SELECT DISTINCT ModelID FROM Expertise WHERE ESSN = OLD.SSN;
    
    OPEN e_type_cursor;
    read_loop: LOOP
        FETCH e_type_cursor INTO e_type;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        OPEN model_cursor;
        model_loop: LOOP
            FETCH model_cursor INTO model_id;
            IF done THEN
                LEAVE model_loop;
            END IF;
            
            IF NOT EXISTS (SELECT * FROM Expertise WHERE ModelID = model_id AND ESSN IN (SELECT SSN FROM Engineer WHERE EType = e_type)) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Every model must be maintained by at least one engineer of each type.';
            END IF;
        END LOOP model_loop;
        CLOSE model_cursor;
    END LOOP read_loop;
    CLOSE e_type_cursor;
END;
//

DELIMITER ;

-- Check before update the type of engineer
-- Which mean if update other attribute other than Etype we do not care
-- If update Etype we then check if it is different from the old Etype
-- before check if all the model it expertise on has satisfy the constraint
-- that every model must be expertize by at least one engineer of each etype
DELIMITER //

CREATE TRIGGER check_engineer_after_update
AFTER UPDATE ON Engineer
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE model_id INT;
    DECLARE e_type ENUM('Avionic Engineer', 'Mechanical Engineer', 'Electric Engineer');
    -- This loop over the type of Engineer
    DECLARE e_type_cursor CURSOR FOR SELECT DISTINCT EType FROM Engineer;
    -- This loop over the Model that the deleted engineer has expertise on
    DECLARE model_cursor CURSOR FOR SELECT DISTINCT ModelID FROM Expertise WHERE ESSN = OLD.SSN;
    
    OPEN e_type_cursor;
    read_loop: LOOP
        FETCH e_type_cursor INTO e_type;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        OPEN model_cursor;
        model_loop: LOOP
            FETCH model_cursor INTO model_id;
            IF done THEN
                LEAVE model_loop;
            END IF;
            
            IF OLD.Etype <> NEW.Etype AND NOT EXISTS (SELECT * FROM Expertise WHERE ModelID = model_id AND ESSN IN (SELECT SSN FROM Engineer WHERE EType = e_type)) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Every model must be maintained by at least one engineer of each type.';
            END IF;
        END LOOP model_loop;
        CLOSE model_cursor;
    END LOOP read_loop;
    CLOSE e_type_cursor;
END;
//

DELIMITER ;

-- --------------------------------------------------------------------
-- This trigger is used for create a Primary key of Passenger
-- by concat the AUTO_INCRE postfix with the prefix 'P'
DELIMITER //
CREATE TRIGGER passenger_pid BEFORE INSERT
ON Passenger
FOR EACH ROW
BEGIN
    DECLARE pass_pid VARCHAR(25);
	SET pass_pid = CONCAT('P', NEW.PID);
    
    SET NEW.PID_Decode = pass_pid;
END;
//
DELIMITER ;
-- --------------------------------------------------------------------
-- This trigger is for update the status of the seat when ticket has been checked in
DELIMITER //

CREATE TRIGGER update_seat_status
AFTER UPDATE ON Ticket
FOR EACH ROW
BEGIN
    IF NEW.CheckInStatus = 'Yes' THEN
        UPDATE Seat
        SET Status = 'Unavailable'
        WHERE FlightID = NEW.FlightID AND SeatNum = NEW.SeatNum;
    END IF;
END;
//

DELIMITER ;

-- This trigger is for update the status of the seat when delete a ticket
DELIMITER //

CREATE TRIGGER update_seat_status_after_ticket_delete
AFTER DELETE ON Ticket
FOR EACH ROW
BEGIN
    UPDATE Seat
    SET Status = 'Unavailable'
    WHERE FlightID = OLD.FlightID AND SeatNum = OLD.SeatNum;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_insert_ticket
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
    DECLARE existing_ticket INT;

    -- Check if the FlightID and SeatNum combination already has a ticket
    SELECT COUNT(*)
    INTO existing_ticket
    FROM Ticket
    WHERE FlightID = NEW.FlightID AND SeatNum = NEW.SeatNum;

    IF existing_ticket > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert ticket. The seat is already booked.';
    END IF;

    -- Check if the seat is set to Unavailable
    SELECT Status
    INTO @seat_status
    FROM Seat
    WHERE FlightID = NEW.FlightID AND SeatNum = NEW.SeatNum;

    IF @seat_status = 'Unavailable' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert ticket. The seat is already unavailable.';
    END IF;
END;
//

DELIMITER ;


-- --------------------------------------------------------------------
-- This trigger to modify the value of the base price of the flight
-- DELIMITER //

-- CREATE TRIGGER UpdateFlightBasePrice BEFORE INSERT ON Flight
-- FOR EACH ROW
-- BEGIN
--     DECLARE distance FLOAT;
--     DECLARE base_price FLOAT;
--     
--     -- Get the distance of the route associated with the new flight
--     SELECT Distance INTO distance FROM Route WHERE ID = NEW.RID;
--     
--     -- Calculate the base price by multiplying the distance with 10
--     SET base_price = distance * 10;
--     
--     -- Set the base price of the new flight
--     SET NEW.BasePrice = base_price;
-- END;
-- //

-- DELIMITER ;
-- --------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER calculate_base_price_before_insert
BEFORE INSERT ON Flight
FOR EACH ROW
BEGIN
    -- DECLARE distance FLOAT;
    DECLARE base_price FLOAT;
    
    -- Get the distance of the route associated with the flight
    SELECT Distance INTO @distance 
    FROM Route 
    WHERE ID = NEW.RID;
    
    -- Check if distance is NULL or flight doesn't exist
    IF @distance IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invalid flight ID or associated route does not exist.';
    ELSE
        -- Calculate the base price by multiplying the distance with 0.05
        SET base_price = @distance * 0.05;
        
        -- Update the base price of the flight
        SET NEW.BasePrice = base_price;
    END IF;
END;
//

DELIMITER ;

-- --------------------------------------------------------------------
-- This trigger is for generates the seats whenever we have a new flight
-- - Number of seat = 0.9 * model.capacity
-- - 6 columns: A to F
-- - Format of Seat Num: <number><column>
-- - Seat that has number from 1 -> 5: status = first class
-- - Seat that has number from 6 -> 10: status = Economy
-- - The rest seat has status = Business
-- - Price of Seat based on the Based Price of the Route and the Class
-- - Price of First Class = 2 x Base Price of Route
-- - Price of Economy = 1.5 x Base Price of Route
-- - Price of Business = 1 x Base Price of Route
DELIMITER //

CREATE TRIGGER generate_seats_after_insert
AFTER INSERT ON Flight
FOR EACH ROW
BEGIN
    DECLARE model_capacity INT;
    DECLARE num_seats INT;
    DECLARE seat_column CHAR(1);
    DECLARE seat_num INT;
    DECLARE seat_class ENUM('Business', 'Economy', 'First Class');
    DECLARE seat_price FLOAT;
    DECLARE i INT DEFAULT 1;
    
    -- CALL CalculateFlightBasePrice(NEW.FlightID);
    
    -- Get the capacity of the model of the airplane for the inserted flight
    SELECT Capacity INTO model_capacity FROM Model WHERE ID = (SELECT ModelID FROM Airplane WHERE AirplaneID = NEW.AirplaneID);
    
    -- Calculate the number of seats based on 90% of the model capacity
    SET num_seats = ROUND(0.9 * model_capacity);
    
    -- Loop to generate seats
    WHILE i <= num_seats DO
        -- Determine seat column
        CASE
            WHEN i % 6 = 1 THEN SET seat_column = 'A';
            WHEN i % 6 = 2 THEN SET seat_column = 'B';
            WHEN i % 6 = 3 THEN SET seat_column = 'C';
            WHEN i % 6 = 4 THEN SET seat_column = 'D';
			WHEN i % 6 = 5 THEN SET seat_column = 'E';
            ELSE SET seat_column = 'F';
        END CASE;
        
        -- Determine seat number within column
        SET seat_num = ROUND(i / 6);
        
        -- Determine seat class
        CASE
            WHEN seat_num <= 1 THEN SET seat_class = 'First Class';
            WHEN seat_num <= 4 THEN SET seat_class = 'Business';
            ELSE SET seat_class = 'Economy';
        END CASE;

        -- Determine seat price based on seat class and flight base price
        CASE seat_class
            WHEN 'First Class' THEN SET seat_price = NEW.BasePrice * 2;
            WHEN 'Economy' THEN SET seat_price = NEW.BasePrice * 1.5;
            ELSE SET seat_price = NEW.BasePrice * 1;
        END CASE;
        
        -- Insert seat into Seat table
        INSERT INTO Seat (FlightID, SeatNum, Class, Status, Price) 
        VALUES (NEW.FlightID, CONCAT(LPAD(seat_num + 1, 2, '0'), seat_column), seat_class, 'Available', seat_price);
        -- VALUES (NEW.FlightID, CONCAT(seat_num, seat_column), seat_class, 'Available', seat_price);
        
        SET i = i + 1;
    END WHILE;
END;
//

DELIMITER ;

-- --------------------------------------------------------------------
-- This function is to help to trigger of insert new route after insertion of airport
-- Calculate the Distance by using the function in the link:
-- https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

DELIMITER //

CREATE FUNCTION getDistanceFromLatLonInKm(lat1 FLOAT, lon1 FLOAT, lat2 FLOAT, lon2 FLOAT) RETURNS FLOAT
BEGIN
    DECLARE R FLOAT;
    DECLARE dLat FLOAT;
    DECLARE dLon FLOAT;
    DECLARE a FLOAT;
    DECLARE c FLOAT;
    DECLARE d FLOAT;
    
    SET R = 6371; -- Radius of the earth in km
    
    -- Convert degrees to radians
    SET dLat = radians(lat2 - lat1);
    SET dLon = radians(lon2 - lon1);
    
    -- Calculate the differences
    SET a = sin(dLat / 2) * sin(dLat / 2) +
            cos(radians(lat1)) * cos(radians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    
    -- Calculate the central angle
    SET c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    -- Calculate the distance
    SET d = R * c;
    
    RETURN d; -- Distance in km
END;
//

-- Function nay tao chu hong dung hjhj :))
CREATE FUNCTION deg2rad(deg FLOAT) RETURNS FLOAT
BEGIN
    RETURN deg * (PI() / 180);
END;
//

DELIMITER ;

-- This trigger is to insert a new route into Route table after the new insertion of an airport
DELIMITER //

CREATE TRIGGER insert_route_after_airport_insert
AFTER INSERT ON Airport
FOR EACH ROW
BEGIN
    DECLARE tansonnhat_lat FLOAT;
    DECLARE tansonnhat_lon FLOAT;
    DECLARE new_lat FLOAT;
    DECLARE new_lon FLOAT;
    DECLARE route_distance FLOAT;
    DECLARE route_name char(7);
    DECLARE route_name2 char(7);
    
    -- Get the latitude and longitude of Tansonnhat airport
    SET tansonnhat_lat = 10.8158;
    SET tansonnhat_lon = 106.6641;
    
    -- Get the latitude and longitude of the newly inserted airport
    SET new_lat = NEW.Latitude;
    SET new_lon = NEW.Longitude;
    
    -- Calculate the distance between the two airports
    SET route_distance = getDistanceFromLatLonInKm(tansonnhat_lat, tansonnhat_lon, new_lat, new_lon);
    
    -- Construct the route name with the prefix "SGN-" and the name of the new airport
    SET route_name = CONCAT('SGN-', NEW.APCode);
	SET route_name2 = CONCAT(NEW.APCode, '-SGN');

    
    -- Insert the route into the Route table
    IF NEW.APCode != 'SGN' THEN
		INSERT INTO Route (SourceAP, DestAP, RName, Distance, APCode) VALUES ('SGN', NEW.APCode, route_name, route_distance, NEW.APCode);
		INSERT INTO Route (SourceAP, DestAP, RName, Distance, APCode) VALUES (NEW.APCode, 'SGN', route_name2, route_distance, NEW.APCode);
	END IF;
END;
//

DELIMITER ;

DELIMITER //
CREATE TRIGGER update_seat_status_after_ticket_insert
AFTER INSERT ON Ticket
FOR EACH ROW
BEGIN
    IF NEW.CheckInStatus = 'Yes' THEN
        UPDATE Seat
        SET Status = 'Unavailable'
        WHERE FlightID = NEW.FlightID AND SeatNum = NEW.SeatNum;
    END IF;
END;
//
DELIMITER ;

-- This view is for ploting the graph
CREATE VIEW employee_distribution_by_type AS
SELECT 
    (SELECT COUNT(*) FROM Pilot) AS PilotCount,
    (SELECT COUNT(*) FROM Flight_Attendant) AS FlightAttendantCount,
    (SELECT COUNT(*) FROM Engineer) AS EngineerCount,
    (SELECT COUNT(*) FROM Traffic_Controller) AS TrafficControllerCount,
    (SELECT COUNT(*) FROM Administrative_Support) AS AdministrativeSupportCount,
    (SELECT COUNT(*) FROM Employee) AS TotalCount;
    
-- This view is for ploting the graph of top 10 airplane
CREATE VIEW top_ten_airplane AS
	SELECT AirplaneID, COUNT(*) as NumberOfFlights
	FROM Flight
	GROUP BY AirplaneID
	ORDER BY NumberOfFlights DESC
	LIMIT 10;

-- This view is for ploting the graph of top 10 passenger
CREATE VIEW top_ten_passenger AS
	SELECT p.PID, CONCAT(p.Fname, ' ', p.Lname) as PassengerName, SUM(s.Price) as TotalSpent
	FROM Passenger p
	JOIN Ticket t ON p.PID = t.PID
	JOIN Seat s ON t.SeatNum = s.SeatNum AND t.FlightID = s.FlightID
	GROUP BY p.PID
	ORDER BY TotalSpent DESC
	LIMIT 10;

-- This procedure is for getting number of experts of a consultant
DELIMITER //
CREATE PROCEDURE total_expert (IN CID INT)
BEGIN
	SELECT count(*) as total FROM Expert_At where ConsultID = CID;
END;
//
DELIMITER ;

-- This procedure is for getting number of flights of a route
DELIMITER //
CREATE PROCEDURE total_flight (IN id INT)
BEGIN
	SELECT count(*) as total FROM Flight where RID = id;
END;
//
DELIMITER ;

-- --------------------------------------------------------------------
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (110,'UJ','AlMasria Universal Airlines','Egypt');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (120,'JS','Air Koryo','Democratic People''s Republic of Korea');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (140,'LI','LIAT Airlines','Antigua and Barbuda');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (186,'SW','Air Namibia','Namibia');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (199,'TU','Tunisair','Tunisia');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (269,'EQ','TAME','Ecuador');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (4,'BV','Blue Panorama','Italy');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (40,'QC','Camair-Co','Cameroon');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (403,'PO','Polar Air Cargo','United States');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (45,'LA','LATAM Airlines Group','Chile');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (577,'AD','Azul Brazilian Airlines','Brazil');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (655,'DV','SCAT Airlines','Kazakhstan');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (703,'NO','Neos','Italy');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (722,'TW','T''way Air','Korea');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (770,'EO','Pegas Fly','Russian Federation');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (80,'LO','LOT Polish Airlines','Poland');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (82,'SN','Brussels Airlines','Belgium');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (847,'PN','West Air','China');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (86,'NZ','Air New Zealand','New Zealand');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (881,'DE','Condor','Germany');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (910,'WY','Oman Air','Oman');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (957,'JJ','LATAM Airlines Brasil','Brazil');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (978,'VJ','Vietjet','Vietnam');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (988,'OZ','Asiana Airlines','Korea');
INSERT INTO airline(AirlineID,IATADesignator,Name,Country) VALUES (997,'BG','Biman Bangladesh Airlines','Bangladesh');

INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('KVD','Ganja International Airport','Ganca',40.737701,46.3176);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('NGB','Ningbo Lishe International Airport','Zhejiang',29.8267,121.4629);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('SYQ','Tobias Bolanos International Airport','San Jose',9.95694,-84.13972);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('NJF','Al Najaf International Airport','An Najaf',31.9883,44.4025);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('BGW','Baghdad International Airport','Baghdad',33.2575,44.234);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('ROB','Roberts International Airport','Margibi',-7.4167,157.5833);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('KTM','Tribhuvan International Airport','Bagmati',27.700769,85.30014);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('AQP','Rodriguez Ballon International Airport','Arequipa',-16.3403,-71.5728);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('ROR','Roman Tmetuchl International Airport','Airai',7.3674,134.5388);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('ARW','Arad International Airport','Arad',46.1763,21.2637);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('CNX','Chiang Mai International Airport','Chiang Mai',18.7667,98.9575);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('VAV','Vava''u International Airport','Vava''u',-18.5845,-173.957);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('UGC','Urgench International Airport','Xorazm',41.5842,60.6417);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('SGN','Tan Son Nhat International Airport','Ho Chi Minh City',10.8158,106.6641);
INSERT INTO airport(APCode,APName,City,Latitude,Longitude) VALUES ('ADE','Aden International Airport','Adan',12.8244,45.0239);

INSERT INTO owner(OwnerID,Phone) VALUES (1,9188071513);
INSERT INTO owner(OwnerID,Phone) VALUES (2,5636770957);
INSERT INTO owner(OwnerID,Phone) VALUES (3,4851163704);
INSERT INTO owner(OwnerID,Phone) VALUES (4,5509795409);
INSERT INTO owner(OwnerID,Phone) VALUES (5,7503188554);
INSERT INTO owner(OwnerID,Phone) VALUES (6,1210852428);
INSERT INTO owner(OwnerID,Phone) VALUES (7,5479375887);
INSERT INTO owner(OwnerID,Phone) VALUES (8,5028884732);
INSERT INTO owner(OwnerID,Phone) VALUES (9,7944405231);
INSERT INTO owner(OwnerID,Phone) VALUES (10,9637532872);
INSERT INTO owner(OwnerID,Phone) VALUES (11,6088508918);
INSERT INTO owner(OwnerID,Phone) VALUES (12,1301057960);
INSERT INTO owner(OwnerID,Phone) VALUES (13,5257033439);
INSERT INTO owner(OwnerID,Phone) VALUES (14,9931540862);
INSERT INTO owner(OwnerID,Phone) VALUES (15,5611727503);
INSERT INTO owner(OwnerID,Phone) VALUES (16,5608925727);
INSERT INTO owner(OwnerID,Phone) VALUES (17,2204761112);
INSERT INTO owner(OwnerID,Phone) VALUES (18,8989503697);
INSERT INTO owner(OwnerID,Phone) VALUES (19,6067471103);
INSERT INTO owner(OwnerID,Phone) VALUES (20,7876419347);

INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('G & D AVIATION AND MARINE LLC','4900 US HIGHWAY 1 N STE 300',1);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('MORRISON JEFFREY B','1611 JEROME PL',2);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('GENSLER WILLIAM','3239 N GREEN BAY RD',3);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('SHIER AVIATION CORP DBA','3753 JOHN J MONTGOMERY DR STE 2',4);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('LIFESKILLS INC','PO BOX 578',5);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('LAYSON AVIATION LLC','605 PARKVIEW AVE',6);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('TURNER AIRCRAFT WEST','PO BOX 5407',7);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('AIR TRANSPORT INC','8365 SE DOUBLE TREE DR',8);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('TVPX SALES LLC','2352 MAIN ST STE 201',9);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('TORRANCE AIRCRAFT MAINTENANCE LLC','3425 AIRPORT DR HANGAR E',10);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('BT CAROLINA AVIATION CORP','433 TREASURE WAY',11);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('GOLD SEAL AVIATION INC','215 E MARKET ST',12);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('R & C AVIATION INC','293 POLK ROAD 52',13);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('GLOBAL JET AVIATION LLC','6310 LEMMON AVE STE 222',14);
INSERT INTO cooperation(Name,Address,OwnerID) VALUES ('BRETZ INC','4800 GRANT CREEK RD',15);

INSERT INTO person(SSN,Name,Address,OwnerID) VALUES (1097117278,'Bernard Arnold','Philadelphia',16);
INSERT INTO person(SSN,Name,Address,OwnerID) VALUES (1102477589,'Elon Mush','Los Angeles',17);
INSERT INTO person(SSN,Name,Address,OwnerID) VALUES (1139904999,'Jim Walton','Seattle',18);
INSERT INTO person(SSN,Name,Address,OwnerID) VALUES (1826840260,'Wrens Buffet','Palo Alto',19);
INSERT INTO person(SSN,Name,Address,OwnerID) VALUES (2257396706,'Steve Balls','Phoenix',20);

INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (1,'DC8-55',50,933);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (2,'DC8-62',45,965);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (3,'747-100',49,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (4,'747-200',47,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (5,'DC10-30',59,934);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (6,'DC10-40',47,934);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (7,'747-300',58,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (8,'747-400',50,977);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (9,'MD-11',59,934);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (10,'A330-300',53,913);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (11,'A340-300',55,913);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (12,'777-200ER',58,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (13,'A330-200',49,913);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (14,'A340-600',49,913);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (15,'A340-500',51,913);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (16,'777-300ER',46,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (17,'A380-800',52,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (18,'747-8',51,988);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (19,'A350-900',52,945);
INSERT INTO model(ID,MName,Capacity,MaxSpeed) VALUES (20,'A350-1000',49,945);


INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (1,'PZ-8AT',847,20,'1999-03-06',3);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (2,'JW-XJD',82,10,'2010-07-30',14);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (3,'FR-17A',269,16,'2001-02-22',8);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (4,'UY-6M7',45,5,'1996-09-15',6);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (5,'JE-G55',40,4,'1993-05-17',4);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (6,'OQ-YRJ',140,19,'2022-02-13',10);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (7,'AE-AJ1',997,1,'2017-06-30',16);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (8,'PW-96Z',881,18,'1994-07-31',16);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (9,'UW-XN3',269,17,'1999-06-29',20);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (10,'VW-AW2',957,12,'2023-12-09',10);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (11,'AB-1JD',110,2,'2023-08-31',6);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (12,'YM-6YU',403,15,'2001-12-05',19);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (13,'VP-LSW',80,11,'1997-02-01',4);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (14,'LR-U7N',910,15,'2007-09-18',9);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (15,'WE-VGP',4,3,'2004-03-21',4);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (16,'YZ-MPZ',988,17,'1996-05-18',15);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (17,'MH-EZ2',82,6,'1994-05-28',20);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (18,'GA-PRP',847,9,'1999-02-21',17);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (19,'QW-970',40,3,'2006-06-12',7);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (20,'PV-1DB',770,11,'2004-09-25',15);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (21,'ZH-78W',186,19,'1994-10-26',5);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (22,'CH-108',978,14,'1990-07-23',14);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (23,'WG-CSJ',577,8,'2004-08-13',15);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (24,'NP-6ZB',82,9,'2008-09-22',15);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (25,'YM-J9T',655,13,'1999-05-17',16);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (26,'IL-76E',120,16,'2014-04-03',19);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (27,'SQ-MY5',86,10,'2003-12-04',8);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (28,'GD-9G7',703,7,'2002-06-14',5);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (29,'UC-DR5',199,20,'2014-10-09',7);
INSERT INTO airplane(AirplaneID,License_plate_num,AirlineID,OwnerID,LeasedDate,ModelID) VALUES (30,'IA-IX0',722,14,'1995-05-02',20);

INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (1,163504525056,'F','2004-04-16','Chile','Jeremy','Z.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (2,666089552442,'F','2007-05-26','New Caledonia','Ruby','S.','Alan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (3,817491210983,'F','2003-03-14','Malaysia','Harold','C.','Joe',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (4,116966269423,'F','1995-11-18','Australia','Mary','K.','Melissa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (5,324652366165,'F','1959-04-01','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (6,685685132362,'F','1967-06-30','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (7,736666864186,'F','1969-12-24','Italy','Amanda','Y.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (8,668584675116,'F','1984-09-16','Indonesia','Sharon','O.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (9,837436127403,'M','2013-07-07','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (10,914874626586,'M','1955-07-25','Luxembourg','Linda','E.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (11,884312598473,'F','1980-06-12','Italy','Paul','W.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (12,360414515455,'F','1979-09-06','Tanzania','Lillian','D.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (13,637687295671,'F','2002-08-17','Egypt','Paul','Z.','Judy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (14,987397261814,'M','2020-09-13','Korea','William','W.','Wayne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (15,592808822059,'F','1985-11-16','Mauritius','Tammy','P.','Ralph',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (16,594060113424,'F','1989-05-28','Kuwait','Phillip','Q.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (17,131448503508,'M','1965-11-17','Germany','Nancy','W.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (18,387037013129,'M','1971-09-19','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (19,851933846856,'F','2010-06-26','Japan','Nancy','U.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (20,668384788587,'F','2009-06-27','United States','Frances','H.','Phillip',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (21,478047188197,'F','2011-06-05','Bahamas','Judy','Q.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (22,290330949429,'F','1984-05-09','Argentina','Wayne','O.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (23,813285495628,'M','2020-12-29','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (24,278216914289,'M','1950-10-04','Colombia','Frances','I.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (25,320493127399,'F','1993-06-05','United Kingdom','Clarence','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (26,575717817169,'F','1962-12-07','Mexico','Melissa','R.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (27,662000707379,'M','1978-02-15','Spain','Brenda','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (28,207254415061,'M','1952-01-09','Tanzania','Ralph','M.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (29,427715990985,'F','1986-05-03','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (30,770338399743,'M','1969-05-11','Serbia','Larry','K.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (31,893323307427,'M','1996-11-18','Morocco','Cynthia','S.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (32,757779170628,'M','2016-01-24','Lebanon','Lillian','A.','Douglas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (33,913262481886,'F','1986-08-19','Colombia','Frances','I.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (34,276080261779,'F','1978-02-06','Syrian Arab Republic','Anne','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (35,842851936568,'M','2001-08-22','Spain','Brenda','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (36,262835550881,'F','1965-02-22','United States','Frances','H.','Phillip',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (37,908513399438,'M','1984-12-22','Korea','William','W.','Wayne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (38,967307505979,'M','1973-10-03','United States','Cheryl','P.','Melissa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (39,273883637251,'M','1982-12-08','Kuwait','Phillip','Q.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (40,639713592234,'M','1957-10-29','Egypt','Ernest','T.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (41,219704207301,'F','1973-02-02','India','Rebecca','D.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (42,870301977764,'F','1995-01-16','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (43,260759138565,'F','1980-08-28','Italy','Brenda','K.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (44,636519995117,'F','1982-11-27','Netherlands','Maria','N.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (45,827663967971,'F','1969-04-28','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (46,590622752507,'F','1993-11-10','Costa Rica','Antonio','B.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (47,452574351421,'M','2018-12-03','Serbia','Larry','K.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (48,673657223491,'M','2003-06-16','Argentina','Wayne','O.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (49,787058468136,'F','2009-06-03','Australia','Mary','K.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (50,228869778910,'M','1963-08-15','India','Rebecca','D.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (51,715066137281,'M','1988-01-07','Tanzania','Ralph','M.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (52,299965748338,'M','1981-10-21','Spain','Diana','C.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (53,340404414391,'F','1951-09-20','United States','Cheryl','P.','Melissa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (54,144312571933,'M','1997-10-15','Belgium','Aaron','L.','Nicole',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (55,392974396410,'M','2018-04-03','Colombia','Frances','I.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (56,690092934541,'M','1989-05-15','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (57,139199058274,'M','2007-08-16','Germany','Janice','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (58,700988550733,'M','1966-01-22','Mozambique','Carolyn','W.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (59,537584851209,'M','2004-07-06','United States','Lois','L.','Brenda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (60,344104718373,'M','1963-05-30','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (61,793778852683,'M','1965-05-09','Australia','Mary','K.','Melissa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (62,276208899290,'F','2016-06-23','Thailand','Eugene','B.','Steven',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (63,409599078104,'F','1984-12-21','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (64,782194837237,'F','1960-11-12','Morocco','Cynthia','S.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (65,126154386949,'F','2002-03-25','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (66,183343856104,'M','1993-09-05','Egypt','Amy','G.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (67,104145151450,'F','1977-03-01','Cyprus','Gregory','X.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (68,750705930946,'F','1973-05-18','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (69,504354491479,'F','1961-06-02','Democratic People''s Republic of Korea','Peter','M.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (70,137572684548,'F','1971-02-14','Thailand','Eugene','B.','Steven',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (71,365328174532,'M','1968-09-29','Czech Republic','Joan','U.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (72,613852924871,'F','1969-01-21','Saudi Arabia','Ruby','P.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (73,155036556692,'M','2005-03-22','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (74,203845287357,'M','2003-07-26','Bahamas','Judy','Q.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (75,685662583091,'M','1977-02-11','Panama','Jose','P.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (76,783463270763,'M','1957-10-03','Netherlands','Maria','N.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (77,454924916227,'F','1952-04-05','Cyprus','Gregory','X.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (78,558965449689,'M','2010-03-06','United States','Cheryl','P.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (79,315709693891,'F','2009-03-10','Finland','Alan','R.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (80,283608688156,'M','1976-11-18','Pakistan','Janet','W.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (81,539459878308,'F','1998-12-26','Argentina','Wayne','O.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (82,973442328570,'M','1976-08-16','Russian Federation','Ryan','K.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (83,615326128987,'M','2008-04-22','Mozambique','Carolyn','W.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (84,806561979870,'F','2016-04-25','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (85,633998084147,'M','1956-11-06','China','Patrick','R.','Deborah',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (86,108303993371,'M','2012-09-14','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (87,942523319575,'M','1968-10-02','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (88,769428173274,'F','1997-06-29','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (89,128766472273,'M','1997-03-13','Iran','Joyce','H.','Jack',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (90,905248498359,'M','1975-12-27','Greece','Joshua','R.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (91,236595618485,'F','1964-11-13','Russian Federation','Ryan','K.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (92,839758404638,'F','1953-08-19','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (93,373214697254,'M','1983-09-11','Israel','Theresa','K.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (94,471339057844,'F','1991-03-18','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (95,314003926694,'M','1996-05-13','Syrian Arab Republic','Anne','K.','Jeremy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (96,945758475977,'M','1985-03-29','Korea','William','W.','Wayne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (97,589305643028,'F','1956-11-21','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (98,473898729118,'M','1952-06-17','Angola','Judy','S.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (99,122286953298,'F','2001-03-06','Italy','Julia','N.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (100,991159359060,'M','2019-07-27','Tanzania','Lillian','D.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (101,169743439487,'F','2012-09-08','El Salvador','Jimmy','U.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (102,209605202367,'F','2015-08-30','Germany','Jack','O.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (103,420522435117,'M','1978-04-04','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (104,171463613735,'M','1956-12-21','Kuwait','Phillip','Q.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (105,236496981834,'M','2012-08-14','Finland','Alan','R.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (106,750345650209,'F','1951-04-21','Indonesia','Sharon','O.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (107,255143427071,'F','1966-04-07','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (108,507502273172,'M','2011-02-21','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (109,363954585389,'M','2021-04-11','Ireland','Theresa','K.','Christopher',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (110,197554023513,'M','1957-12-10','Solomon Islands','Dorothy','K.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (111,796608200097,'F','1995-07-30','Pakistan','Janet','W.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (112,148986260275,'M','1970-05-30','El Salvador','Jimmy','U.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (113,234111218534,'F','1995-09-03','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (114,609663920272,'F','1977-12-03','Germany','Janice','P.','William',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (115,929297416987,'F','1961-01-19','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (116,962232823166,'F','1958-12-12','Tanzania','Ralph','M.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (117,380551907467,'F','2003-02-25','Sweden','Ann','D.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (118,915763974077,'F','1977-06-22','United States','Carol','K.','Tammy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (119,665959924863,'F','1971-02-23','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (120,585260732041,'F','1959-06-16','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (121,845933225071,'M','2012-02-20','El Salvador','Jimmy','U.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (122,193621225492,'F','2015-10-19','United States','Lois','L.','Brenda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (123,549493194393,'M','1997-08-28','Vanuatu','Deborah','X.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (124,848211614744,'M','1957-09-16','Germany','Janice','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (125,377438306300,'F','2022-09-03','Vanuatu','Deborah','X.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (126,675857733540,'F','1959-01-10','Hong Kong SAR, China','Margaret','T.','Jack',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (127,935275147754,'M','1957-07-03','Mexico','Melissa','R.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (128,451972572710,'F','2011-06-02','Vanuatu','Deborah','X.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (129,218472617215,'M','1988-07-20','Korea','William','W.','Wayne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (130,262060927169,'F','1964-05-10','Germany','Janice','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (131,559459169240,'F','1963-05-18','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (132,860796141501,'M','2013-10-04','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (133,841381966993,'F','1987-07-31','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (134,612217407801,'M','2011-05-02','Argentina','Wayne','O.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (135,343520147064,'M','2010-10-24','India','Rebecca','D.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (136,816778502275,'M','1973-05-17','United States','Benjamin','X.','Pamela',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (137,322512724038,'F','2013-02-06','Mauritius','Tammy','P.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (138,210348479895,'F','1974-04-24','Ireland','Theresa','K.','Christopher',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (139,336604061702,'M','1982-10-14','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (140,183589116984,'F','1995-04-02','Saudi Arabia','Ruby','P.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (141,578411460637,'M','1979-05-06','South Africa','Donna','S.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (142,660970620219,'F','2021-04-10','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (143,482237760882,'F','1999-02-25','India','Mary','V.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (144,482460522590,'F','2010-02-11','Indonesia','Sharon','O.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (145,531411109268,'F','2020-12-30','United Arab Emirates','Christopher','Q.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (146,592585793126,'M','1968-08-25','Netherlands','Maria','N.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (147,620208420549,'F','1975-11-27','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (148,224383950616,'M','1995-05-06','Namibia','Carolyn','Y.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (149,684221641023,'M','2012-03-29','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (150,916894624296,'M','1989-11-05','Suriname','Ernest','S.','Carolyn',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (151,403018276814,'F','1952-04-14','Argentina','Wayne','O.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (152,677400927009,'M','1967-08-28','Canada','Diane','U.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (153,157635068105,'F','1989-08-29','Finland','Alan','R.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (154,950846558382,'F','1992-05-22','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (155,594217190122,'M','2005-09-23','Luxembourg','Jason','W.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (156,405575993364,'M','1962-05-14','Israel','Pamela','I.','Paula',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (157,599928838956,'F','1969-06-06','Lebanon','Lillian','A.','Douglas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (158,677056954275,'M','2006-04-14','Malaysia','Harold','C.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (159,476167670181,'M','1973-07-06','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (160,754392637751,'M','1988-08-16','Ethiopia','Daniel','V.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (161,725733576782,'M','1968-02-06','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (162,377654937971,'F','2012-08-19','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (163,188224614045,'M','1982-02-26','South Africa','Douglas','O.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (164,307177641904,'F','2022-07-24','United Arab Emirates','Christopher','Q.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (165,101047007802,'F','2020-02-12','Germany','Jack','O.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (166,569260475699,'F','1982-10-21','Netherlands','Maria','N.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (167,351724150068,'M','1998-02-20','Seychelles','Carol','X.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (168,658747094002,'M','1985-05-10','Portugal','Paula','X.','Eugene',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (169,756342773819,'F','2010-06-11','Ethiopia','Daniel','V.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (170,117925278058,'M','1982-01-24','New Caledonia','Ruby','S.','Alan',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (171,649418133794,'M','1996-06-19','Angola','Judy','S.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (172,352356783932,'M','2006-04-17','Trinidad and Tobago','Elizabeth','X.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (173,813930002039,'F','1962-01-02','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (174,594984231050,'M','1967-03-28','Pakistan','Janet','W.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (175,978110044947,'M','1956-03-02','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (176,992558743401,'F','1992-10-27','Iceland','Nancy','M.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (177,178728174247,'F','1950-05-19','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (178,481530560735,'F','1967-11-26','Chile','Jeremy','Z.','Ernest',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (179,739154624666,'M','2009-07-18','Serbia','Larry','K.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (180,731641494107,'M','1996-07-28','South Africa','Douglas','O.','Joe',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (181,384492008495,'M','1998-08-10','United Arab Emirates','Martha','B.','Cheryl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (182,573654165753,'M','1962-07-18','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (183,699644718029,'M','1968-05-19','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (184,607766468168,'F','1980-07-05','Bahrain','Roger','J.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (185,728804733279,'F','1959-07-04','Ireland','Theresa','K.','Christopher',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (186,813557665010,'F','2014-05-18','Israel','Pamela','I.','Paula',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (187,571061861286,'M','1972-03-22','Syrian Arab Republic','Anne','K.','Jeremy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (188,862858382854,'M','1964-05-31','Italy','Brenda','K.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (189,350823794725,'F','2008-11-26','Democratic People''s Republic of Korea','Peter','M.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (190,561364716806,'M','2001-10-28','Germany','Jack','O.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (191,720122396918,'F','2022-09-29','Netherlands','Maria','N.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (192,185484451546,'F','1955-05-11','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (193,900809543874,'F','1985-06-29','El Salvador','Jimmy','U.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (194,409489827163,'F','2007-04-15','Trinidad and Tobago','Elizabeth','X.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (195,821095111384,'M','1965-03-27','Argentina','Andrea','M.','Rebecca',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (196,930988282935,'M','1952-02-11','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (197,521372279457,'F','1981-06-13','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (198,375115555417,'M','1975-03-15','Trinidad and Tobago','Elizabeth','X.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (199,725404838150,'M','2006-02-05','Philippines','Roy','A.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (200,981516405274,'M','1986-04-14','Mexico','Melissa','R.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (201,831324850629,'M','1968-04-15','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (202,794705496076,'M','1996-07-04','Russian Federation','Ryan','K.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (203,164555352405,'F','2002-03-29','Pakistan','Janet','W.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (204,271265029300,'F','1997-11-16','Germany','Janice','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (205,364720158863,'F','1982-03-23','Germany','Nancy','W.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (206,802381512886,'M','2022-08-20','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (207,598920596684,'F','1990-06-29','Lebanon','Lillian','A.','Douglas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (208,119939070804,'F','2019-11-12','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (209,410303568810,'M','1970-06-18','Egypt','Paul','Z.','Judy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (210,954892712960,'M','2010-12-16','Cameroon','Jack','J.','Ryan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (211,887515917945,'F','2004-06-04','Costa Rica','Antonio','B.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (212,291557850867,'M','1980-01-02','India','Rebecca','D.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (213,304706979625,'F','1992-03-01','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (214,711878917987,'M','1963-04-20','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (215,475906043727,'F','2006-04-05','Angola','Judy','S.','Amanda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (216,535630774376,'M','2011-11-11','Malaysia','Harold','C.','Joe',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (217,430832818181,'F','1993-05-12','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (218,301403011702,'F','1955-02-18','Tanzania','Ralph','M.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (219,371548771747,'M','1968-03-03','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (220,777333982081,'F','1989-11-18','Italy','Paul','W.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (221,270096379846,'M','1986-11-13','Korea','William','W.','Wayne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (222,958121913250,'F','2022-11-06','India','Rebecca','D.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (223,438611438257,'F','1974-06-01','Democratic People''s Republic of Korea','Peter','M.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (224,112298848228,'M','1983-12-14','India','Rebecca','D.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (225,337694169295,'M','1979-12-05','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (226,540326837671,'M','1999-12-27','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (227,490986212506,'F','2010-07-19','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (228,499961811065,'F','1990-03-21','United States','Frances','H.','Phillip',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (229,332441319981,'M','1970-06-19','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (230,289772517648,'F','1992-02-27','Germany','Jack','O.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (231,793891140731,'F','2004-12-10','Angola','Judy','S.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (232,390619515072,'M','1957-05-19','Israel','Pamela','I.','Paula',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (233,303870121401,'M','1978-08-06','New Zealand','Carl','P.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (234,872655265307,'F','1963-02-08','Namibia','Carolyn','Y.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (235,670026177841,'F','1957-10-29','Hong Kong SAR, China','Ann','O.','Mary',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (236,757627249349,'M','1990-07-06','Colombia','Frances','I.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (237,602249502641,'M','1995-12-16','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (238,445713809906,'F','1963-08-19','Israel','Pamela','I.','Paula',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (239,978926918951,'M','1970-04-13','Poland','Richard','X.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (240,748660783507,'M','1969-10-24','Colombia','Frances','I.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (241,239177571978,'M','2021-01-10','Syrian Arab Republic','Anne','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (242,685108016400,'M','1967-10-13','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (243,332927384201,'F','1982-10-16','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (244,247932801211,'F','1954-04-18','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (245,852784256415,'M','1972-07-19','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (246,635734277588,'M','2006-11-22','Germany','Jack','O.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (247,631747086428,'M','2014-09-23','New Caledonia','Ruby','S.','Alan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (248,823279104251,'M','1951-03-12','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (249,770978989839,'M','2000-03-14','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (250,580117444790,'M','1977-04-20','Cameroon','Jack','J.','Ryan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (251,259701135859,'F','1993-04-07','Spain','Diana','C.','Peter',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (252,247241401818,'M','1981-12-09','China','Nancy','F.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (253,948295961881,'F','1957-10-29','Mozambique','Carolyn','W.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (254,591852311618,'M','1975-08-19','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (255,193783210567,'F','1965-04-26','India','Mary','V.','Ernest',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (256,295938798917,'F','1978-08-06','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (257,855201683690,'F','1989-07-03','Egypt','Amy','G.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (258,121461278806,'F','1952-03-27','Solomon Islands','Dorothy','K.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (259,773354086062,'F','1982-04-23','Cyprus','Gregory','X.','Amanda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (260,272823854314,'M','1957-11-12','United Arab Emirates','Christopher','Q.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (261,349651651181,'M','1972-04-25','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (262,785351636799,'M','1960-05-20','New Caledonia','Matthew','L.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (263,442390501751,'F','1981-08-24','China','Patrick','R.','Deborah',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (264,960772211472,'M','2002-02-19','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (265,975255711071,'F','1978-04-03','Japan','Nancy','U.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (266,785855965990,'F','2012-08-01','South Africa','Donna','S.','Carl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (267,209869104337,'M','2014-03-11','Indonesia','Sharon','O.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (268,343996257563,'M','1984-05-05','United States','Joe','V.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (269,354214214098,'F','1993-04-15','United States','Carol','K.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (270,573708685242,'F','1952-10-30','Australia','Mary','K.','Melissa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (271,276287734876,'M','1993-05-30','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (272,323800901017,'F','1999-10-19','Colombia','Frances','I.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (273,976726365228,'M','1961-06-23','Costa Rica','Antonio','B.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (274,584003390910,'M','1971-02-18','France','Steven','B.','Carol',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (275,238384278983,'F','1994-10-14','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (276,551244246559,'M','2007-10-07','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (277,365935135245,'M','2010-10-03','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (278,592289132015,'M','2009-07-31','Mauritius','Tammy','P.','Ralph',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (279,371091058983,'M','1977-03-21','Trinidad and Tobago','Elizabeth','X.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (280,952160786878,'M','2000-06-17','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (281,190741289087,'F','2012-06-06','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (282,385263074391,'F','1957-02-13','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (283,485628518238,'F','1980-06-23','Cuba','Henry','B.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (284,517900643017,'M','2003-09-24','China','Nancy','F.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (285,552100625578,'F','1950-03-02','New Zealand','Carl','P.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (286,224933765606,'M','2008-09-22','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (287,686712023145,'M','2011-10-19','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (288,698205020148,'M','1958-03-31','United Arab Emirates','Christopher','Q.','Aaron',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (289,890928290637,'F','1962-06-16','Seychelles','Carol','X.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (290,182034197839,'M','1994-11-05','Suriname','Ernest','S.','Carolyn',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (291,403131691813,'M','1960-06-29','France','Thomas','P.','Jose',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (292,366307266429,'F','2015-01-21','Korea','William','W.','Wayne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (293,840046971120,'M','2022-01-17','United Arab Emirates','Martha','B.','Cheryl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (294,597337293843,'M','2020-03-29','Solomon Islands','Dorothy','K.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (295,610705538230,'F','1972-03-24','United States','Frances','H.','Phillip',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (296,624873193528,'F','2000-10-18','Bahrain','Roger','J.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (297,696371272870,'F','2010-02-03','Trinidad and Tobago','Elizabeth','X.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (298,829174981545,'F','2016-09-30','Syrian Arab Republic','Anne','K.','Jeremy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (299,786978864398,'F','1961-09-11','India','Rebecca','D.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (300,890168022590,'M','1959-12-27','Tunisia','Kelly','U.','Phillip',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (301,380630284354,'M','1965-11-07','China','Patrick','R.','Deborah',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (302,526722863102,'M','1978-08-13','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (303,617838855381,'F','2001-12-31','Ethiopia','Daniel','V.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (304,843579994627,'M','1993-08-29','China','Nancy','F.','Carl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (305,235798639455,'F','1988-06-02','Pakistan','Janet','W.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (306,599928745897,'F','1962-09-18','France','Steven','B.','Carol',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (307,783658903574,'M','1993-02-26','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (308,612479295521,'F','1980-08-26','United States','Joe','V.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (309,827747144020,'M','2017-01-26','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (310,222865762112,'M','2021-05-08','Malaysia','Harold','C.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (311,956952162719,'F','1975-04-27','Cuba','Henry','B.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (312,749013255405,'M','1985-08-13','Democratic People''s Republic of Korea','Peter','M.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (313,814488703560,'M','1999-06-22','Pakistan','Janet','W.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (314,167718366622,'F','2012-06-10','Namibia','Carolyn','Y.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (315,324884051578,'M','1974-05-04','Hong Kong SAR, China','Ann','O.','Mary',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (316,826671123598,'M','1979-05-10','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (317,875637754977,'F','1973-07-24','Serbia','Larry','K.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (318,230711764288,'M','1964-06-24','Serbia','Larry','K.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (319,833579805730,'M','1985-11-22','Hong Kong SAR, China','Ann','O.','Mary',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (320,897903489042,'M','1985-08-10','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (321,958007759630,'M','1998-02-09','Italy','Amanda','Y.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (322,555183534611,'M','1984-06-15','Philippines','Roy','A.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (323,994959557955,'M','1953-03-20','United Arab Emirates','Martha','B.','Cheryl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (324,686630136290,'M','2006-06-11','Canada','Diane','U.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (325,814166154782,'F','1956-11-25','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (326,477963783391,'F','2021-02-26','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (327,298514972390,'M','2010-10-05','Iran','Joyce','H.','Jack',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (328,452130914698,'M','2020-11-21','Democratic People''s Republic of Korea','Peter','M.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (329,608207165678,'M','1952-09-18','Seychelles','Carol','X.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (330,785067544929,'M','1950-09-02','New Caledonia','Ruby','S.','Alan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (331,122731896596,'F','1955-10-24','Cameroon','Jack','J.','Ryan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (332,203516749201,'F','1960-07-09','United States','Cheryl','P.','Melissa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (333,382415079979,'F','1952-08-19','Israel','Pamela','I.','Paula',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (334,566127942385,'F','1977-11-14','Serbia','Larry','K.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (335,378559803985,'F','1958-05-29','Italy','Brenda','K.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (336,162527596764,'M','2014-01-25','Egypt','Amy','G.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (337,899489942944,'F','2012-02-22','Bahrain','Roger','J.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (338,219124388442,'M','1981-11-09','Cuba','Henry','B.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (339,880253198972,'F','1997-10-11','Angola','Judy','S.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (340,666137912135,'M','1976-01-22','Hong Kong SAR, China','Margaret','T.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (341,683931543189,'F','1954-05-23','United States','Joe','V.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (342,327822446420,'F','1959-10-31','Solomon Islands','Dorothy','K.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (343,729638797251,'M','1975-03-30','Solomon Islands','Dorothy','K.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (344,518331643711,'M','1990-11-18','Finland','Alan','R.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (345,427906530946,'M','1975-11-28','India','Rebecca','D.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (346,335888566715,'F','1988-04-11','Belgium','Aaron','L.','Nicole',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (347,829241718090,'M','1962-09-08','Antigua and Barbuda','Todd','N.','Henry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (348,618205848374,'M','2017-11-19','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (349,369030641632,'M','1979-07-12','Canada','Diane','U.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (350,772202848079,'M','1959-08-11','Italy','Amanda','Y.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (351,175322043029,'M','1973-07-10','Mozambique','Carolyn','W.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (352,775341526771,'M','1976-03-01','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (353,141420810726,'M','2008-11-09','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (354,671748732448,'M','2012-01-17','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (355,819298690620,'F','1999-04-24','Iceland','Nancy','M.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (356,617751184698,'M','1964-02-17','Italy','Amanda','Y.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (357,318382645276,'F','1968-02-10','Qatar','Cynthia','K.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (358,333248604382,'F','2012-09-15','Germany','Jack','O.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (359,155960229815,'M','1984-08-26','Poland','Richard','X.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (360,613438342314,'M','2022-06-27','Mauritius','Tammy','P.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (361,160887789217,'F','1971-10-01','Germany','Jack','O.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (362,147538940309,'M','1987-01-17','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (363,726640568148,'F','1977-10-26','Netherlands','Anne','P.','Theresa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (364,303966996921,'M','2016-12-30','Indonesia','Sharon','O.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (365,555170230761,'F','1954-02-07','Chile','Cheryl','Q.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (366,162700365317,'M','1993-10-14','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (367,935904565402,'M','1995-11-05','Colombia','Frances','I.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (368,999819319868,'M','1990-02-17','United States','Frances','H.','Phillip',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (369,221881751055,'F','1975-08-01','Hong Kong SAR, China','Ann','O.','Mary',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (370,506554556618,'M','1980-10-18','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (371,321833918311,'F','2018-02-17','China','Patrick','R.','Deborah',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (372,998656138905,'F','2009-06-06','New Zealand','Carl','P.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (373,960005544132,'M','1954-10-30','Bahamas','Judy','Q.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (374,607888293403,'F','1991-08-01','Germany','Janice','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (375,386029840764,'M','1967-01-07','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (376,975413402717,'F','2008-01-21','Indonesia','Sharon','O.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (377,985084541518,'F','1953-09-22','Namibia','Carolyn','Y.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (378,537889474388,'M','2011-11-04','Spain','Brenda','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (379,656885519929,'M','1952-09-13','New Zealand','Carl','P.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (380,149423030095,'F','1978-05-22','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (381,137131451110,'M','1954-04-29','Argentina','Wayne','O.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (382,645179237262,'M','2010-12-26','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (383,260185450397,'M','1951-08-08','Solomon Islands','Dorothy','K.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (384,301422112308,'M','1967-02-06','South Africa','Donna','S.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (385,731890140420,'M','1971-05-30','Pakistan','Janet','W.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (386,243260122253,'F','1951-09-24','Tunisia','Kelly','U.','Phillip',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (387,780260764688,'M','2021-12-13','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (388,460853176372,'F','1984-08-24','Indonesia','Sharon','O.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (389,243241926541,'M','1966-06-13','United States','Cheryl','P.','Melissa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (390,958733055133,'M','1955-07-01','Iceland','Nancy','M.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (391,459117807131,'M','1952-09-10','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (392,389580581444,'M','2018-12-16','Mozambique','Carolyn','W.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (393,447749221630,'M','1966-10-20','Solomon Islands','Dorothy','K.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (394,529438894557,'M','1968-05-09','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (395,602829582010,'F','1968-03-07','Hong Kong SAR, China','Margaret','T.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (396,470573877857,'M','2014-12-10','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (397,686680845153,'F','1969-04-17','Italy','Julia','N.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (398,349742175212,'M','2005-12-27','Trinidad and Tobago','Elizabeth','X.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (399,485384912466,'F','1985-07-17','Italy','Julia','N.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (400,751883273799,'M','1993-03-04','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (401,819663763239,'F','1984-12-07','Argentina','Wayne','O.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (402,667416031972,'M','1977-05-09','Italy','Brenda','K.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (403,715577018906,'M','2018-05-16','Australia','Mary','K.','Melissa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (404,473914962469,'M','2010-03-12','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (405,972449057450,'M','1974-02-03','Russian Federation','Ryan','K.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (406,272781325249,'F','1975-05-24','Bahrain','Roger','J.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (407,798113996646,'M','2012-10-08','Tanzania','Ralph','M.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (408,488540980926,'M','1986-06-14','Czech Republic','Joan','U.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (409,644924262548,'M','1954-12-25','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (410,122332033265,'M','1980-08-27','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (411,200745737696,'M','1992-08-05','French Polynesia','Debra','L.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (412,634053635552,'M','2014-03-16','Czech Republic','Joan','U.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (413,756844653465,'M','1970-10-01','Spain','Diana','C.','Peter',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (414,814553450336,'M','1979-06-10','Panama','Jose','P.','Carl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (415,645608686091,'M','1961-07-15','Indonesia','Sharon','O.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (416,661919536262,'M','1993-12-02','Mauritius','Tammy','P.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (417,901757153415,'F','2007-07-13','China','Patrick','R.','Deborah',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (418,828519060614,'M','2004-09-06','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (419,654705087174,'M','1976-07-11','Egypt','Ernest','T.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (420,546922010056,'F','1951-01-28','China','Nancy','F.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (421,647854611665,'M','2005-10-14','Cuba','Henry','B.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (422,522831696114,'M','1950-01-11','Spain','Brenda','P.','William',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (423,991419324534,'F','1980-02-18','Seychelles','Carol','X.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (424,350049725528,'F','1975-10-31','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (425,259902600152,'M','1987-08-09','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (426,520000355439,'F','1996-10-15','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (427,707947736499,'F','2014-02-06','Portugal','Paula','X.','Eugene',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (428,433962189269,'M','1999-07-20','United States','Lois','L.','Brenda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (429,699052036746,'F','1952-01-20','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (430,494760133653,'M','1954-12-13','Hong Kong SAR, China','Ann','O.','Mary',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (431,364033322445,'M','1980-01-29','Tanzania','Ralph','M.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (432,409541922070,'M','1962-01-17','Luxembourg','Linda','E.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (433,194438418145,'F','1973-05-28','Tanzania','Ralph','M.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (434,725161209466,'F','2015-04-21','United States','Lois','L.','Brenda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (435,331875493327,'F','1959-06-28','Italy','Amanda','Y.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (436,683915005138,'F','1971-08-05','Syrian Arab Republic','Anne','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (437,481956423066,'M','1986-12-13','China','Patrick','R.','Deborah',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (438,418296476897,'F','1960-07-14','Tanzania','Lillian','D.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (439,964677894156,'M','2004-08-26','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (440,636830231048,'F','1973-07-28','Iran','Joyce','H.','Jack',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (441,293635068694,'F','2007-09-03','Portugal','Paula','X.','Eugene',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (442,909130146949,'M','1967-04-23','Pakistan','Janet','W.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (443,679136285717,'M','1972-11-25','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (444,458045796442,'M','1951-11-08','Tanzania','Lillian','D.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (445,908105001070,'M','1993-08-07','Italy','Brenda','K.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (446,669260332729,'F','1998-11-09','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (447,958484189335,'M','1990-02-27','Seychelles','Carol','X.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (448,453764271646,'F','2019-08-05','Italy','Paul','W.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (449,423949364434,'M','2004-12-08','South Africa','Donna','S.','Carl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (450,507464654723,'F','2010-05-20','Namibia','Carolyn','Y.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (451,748432603703,'F','1954-12-24','Namibia','Carolyn','Y.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (452,103441713281,'F','1980-09-20','Antigua and Barbuda','Todd','N.','Henry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (453,966560068268,'M','1965-09-09','Tanzania','Ralph','M.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (454,994169773482,'M','1996-07-24','Bahamas','Judy','Q.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (455,144568051630,'F','1955-07-18','United Arab Emirates','Christopher','Q.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (456,838091054749,'M','1978-11-25','Kuwait','Phillip','Q.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (457,469360772972,'F','1985-05-27','Chile','Cheryl','Q.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (458,246883897350,'F','2015-06-22','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (459,932476037738,'F','2017-03-15','Germany','Jack','O.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (460,356998263272,'F','2010-01-24','Germany','Janice','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (461,152635253366,'M','1951-12-24','Japan','Nancy','U.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (462,873620734185,'F','1984-06-04','Cuba','Henry','B.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (463,553596449994,'M','2008-12-21','India','Rebecca','D.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (464,176944873597,'F','1972-11-21','Russian Federation','Ryan','K.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (465,130434247652,'F','1969-07-13','Chile','Jeremy','Z.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (466,259343918348,'M','2020-11-07','Saudi Arabia','Ruby','P.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (467,743851857774,'M','1997-02-15','Italy','Brenda','K.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (468,667172242815,'M','1960-06-01','United States','Benjamin','X.','Pamela',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (469,998452551926,'F','1959-10-17','China','Nancy','F.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (470,190719030048,'F','1961-04-01','Czech Republic','Joan','U.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (471,228563258340,'F','1967-01-03','Korea','William','W.','Wayne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (472,782057706187,'M','2013-10-17','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (473,937618868283,'M','1960-01-12','Australia','Mary','K.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (474,639859252939,'F','2016-09-27','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (475,461602472332,'F','2000-07-26','India','Rebecca','D.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (476,594828990428,'F','1980-03-13','Cuba','Henry','B.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (477,712548130031,'M','2016-06-07','Thailand','Eugene','B.','Steven',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (478,114957071410,'F','1955-09-14','Iceland','Nancy','M.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (479,867724507799,'F','2004-09-05','China','Patrick','R.','Deborah',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (480,222995213910,'M','1975-12-09','Finland','Alan','R.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (481,246639509551,'F','1954-04-22','Spain','Diana','C.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (482,139489809642,'M','1952-04-03','Qatar','Cynthia','K.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (483,377258653546,'M','2010-09-18','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (484,754027225381,'M','2008-04-10','Italy','Amanda','Y.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (485,780077476116,'F','1994-09-26','Indonesia','Sharon','O.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (486,762017296639,'M','1952-01-13','Vanuatu','Deborah','X.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (487,693695566290,'F','2017-12-11','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (488,204171648478,'M','1999-02-08','Italy','Paul','W.','Jose',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (489,486818088682,'M','1978-11-06','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (490,484075760974,'M','2013-02-04','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (491,952646678933,'F','1956-07-07','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (492,221497625062,'F','1998-10-23','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (493,699155197734,'F','1951-06-01','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (494,136173897421,'M','2014-10-27','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (495,793191719825,'M','1975-10-20','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (496,625401322966,'F','1952-02-02','Egypt','Paul','Z.','Judy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (497,744872289119,'F','1963-08-16','Mozambique','Carolyn','W.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (498,388035314130,'F','2023-07-05','Japan','Margaret','L.','Rebecca',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (499,166706660061,'M','1962-03-12','New Caledonia','Ruby','S.','Alan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (500,339436475161,'M','2006-10-08','Morocco','Cynthia','S.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (501,905903618402,'M','1995-01-10','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (502,259042582998,'F','1985-09-17','Thailand','Eugene','B.','Steven',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (503,685062324310,'F','1963-11-05','Vanuatu','Deborah','X.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (504,834022198702,'F','1988-12-31','Thailand','Eugene','B.','Steven',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (505,529217301572,'F','1956-11-09','Hong Kong SAR, China','Ann','O.','Mary',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (506,542756162125,'M','1973-12-24','Hong Kong SAR, China','Melissa','J.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (507,374405150228,'F','1963-04-28','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (508,439693951743,'M','1964-06-26','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (509,618138371335,'M','1966-06-13','Egypt','Ernest','T.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (510,960131010681,'M','2017-08-12','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (511,429452894264,'M','2011-07-27','United Arab Emirates','Martha','B.','Cheryl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (512,499386019384,'M','1974-05-11','Thailand','Eugene','B.','Steven',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (513,783576027158,'F','1998-12-19','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (514,950535103385,'M','1976-07-01','Argentina','Wayne','O.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (515,656931651425,'M','1981-02-27','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (516,972859986326,'F','1989-12-16','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (517,711174247908,'F','2003-04-01','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (518,395217429155,'M','1979-03-13','Portugal','Paula','X.','Eugene',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (519,611312365090,'F','2015-11-21','United Arab Emirates','Martha','B.','Cheryl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (520,717289434292,'M','2013-05-19','Hong Kong SAR, China','Melissa','J.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (521,453935353575,'F','1966-07-20','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (522,635973914819,'M','1964-10-14','Luxembourg','Linda','E.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (523,462476437755,'F','1994-09-28','Spain','Brenda','P.','William',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (524,496158202443,'F','2011-02-01','Israel','Theresa','K.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (525,300183852835,'M','1974-05-21','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (526,222632554969,'F','1950-12-27','Italy','Julia','N.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (527,892830268006,'M','2005-08-04','Vanuatu','Deborah','X.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (528,929233624312,'M','1974-11-11','France','Steven','B.','Carol',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (529,927263068423,'F','1988-03-30','New Caledonia','Matthew','L.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (530,439480063932,'F','1984-01-16','Portugal','Paula','X.','Eugene',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (531,515526026580,'M','2015-03-10','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (532,972410510761,'F','2018-01-16','India','Rebecca','D.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (533,339829592905,'M','1964-11-06','Indonesia','Sharon','O.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (534,341642978470,'M','1964-11-19','Sweden','Ann','D.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (535,153810207176,'M','2017-12-02','United Arab Emirates','Martha','B.','Cheryl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (536,157584668437,'M','2011-03-11','Egypt','Amy','G.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (537,324075591009,'F','1984-12-19','Egypt','Ernest','T.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (538,985970502591,'F','2007-10-02','Philippines','Roy','A.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (539,866980290118,'F','1972-04-30','Luxembourg','Linda','E.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (540,877247800208,'M','2001-04-28','Mauritius','Tammy','P.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (541,859245489837,'F','1980-02-22','Vanuatu','Deborah','X.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (542,827626517343,'F','1999-03-14','Spain','Diana','C.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (543,854761813244,'M','2004-07-09','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (544,996583914869,'M','1993-04-13','Mexico','Melissa','R.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (545,812667193284,'M','1959-02-03','Italy','Julia','N.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (546,767422448860,'F','2002-06-16','Japan','Margaret','L.','Rebecca',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (547,384677565619,'M','1981-07-25','Spain','Brenda','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (548,987348212615,'F','1968-11-11','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (549,678512911471,'F','1953-01-02','Netherlands','Anne','P.','Theresa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (550,589631305983,'M','2007-07-11','Mozambique','Carolyn','W.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (551,257478563474,'M','1975-11-17','Germany','Nancy','W.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (552,852501605172,'M','1994-08-31','Finland','Alan','R.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (553,781325758935,'F','1980-03-27','Australia','Mary','K.','Melissa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (554,676365875302,'F','1976-04-28','Israel','Pamela','I.','Paula',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (555,887961784045,'F','1989-05-27','China','Nancy','F.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (556,309354841381,'F','1985-09-09','Portugal','Paula','X.','Eugene',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (557,700596104244,'F','1978-08-09','Iceland','Nancy','M.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (558,153062839369,'F','1991-07-17','Finland','Alan','R.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (559,870186844202,'F','1954-03-17','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (560,240204657043,'F','1986-08-17','Germany','Jack','O.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (561,312500235171,'F','1955-05-06','Cameroon','Jack','J.','Ryan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (562,259092415728,'F','1987-02-12','Morocco','Cynthia','S.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (563,914373140993,'F','1967-01-31','Argentina','Andrea','M.','Rebecca',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (564,996844520164,'F','1956-03-25','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (565,321184221715,'F','2001-06-12','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (566,317494830812,'M','1990-02-23','Hong Kong SAR, China','Ann','O.','Mary',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (567,351286152505,'F','1996-07-26','Israel','Theresa','K.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (568,675487769782,'F','2011-09-08','Bahrain','Roger','J.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (569,175912610448,'F','1964-05-04','Namibia','Carolyn','Y.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (570,915463032841,'M','1955-08-15','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (571,702440247571,'F','2001-07-08','Russian Federation','Ryan','K.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (572,105856262473,'F','1963-03-07','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (573,987946244273,'M','1968-03-09','Serbia','Larry','K.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (574,160281567757,'F','2005-05-17','United States','Joe','V.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (575,904316921126,'F','1989-04-14','France','Steven','B.','Carol',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (576,872894807960,'F','1999-02-21','Italy','Brenda','K.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (577,261732387543,'F','2004-06-24','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (578,865300370174,'F','2007-01-14','Ethiopia','Daniel','V.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (579,614707618709,'F','1966-03-22','Spain','Brenda','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (580,708512596052,'F','1985-04-03','Suriname','Ernest','S.','Carolyn',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (581,804020403310,'F','2012-10-23','Vanuatu','Deborah','X.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (582,909878101954,'F','1958-10-24','Australia','Mary','K.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (583,144648382265,'F','1975-09-04','Seychelles','Carol','X.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (584,737511498758,'M','1969-05-22','Spain','Brenda','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (585,188005174482,'F','1965-08-21','New Caledonia','Matthew','L.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (586,217793282542,'M','1951-11-08','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (587,987161802759,'M','2017-02-18','Germany','Jack','O.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (588,515361848264,'F','1953-10-06','Ireland','Theresa','K.','Christopher',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (589,548159651632,'M','1954-01-22','New Zealand','Carl','P.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (590,753678559848,'M','1999-04-11','India','Mary','V.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (591,955615274387,'M','1967-12-05','Czech Republic','Joan','U.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (592,334994226088,'F','1997-04-25','Chile','Jeremy','Z.','Ernest',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (593,224109015153,'F','2011-10-13','Iran','Joyce','H.','Jack',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (594,990288527065,'F','1951-08-05','Colombia','Frances','I.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (595,434467380615,'M','1991-05-01','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (596,114053737968,'F','2014-08-17','Hong Kong SAR, China','Melissa','J.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (597,508838892104,'F','1966-01-25','Panama','Jose','P.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (598,996115466207,'F','1982-10-22','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (599,578543972224,'F','1963-04-25','Serbia','Larry','K.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (600,194385447527,'M','2023-02-28','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (601,391336098745,'M','2015-05-05','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (602,708168575536,'F','1952-03-14','United States','Frances','H.','Phillip',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (603,912923652983,'F','1964-10-20','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (604,128688140196,'M','1963-12-27','Namibia','Carolyn','Y.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (605,394550666112,'F','1952-02-20','Hong Kong SAR, China','Ann','O.','Mary',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (606,728742468692,'M','1959-10-05','Lebanon','Lillian','A.','Douglas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (607,926157459742,'M','2007-09-07','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (608,774256181927,'F','1986-11-08','Tanzania','Ralph','M.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (609,222083901515,'F','1968-09-05','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (610,756731525664,'M','1989-05-13','Netherlands','Anne','P.','Theresa',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (611,376922087944,'F','1978-09-06','United Arab Emirates','Christopher','Q.','Aaron',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (612,932847586178,'F','1998-06-06','Mauritius','Tammy','P.','Ralph',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (613,697692542701,'F','2012-01-02','Qatar','Cynthia','K.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (614,314945970150,'M','1969-08-25','Mauritius','Tammy','P.','Ralph',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (615,406601486345,'M','1986-04-30','Syrian Arab Republic','Anne','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (616,238097478375,'F','1963-12-18','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (617,809746566131,'M','1978-11-15','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (618,657617806477,'M','1963-05-13','Sweden','Ann','D.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (619,495317542012,'M','1986-03-19','Belgium','Aaron','L.','Nicole',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (620,248466532301,'M','1984-04-09','France','Thomas','P.','Jose',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (621,674244148916,'M','2008-08-18','New Caledonia','Matthew','L.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (622,221172264830,'M','1973-12-09','Egypt','Ernest','T.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (623,893365692337,'M','2003-07-08','France','Thomas','P.','Jose',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (624,502650767890,'F','2014-07-12','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (625,149568985124,'F','1998-02-11','France','Steven','B.','Carol',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (626,212020667132,'F','2006-08-31','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (627,565767795894,'F','2012-02-06','Finland','Alan','R.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (628,656736871104,'M','1962-05-02','Qatar','Cynthia','K.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (629,909096829212,'F','2013-04-17','Malaysia','Harold','C.','Joe',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (630,298561938091,'F','2000-08-24','Poland','Richard','X.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (631,372761805511,'M','2003-03-21','Serbia','Larry','K.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (632,348245415506,'M','1976-05-29','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (633,231342703415,'M','2023-03-27','Egypt','Paul','Z.','Judy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (634,432113433281,'F','1965-06-04','Solomon Islands','Dorothy','K.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (635,735632421658,'F','1966-06-24','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (636,853932008599,'M','1982-02-17','Trinidad and Tobago','Elizabeth','X.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (637,871459985799,'F','1985-03-20','Antigua and Barbuda','Todd','N.','Henry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (638,461473933616,'M','1998-02-18','United States','Benjamin','X.','Pamela',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (639,732543869251,'F','2012-01-04','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (640,936241936750,'M','1996-09-07','United Arab Emirates','Martha','B.','Cheryl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (641,911101724099,'F','1959-05-07','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (642,785123870375,'M','1960-12-28','Korea','William','W.','Wayne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (643,315910508612,'M','1961-06-15','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (644,529705750731,'M','1996-06-04','Canada','Diane','U.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (645,809645101638,'M','2013-05-25','Solomon Islands','Dorothy','K.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (646,347004911792,'F','1970-03-18','South Africa','Donna','S.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (647,176035112871,'M','1955-12-14','Italy','Brenda','K.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (648,141904570506,'F','2011-03-19','Democratic People''s Republic of Korea','Peter','M.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (649,500071809035,'M','1969-10-05','Indonesia','Sharon','O.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (650,985544626320,'F','1970-06-14','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (651,128207676706,'M','1979-12-03','South Africa','Donna','S.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (652,230821497989,'M','2016-01-28','Iran','Joyce','H.','Jack',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (653,937209944780,'M','1952-02-10','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (654,276408079034,'M','2009-07-07','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (655,357604097776,'F','1956-08-25','Solomon Islands','Dorothy','K.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (656,977945005934,'M','1976-05-30','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (657,276492562263,'M','1982-03-09','Chile','Cheryl','Q.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (658,175270049544,'M','1977-11-05','Poland','Richard','X.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (659,885826243315,'M','1969-07-16','Czech Republic','Joan','U.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (660,751713575985,'M','1972-12-17','Cuba','Henry','B.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (661,187430971719,'F','1976-11-18','Argentina','Wayne','O.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (662,730689776899,'M','2021-05-17','Netherlands','Anne','P.','Theresa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (663,948710749936,'F','1969-11-30','Hong Kong SAR, China','Ann','O.','Mary',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (664,870804092167,'M','1991-01-20','Seychelles','Carol','X.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (665,535314239176,'M','1974-09-01','Turkey','Nicole','X.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (666,894649338294,'F','2018-12-17','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (667,946273428808,'M','1958-03-18','Seychelles','Carol','X.','Thomas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (668,821797162486,'F','1973-10-13','South Africa','Donna','S.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (669,997759219793,'M','1990-06-29','Tunisia','Kelly','U.','Phillip',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (670,885921720188,'F','1997-09-09','Hong Kong SAR, China','Ann','O.','Mary',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (671,297703583425,'F','2023-12-28','Argentina','Wayne','O.','Nancy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (672,331018670606,'F','2000-01-04','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (673,573337511986,'F','1957-03-19','Morocco','Cynthia','S.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (674,560992090138,'M','2007-08-16','Democratic People''s Republic of Korea','Peter','M.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (675,301227348789,'M','1958-01-31','French Polynesia','Debra','L.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (676,561442639596,'F','1957-09-12','Korea','William','W.','Wayne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (677,441875558413,'F','1985-02-19','Namibia','Carolyn','Y.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (678,400174535330,'F','1958-10-28','Cyprus','Gregory','X.','Amanda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (679,871445919113,'M','2017-06-07','Cuba','Henry','B.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (680,708466476665,'F','1977-11-12','Philippines','Roy','A.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (681,662160011908,'F','2008-07-06','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (682,778853770694,'M','1969-03-26','South Africa','Douglas','O.','Joe',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (683,449058637896,'F','1981-08-13','Bahamas','Judy','Q.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (684,336333953703,'M','1972-01-18','Cyprus','Gregory','X.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (685,992348654041,'M','1998-03-15','Luxembourg','Jason','W.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (686,613862828764,'M','2006-09-22','Italy','Julia','N.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (687,535356116309,'F','2001-07-15','Russian Federation','Ryan','K.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (688,241296736838,'F','1999-06-22','Chile','Cheryl','Q.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (689,678637219522,'M','1951-11-10','Tanzania','Ralph','M.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (690,779652889267,'F','1958-06-08','Bahrain','Roger','J.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (691,712566854884,'M','1966-07-11','Qatar','Cynthia','K.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (692,509308103005,'F','2011-10-16','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (693,790565073354,'M','1987-01-27','Germany','Nancy','W.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (694,874082476474,'M','2011-06-22','France','Steven','B.','Carol',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (695,283737248808,'M','2021-01-07','New Zealand','Carl','P.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (696,710478663193,'M','1986-06-07','Japan','Nancy','U.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (697,222711119088,'M','1985-08-31','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (698,268527103432,'M','2015-01-12','United States','Cheryl','P.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (699,550426029781,'M','2004-03-15','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (700,127171074820,'M','1968-11-02','Pakistan','Janet','W.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (701,750690823785,'F','1986-01-03','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (702,643249331072,'F','1984-11-15','Serbia','Larry','K.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (703,810692138736,'M','1999-10-24','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (704,153068870513,'M','2008-07-10','Korea','William','W.','Wayne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (705,916822392185,'F','1957-11-26','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (706,787788487224,'M','2004-04-11','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (707,821229348572,'F','2008-04-05','Sweden','Ann','D.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (708,761775214393,'F','1986-08-30','Egypt','Amy','G.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (709,539916223602,'M','2008-01-22','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (710,212742056102,'M','1978-01-29','Israel','Theresa','K.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (711,209292636612,'M','2022-05-05','Bahamas','Judy','Q.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (712,787077941028,'M','1982-11-12','Costa Rica','Antonio','B.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (713,545372424264,'F','2000-06-04','Italy','Paul','W.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (714,331473028315,'F','1994-02-18','Tanzania','Ralph','M.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (715,129009420771,'F','2021-03-05','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (716,268150047169,'M','1955-04-24','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (717,182566686848,'F','2012-07-28','South Africa','Donna','S.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (718,309786517220,'F','1986-05-09','South Africa','Douglas','O.','Joe',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (719,694353018287,'F','1991-04-07','Hong Kong SAR, China','Ann','O.','Mary',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (720,309271865143,'M','1956-05-29','Italy','Julia','N.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (721,979538771492,'M','2005-07-26','Mauritius','Tammy','P.','Ralph',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (722,178287333796,'F','2023-12-04','Colombia','Frances','I.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (723,105711959516,'M','1979-08-22','Malaysia','Harold','C.','Joe',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (724,198048566484,'F','1961-07-21','France','Thomas','P.','Jose',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (725,275132499157,'M','1962-12-14','Hong Kong SAR, China','Margaret','T.','Jack',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (726,970743117650,'M','1992-03-09','Hong Kong SAR, China','Ann','O.','Mary',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (727,669042475627,'M','1961-09-16','United States','Carol','K.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (728,587022769689,'F','1960-01-15','Israel','Theresa','K.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (729,988296197021,'M','1982-12-01','Antigua and Barbuda','Todd','N.','Henry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (730,200961232896,'M','1973-11-03','Bahrain','Roger','J.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (731,683455565648,'F','2019-06-09','Mozambique','Carolyn','W.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (732,684932619790,'M','1990-08-10','Spain','Brenda','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (733,944620821318,'F','1994-01-12','Netherlands','Maria','N.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (734,325829831431,'M','1975-06-03','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (735,607917828380,'M','1997-07-25','Germany','Nancy','W.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (736,125873238148,'F','2001-09-18','Iceland','Nancy','M.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (737,482831574818,'M','1958-11-25','Luxembourg','Linda','E.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (738,348833758251,'F','2012-08-27','Morocco','Cynthia','S.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (739,891757251728,'F','1992-06-18','Ethiopia','Daniel','V.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (740,118205624163,'F','1958-10-20','Korea','William','W.','Wayne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (741,550010816496,'M','2009-06-15','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (742,236522723234,'F','1954-07-29','Australia','Mary','K.','Melissa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (743,789647941976,'M','2001-11-03','Antigua and Barbuda','Todd','N.','Henry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (744,485431284271,'M','2011-05-04','Japan','Margaret','L.','Rebecca',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (745,913496949093,'M','1956-05-22','United States','Carol','K.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (746,223661048947,'F','1952-09-05','Ethiopia','Daniel','V.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (747,335095112152,'F','1951-01-14','India','Mary','V.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (748,361987656221,'M','2023-04-14','Vanuatu','Deborah','X.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (749,681173623290,'M','2008-02-16','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (750,387511126522,'M','1961-10-24','Bahamas','Judy','Q.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (751,255072456704,'M','1995-03-01','Iceland','Nancy','M.','Maria',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (752,641186856665,'F','1981-10-05','Egypt','Ernest','T.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (753,815624316856,'F','1967-09-03','Bahamas','Judy','Q.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (754,931499667403,'F','1988-05-23','Sweden','Ann','D.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (755,837142844325,'M','2013-03-27','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (756,490797652438,'F','2022-01-15','Malaysia','Harold','C.','Joe',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (757,114782860923,'M','1953-09-03','Luxembourg','Linda','E.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (758,598875997507,'M','1951-04-13','Germany','Janice','P.','William',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (759,372048893720,'M','1986-02-22','Egypt','Paul','Z.','Judy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (760,489666484381,'F','1951-05-25','New Caledonia','Ruby','S.','Alan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (761,614130914035,'F','1993-08-02','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (762,141470906787,'M','2020-11-02','Costa Rica','Antonio','B.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (763,612432429280,'M','2020-09-01','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (764,145336921939,'F','1978-06-21','New Zealand','Carl','P.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (765,442341151654,'M','1973-12-22','Indonesia','Sharon','O.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (766,165579658899,'M','1987-05-10','Greece','Joshua','R.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (767,741310463529,'M','2014-03-28','Spain','Brenda','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (768,494841288545,'F','2016-06-11','Japan','Margaret','L.','Rebecca',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (769,303275271172,'F','1983-01-30','Israel','Theresa','K.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (770,810866569494,'M','1976-11-19','Italy','Amanda','Y.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (771,985841488007,'F','1961-06-08','Japan','Margaret','L.','Rebecca',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (772,599315128395,'F','1983-10-25','France','Steven','B.','Carol',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (773,536484540148,'F','2004-03-03','India','Rebecca','D.','Kelly',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (774,913627508483,'M','2016-12-19','New Caledonia','Ruby','S.','Alan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (775,640730375399,'M','2004-05-08','New Caledonia','Ruby','S.','Alan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (776,226464946791,'M','1968-06-09','Hong Kong SAR, China','Melissa','J.','Peter',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (777,336946412037,'F','2003-02-03','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (778,683800250107,'M','1955-11-21','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (779,393287105767,'F','1977-11-04','Thailand','Eugene','B.','Steven',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (780,390122232207,'M','1986-02-06','Spain','Brenda','P.','William',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (781,505380458812,'F','2010-05-29','Greece','Joshua','R.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (782,857907145512,'M','2000-03-31','El Salvador','Jimmy','U.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (783,959243508136,'M','1961-04-15','Turkey','Nicole','X.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (784,441240831645,'F','1957-05-10','United Kingdom','Clarence','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (785,821881299997,'F','1951-01-13','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (786,413457792315,'F','2002-03-03','United States','Carol','K.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (787,700651011765,'M','1989-09-10','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (788,712004915622,'M','1961-07-17','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (789,406162159090,'F','1959-01-12','Panama','Jose','P.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (790,246468886708,'F','1978-05-02','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (791,122548290308,'F','1986-08-04','Iceland','Nancy','M.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (792,851713667952,'F','2005-04-24','Mauritius','Tammy','P.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (793,818322537453,'M','2021-02-10','Spain','Diana','C.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (794,804964214216,'M','1989-05-09','Egypt','Ernest','T.','Elizabeth',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (795,569935951921,'F','2016-01-07','Bahrain','Roger','J.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (796,737241206318,'F','1995-12-04','Tunisia','Kelly','U.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (797,689204270900,'M','1987-01-15','Tanzania','Lillian','D.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (798,937260260026,'F','2013-08-08','Saudi Arabia','Ruby','P.','Roy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (799,187357296206,'F','2022-05-29','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (800,159023690335,'F','1982-07-13','Philippines','Roy','A.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (801,358826896429,'F','1970-12-14','Czech Republic','Joan','U.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (802,223894827235,'M','1961-10-15','Italy','Julia','N.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (803,692414941166,'M','2018-03-08','United Arab Emirates','Christopher','Q.','Aaron',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (804,808233256417,'M','2017-10-30','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (805,820245775844,'M','2014-09-20','Turkey','Nicole','X.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (806,303287976120,'M','1991-09-07','Portugal','Paula','X.','Eugene',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (807,940427007705,'M','1959-05-03','Poland','Richard','X.','Clarence',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (808,829129685248,'F','1974-03-10','Tunisia','Kelly','U.','Phillip',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (809,246916687702,'M','2022-08-05','Iceland','Nancy','M.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (810,216858158953,'M','2008-05-25','Israel','Theresa','K.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (811,908219776354,'M','1988-12-16','Democratic People''s Republic of Korea','Peter','M.','Joyce',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (812,755381514039,'M','1992-07-01','New Caledonia','Ruby','S.','Alan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (813,985167830836,'M','1987-10-29','Greece','Joshua','R.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (814,227292264354,'F','2006-08-10','Iran','Joyce','H.','Jack',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (815,909183447262,'M','2015-08-14','Syrian Arab Republic','Anne','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (816,934103635650,'F','2002-02-07','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (817,467792332956,'F','2022-08-14','Solomon Islands','Dorothy','K.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (818,401111096811,'F','1998-09-08','Tanzania','Ralph','M.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (819,996935676230,'M','1995-03-09','Mexico','Melissa','R.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (820,642530412456,'F','1984-02-28','Malaysia','Harold','C.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (821,875832924329,'M','1957-07-22','Spain','Diana','C.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (822,289897402853,'F','1960-12-28','Netherlands','Anne','P.','Theresa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (823,913407480286,'M','2017-03-18','Hong Kong SAR, China','Margaret','T.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (824,607613327769,'M','1986-12-03','Morocco','Cynthia','S.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (825,201141334683,'M','1966-01-13','United States','Carol','K.','Tammy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (826,470568712339,'F','2018-07-02','Philippines','Roy','A.','Jason',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (827,829201419442,'F','1957-05-05','United Arab Emirates','Martha','B.','Cheryl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (828,487511984521,'F','1978-12-03','Serbia','Larry','K.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (829,251428902352,'M','2009-11-12','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (830,750381408777,'F','1983-12-25','Argentina','Andrea','M.','Rebecca',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (831,740387691187,'F','1981-04-06','Namibia','Carolyn','Y.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (832,436015722535,'M','1960-02-20','Bahamas','Judy','Q.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (833,374199880878,'F','2002-01-11','Luxembourg','Jason','W.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (834,665868925549,'M','2008-10-14','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (835,662524994794,'F','2013-02-17','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (836,560530023086,'M','1981-12-13','Poland','Richard','X.','Clarence',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (837,537949079756,'M','2005-08-10','United Arab Emirates','Christopher','Q.','Aaron',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (838,472903602086,'F','2008-12-18','Suriname','Ernest','S.','Carolyn',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (839,680716464403,'M','2004-07-14','Greece','Joshua','R.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (840,289836220387,'F','1995-08-25','Chile','Cheryl','Q.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (841,588659858034,'M','1989-10-10','Finland','Alan','R.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (842,440370560918,'M','1973-09-04','Hong Kong SAR, China','Melissa','J.','Peter',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (843,779646073945,'M','2019-06-20','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (844,310762998742,'M','1985-10-04','Germany','Nancy','W.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (845,473043866425,'F','1980-04-05','Greece','Joshua','R.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (846,313902240658,'F','1981-05-19','Indonesia','Sharon','O.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (847,576647044723,'M','1970-04-14','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (848,551605643517,'F','1981-11-08','Egypt','Paul','Z.','Judy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (849,883966816606,'F','1969-10-01','Mexico','Melissa','R.','Harold',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (850,909987673421,'F','1990-05-26','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (851,408084306278,'M','1953-11-01','Costa Rica','Antonio','B.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (852,606803423687,'M','1987-02-01','United States','Joe','V.','Ralph',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (853,755577197305,'F','1974-03-22','French Polynesia','Debra','L.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (854,311496109664,'F','1961-09-13','Argentina','Andrea','M.','Rebecca',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (855,725649741200,'F','2012-07-03','India','Mary','V.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (856,798447670999,'M','2000-04-13','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (857,189581341802,'M','1950-12-08','Luxembourg','Jason','W.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (858,267751289788,'M','1979-03-18','United States','Benjamin','X.','Pamela',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (859,538340932614,'F','2020-06-02','Qatar','Cynthia','K.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (860,888447788090,'F','1967-05-20','India','Rebecca','D.','Kelly',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (861,201741037346,'M','2004-04-16','Portugal','Paula','X.','Eugene',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (862,292287018040,'M','1972-04-03','Chile','Jeremy','Z.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (863,979633963181,'M','2021-01-31','Tanzania','Ralph','M.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (864,498176989092,'M','1978-03-29','Lebanon','Lillian','A.','Douglas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (865,959204659498,'M','1993-10-21','Finland','Alan','R.','Larry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (866,642015107868,'F','1998-05-31','United States','Cheryl','P.','Melissa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (867,902052024144,'M','1990-05-07','New Caledonia','Ruby','S.','Alan',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (868,139208560097,'M','1998-11-16','India','Mary','V.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (869,217670253864,'F','1996-01-18','Portugal','Paula','X.','Eugene',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (870,772182599926,'F','1955-01-02','Mexico','Melissa','R.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (871,424833554107,'F','1976-11-29','Chile','Cheryl','Q.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (872,745353320523,'M','1964-12-03','Angola','Judy','S.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (873,157186793993,'F','1967-05-22','Syrian Arab Republic','Anne','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (874,876575857555,'F','1983-03-12','Israel','Pamela','I.','Paula',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (875,911519583759,'F','1959-12-15','Iceland','Nancy','M.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (876,395098296229,'F','2022-02-24','Israel','Theresa','K.','Anne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (877,375062583896,'F','2019-04-01','Argentina','Wayne','O.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (878,410343428609,'F','1993-01-17','New Caledonia','Matthew','L.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (879,798295105886,'F','1969-01-21','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (880,624156270751,'M','1969-06-30','Japan','Margaret','L.','Rebecca',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (881,540559257693,'M','2009-11-21','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (882,720653617676,'F','1988-05-04','Japan','Nancy','U.','Diane',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (883,315230228584,'F','1962-10-24','South Africa','Douglas','O.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (884,199617160745,'F','1994-12-13','Sweden','Ann','D.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (885,391370303801,'F','1965-03-31','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (886,678394070822,'M','2002-05-04','Ireland','Theresa','K.','Christopher',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (887,750291275443,'M','1991-01-08','United States','Carol','K.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (888,229167349240,'F','1967-03-10','United States','Frances','H.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (889,313190262621,'F','1979-12-19','Korea','William','W.','Wayne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (890,279501310961,'M','1957-09-19','United States','Joe','V.','Ralph',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (891,531334643160,'M','2000-06-25','Israel','Pamela','I.','Paula',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (892,266234550613,'M','2003-03-07','United States','Carol','K.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (893,978475009652,'M','1985-12-24','Antigua and Barbuda','Todd','N.','Henry',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (894,325782850080,'M','1997-03-13','Korea','William','W.','Wayne',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (895,824836102422,'M','1987-12-01','Lebanon','Lillian','A.','Douglas',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (896,699753164514,'F','1981-12-02','United States','Lois','L.','Brenda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (897,741942838349,'F','1956-03-08','Philippines','Roy','A.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (898,391109043927,'F','2008-08-15','Germany','Nancy','W.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (899,889298864786,'M','1967-11-02','Saudi Arabia','Ruby','P.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (900,487997382193,'M','2009-01-19','Germany','Jack','O.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (901,881649386429,'F','1995-03-08','Luxembourg','Jason','W.','Diane',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (902,913511422841,'M','1999-10-12','India','Mary','V.','Ernest',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (903,391822509986,'F','1973-06-14','Germany','Nancy','W.','Thomas',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (904,311531540723,'M','1957-04-20','Ethiopia','Daniel','V.','Roy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (905,512855436874,'F','1972-02-20','United Kingdom','Clarence','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (906,310624842302,'F','2000-11-14','Germany','Janice','P.','William',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (907,487188268731,'M','2012-06-26','Cuba','Henry','B.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (908,738826706127,'M','1993-08-04','Iceland','Nancy','M.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (909,672983006846,'F','1998-01-22','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (910,435640018625,'F','1964-12-18','United States','Carol','K.','Tammy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (911,514064168914,'M','2008-08-31','Canada','Diane','U.','Maria',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (912,207486235946,'F','1961-08-02','Canada','Diane','U.','Maria',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (913,977440965376,'F','1963-09-15','Solomon Islands','Dorothy','K.','Elizabeth',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (914,167991315355,'M','1995-06-18','Pakistan','Janet','W.','Jason',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (915,148970746917,'F','2004-12-12','Japan','Margaret','L.','Rebecca',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (916,327116799319,'F','1981-12-28','Angola','Judy','S.','Amanda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (917,619419982907,'M','1978-07-12','Tanzania','Lillian','D.','Andrea',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (918,357150264197,'M','1991-08-16','Argentina','Wayne','O.','Nancy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (919,807988405810,'M','2019-07-29','El Salvador','Jimmy','U.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (920,840270925709,'F','2007-07-12','Egypt','Ernest','T.','Elizabeth',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (921,212720529474,'F','1988-01-08','Costa Rica','Antonio','B.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (922,372081919877,'F','2015-02-24','Panama','Jose','P.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (923,665063022457,'F','2016-12-11','United Kingdom','Clarence','K.','Jeremy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (924,562579047981,'M','2012-11-27','United Arab Emirates','Martha','B.','Cheryl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (925,793693073616,'M','1952-08-27','New Caledonia','Matthew','L.','Linda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (926,327436658436,'M','1965-07-13','Vanuatu','Deborah','X.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (927,124296882198,'F','1969-09-15','Japan','Margaret','L.','Rebecca',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (928,809386923327,'M','1966-11-30','Cameroon','Jack','J.','Ryan',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (929,160408147690,'F','1959-02-08','Hong Kong SAR, China','Margaret','T.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (930,990432207613,'M','1958-08-13','Cameroon','Jack','J.','Ryan',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (931,894051736242,'F','2021-01-23','France','Steven','B.','Carol',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (932,690307883603,'F','1983-05-22','French Polynesia','Debra','L.','Amy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (933,284372724505,'M','2010-08-28','Egypt','Paul','Z.','Judy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (934,907368803297,'M','2015-04-21','Ethiopia','Daniel','V.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (935,117081386495,'F','1994-12-27','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (936,288451752533,'M','1992-08-07','France','Steven','B.','Carol',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (937,573652623994,'M','2017-12-10','United States','Carol','K.','Tammy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (938,999890276246,'M','1998-05-15','South Africa','Donna','S.','Carl',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (939,693304662618,'M','2011-05-18','Japan','Margaret','L.','Rebecca',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (940,255982636715,'F','1973-07-03','Turkey','Nicole','X.','Tammy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (941,174865235030,'F','2015-04-06','Israel','Pamela','I.','Paula',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (942,654372613493,'F','1995-05-15','United Arab Emirates','Christopher','Q.','Aaron',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (943,576628558424,'M','2020-10-16','Democratic People''s Republic of Korea','Peter','M.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (944,524073135913,'F','1966-03-17','India','Rebecca','D.','Kelly',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (945,503469032810,'M','2006-01-07','Kuwait','Phillip','Q.','Anne',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (946,645679322557,'M','1967-01-18','Seychelles','Carol','X.','Thomas',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (947,155862852445,'F','2005-12-15','United Kingdom','Clarence','K.','Jeremy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (948,462775454726,'M','1964-10-18','China','Nancy','F.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (949,194285326396,'M','1950-07-10','China','Nancy','F.','Carl',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (950,904771546580,'M','1974-06-18','Qatar','Cynthia','K.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (951,367058896453,'M','1961-10-14','Suriname','Ernest','S.','Carolyn',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (952,353280513276,'F','2020-08-30','Chile','Jeremy','Z.','Ernest',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (953,764986818885,'M','1987-07-09','Thailand','Eugene','B.','Steven',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (954,420747810213,'F','1971-02-20','Trinidad and Tobago','Elizabeth','X.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (955,354113380046,'M','1990-12-20','Luxembourg','Jason','W.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (956,275689101999,'F','1969-01-25','Vanuatu','Deborah','X.','Amy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (957,383556718404,'F','2016-03-09','Costa Rica','Antonio','B.','Harold',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (958,721918295457,'F','1965-07-08','New Zealand','Carl','P.','Joyce',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (959,158694939327,'M','1975-07-27','Netherlands','Maria','N.','Jason',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (960,533702329179,'F','1958-01-02','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (961,650496563754,'M','2014-06-10','Iran','Joyce','H.','Jack',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (962,592151548836,'M','1960-07-07','Trinidad and Tobago','Elizabeth','X.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (963,726748742676,'M','2000-09-11','Serbia','Larry','K.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (964,805490928688,'F','2007-12-09','Costa Rica','Antonio','B.','Harold',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (965,598179836126,'F','1972-03-06','Netherlands','Anne','P.','Theresa',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (966,590625015948,'F','1955-08-06','Turkey','Nicole','X.','Tammy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (967,615290928029,'F','2017-09-18','Morocco','Cynthia','S.','Jimmy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (968,127932311167,'M','2001-01-01','Angola','Judy','S.','Amanda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (969,320369870238,'F','1964-07-20','Netherlands','Anne','P.','Theresa',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (970,927457343991,'M','2013-06-24','South Africa','Douglas','O.','Joe',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (971,865921403661,'M','2013-07-28','Belgium','Aaron','L.','Nicole',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (972,517871456066,'M','1990-08-16','Spain','Diana','C.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (973,819788514175,'F','1950-04-20','Angola','Judy','S.','Amanda',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (974,584787157525,'M','1982-02-02','United Arab Emirates','Christopher','Q.','Aaron',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (975,627337185335,'M','1994-12-03','Japan','Nancy','U.','Diane',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (976,633691284585,'F','2009-12-01','New Zealand','Carl','P.','Joyce',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (977,782363992993,'M','2000-11-10','Poland','Richard','X.','Clarence',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (978,768716993271,'F','1959-07-01','United Kingdom','Clarence','K.','Jeremy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (979,969957997255,'M','1993-08-25','Czech Republic','Joan','U.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (980,863962178246,'M','1989-01-07','Morocco','Cynthia','S.','Jimmy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (981,572375207344,'M','2018-08-27','South Africa','Douglas','O.','Joe',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (982,338144255177,'M','1965-06-29','Serbia','Larry','K.','Nancy',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (983,882051686117,'M','1975-11-09','Portugal','Paula','X.','Eugene',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (984,734362704680,'M','1988-05-12','Luxembourg','Linda','E.','Andrea',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (985,713529327904,'M','2004-08-22','South Africa','Donna','S.','Carl',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (986,826867649635,'F','2023-02-26','Finland','Alan','R.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (987,315516813420,'F','2000-03-11','Bahrain','Roger','J.','Andrea',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (988,471738943060,'M','1958-03-30','Saudi Arabia','Ruby','P.','Roy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (989,836741823101,'F','1967-12-06','Czech Republic','Joan','U.','Larry',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (990,419785121049,'F','2008-08-07','Tanzania','Ralph','M.','Linda',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (991,445086701488,'M','1968-06-11','Qatar','Cynthia','K.','Larry',5);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (992,883696155518,'M','1968-01-17','Tunisia','Kelly','U.','Phillip',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (993,635973639881,'F','2001-07-11','Kuwait','Phillip','Q.','Anne',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (994,784132733038,'M','2001-12-29','Italy','Brenda','K.','Jimmy',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (995,670010529276,'M','1992-11-13','Hong Kong SAR, China','Melissa','J.','Peter',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (996,794791609475,'F','1987-11-11','China','Patrick','R.','Deborah',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (997,497115972971,'M','2019-10-23','Russian Federation','Ryan','K.','Linda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (998,332262623017,'F','1975-09-19','Sweden','Ann','D.','Amy',6);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (999,393533312643,'M','2021-08-30','United States','Lois','L.','Brenda',4);
INSERT INTO passenger(PID,PassportNo,Sex,DOB,Nationality,Fname,Minit,Lname,UserID) VALUES (1000,310515731438,'F','1991-10-09','Indonesia','Sharon','O.','Anne',6);

INSERT INTO passenger_phone(PID,Phone) VALUES (555,7851519604);
INSERT INTO passenger_phone(PID,Phone) VALUES (36,3137544033);
INSERT INTO passenger_phone(PID,Phone) VALUES (132,4543220286);
INSERT INTO passenger_phone(PID,Phone) VALUES (100,2793405655);
INSERT INTO passenger_phone(PID,Phone) VALUES (226,3422327141);
INSERT INTO passenger_phone(PID,Phone) VALUES (931,6402448042);
INSERT INTO passenger_phone(PID,Phone) VALUES (862,0863148627);
INSERT INTO passenger_phone(PID,Phone) VALUES (501,8854200897);
INSERT INTO passenger_phone(PID,Phone) VALUES (529,1435845903);
INSERT INTO passenger_phone(PID,Phone) VALUES (642,6155299666);
INSERT INTO passenger_phone(PID,Phone) VALUES (231,2476023025);
INSERT INTO passenger_phone(PID,Phone) VALUES (104,1342294692);
INSERT INTO passenger_phone(PID,Phone) VALUES (677,3774066158);
INSERT INTO passenger_phone(PID,Phone) VALUES (463,3830024875);
INSERT INTO passenger_phone(PID,Phone) VALUES (678,8243308511);
INSERT INTO passenger_phone(PID,Phone) VALUES (720,4191575405);
INSERT INTO passenger_phone(PID,Phone) VALUES (915,9748916427);
INSERT INTO passenger_phone(PID,Phone) VALUES (162,8653920046);
INSERT INTO passenger_phone(PID,Phone) VALUES (297,2077966913);
INSERT INTO passenger_phone(PID,Phone) VALUES (67,0656547468);
INSERT INTO passenger_phone(PID,Phone) VALUES (309,7816319420);
INSERT INTO passenger_phone(PID,Phone) VALUES (212,9056787001);
INSERT INTO passenger_phone(PID,Phone) VALUES (814,2211730901);
INSERT INTO passenger_phone(PID,Phone) VALUES (374,2454790518);
INSERT INTO passenger_phone(PID,Phone) VALUES (557,5945097306);
INSERT INTO passenger_phone(PID,Phone) VALUES (965,2592008471);
INSERT INTO passenger_phone(PID,Phone) VALUES (490,2970755799);
INSERT INTO passenger_phone(PID,Phone) VALUES (854,3531381053);
INSERT INTO passenger_phone(PID,Phone) VALUES (23,9647091560);
INSERT INTO passenger_phone(PID,Phone) VALUES (597,0941794721);
INSERT INTO passenger_phone(PID,Phone) VALUES (439,7008815645);
INSERT INTO passenger_phone(PID,Phone) VALUES (930,2741243539);
INSERT INTO passenger_phone(PID,Phone) VALUES (414,5657192057);
INSERT INTO passenger_phone(PID,Phone) VALUES (21,7254617441);
INSERT INTO passenger_phone(PID,Phone) VALUES (474,6357305204);
INSERT INTO passenger_phone(PID,Phone) VALUES (532,9681523446);
INSERT INTO passenger_phone(PID,Phone) VALUES (107,1329639997);
INSERT INTO passenger_phone(PID,Phone) VALUES (144,9813150313);
INSERT INTO passenger_phone(PID,Phone) VALUES (543,3805723986);
INSERT INTO passenger_phone(PID,Phone) VALUES (29,2927858399);
INSERT INTO passenger_phone(PID,Phone) VALUES (664,5274688751);
INSERT INTO passenger_phone(PID,Phone) VALUES (937,3202445440);
INSERT INTO passenger_phone(PID,Phone) VALUES (784,2241507760);
INSERT INTO passenger_phone(PID,Phone) VALUES (224,8264872446);
INSERT INTO passenger_phone(PID,Phone) VALUES (184,2978277512);
INSERT INTO passenger_phone(PID,Phone) VALUES (873,8549617392);
INSERT INTO passenger_phone(PID,Phone) VALUES (482,5303434964);
INSERT INTO passenger_phone(PID,Phone) VALUES (28,7246942587);
INSERT INTO passenger_phone(PID,Phone) VALUES (617,2503506558);
INSERT INTO passenger_phone(PID,Phone) VALUES (607,3705913958);
INSERT INTO passenger_phone(PID,Phone) VALUES (863,0739646332);
INSERT INTO passenger_phone(PID,Phone) VALUES (355,7463712987);
INSERT INTO passenger_phone(PID,Phone) VALUES (352,0615729434);
INSERT INTO passenger_phone(PID,Phone) VALUES (643,0474708110);
INSERT INTO passenger_phone(PID,Phone) VALUES (877,1642281040);
INSERT INTO passenger_phone(PID,Phone) VALUES (122,0597362144);
INSERT INTO passenger_phone(PID,Phone) VALUES (995,6799686767);
INSERT INTO passenger_phone(PID,Phone) VALUES (460,2488384589);
INSERT INTO passenger_phone(PID,Phone) VALUES (898,8555433618);
INSERT INTO passenger_phone(PID,Phone) VALUES (208,3895778676);
INSERT INTO passenger_phone(PID,Phone) VALUES (494,9219256594);
INSERT INTO passenger_phone(PID,Phone) VALUES (671,9989300127);
INSERT INTO passenger_phone(PID,Phone) VALUES (249,3957375822);
INSERT INTO passenger_phone(PID,Phone) VALUES (543,2923793228);
INSERT INTO passenger_phone(PID,Phone) VALUES (613,1685212079);
INSERT INTO passenger_phone(PID,Phone) VALUES (779,7454094620);
INSERT INTO passenger_phone(PID,Phone) VALUES (225,8521388349);
INSERT INTO passenger_phone(PID,Phone) VALUES (425,6335523154);
INSERT INTO passenger_phone(PID,Phone) VALUES (873,8960378852);
INSERT INTO passenger_phone(PID,Phone) VALUES (24,7997200764);
INSERT INTO passenger_phone(PID,Phone) VALUES (415,1306186256);
INSERT INTO passenger_phone(PID,Phone) VALUES (880,4812051793);
INSERT INTO passenger_phone(PID,Phone) VALUES (38,6600764316);
INSERT INTO passenger_phone(PID,Phone) VALUES (622,3806675508);
INSERT INTO passenger_phone(PID,Phone) VALUES (730,2595214010);
INSERT INTO passenger_phone(PID,Phone) VALUES (920,7793657790);
INSERT INTO passenger_phone(PID,Phone) VALUES (398,8407114884);
INSERT INTO passenger_phone(PID,Phone) VALUES (817,0380819885);
INSERT INTO passenger_phone(PID,Phone) VALUES (537,3626911538);
INSERT INTO passenger_phone(PID,Phone) VALUES (299,3274183484);
INSERT INTO passenger_phone(PID,Phone) VALUES (805,0114619484);
INSERT INTO passenger_phone(PID,Phone) VALUES (489,3600685963);
INSERT INTO passenger_phone(PID,Phone) VALUES (409,8726994473);
INSERT INTO passenger_phone(PID,Phone) VALUES (750,9562150705);
INSERT INTO passenger_phone(PID,Phone) VALUES (976,8372031797);
INSERT INTO passenger_phone(PID,Phone) VALUES (932,1512192524);
INSERT INTO passenger_phone(PID,Phone) VALUES (843,5697202307);
INSERT INTO passenger_phone(PID,Phone) VALUES (413,6151858720);
INSERT INTO passenger_phone(PID,Phone) VALUES (317,3455818795);
INSERT INTO passenger_phone(PID,Phone) VALUES (991,8787995383);
INSERT INTO passenger_phone(PID,Phone) VALUES (62,6477424162);
INSERT INTO passenger_phone(PID,Phone) VALUES (463,9450377867);
INSERT INTO passenger_phone(PID,Phone) VALUES (871,9471650758);
INSERT INTO passenger_phone(PID,Phone) VALUES (657,8760195882);
INSERT INTO passenger_phone(PID,Phone) VALUES (411,3917999399);
INSERT INTO passenger_phone(PID,Phone) VALUES (529,2096172882);
INSERT INTO passenger_phone(PID,Phone) VALUES (831,6957564618);
INSERT INTO passenger_phone(PID,Phone) VALUES (139,3959171862);
INSERT INTO passenger_phone(PID,Phone) VALUES (449,9175209719);
INSERT INTO passenger_phone(PID,Phone) VALUES (139,3226241070);
INSERT INTO passenger_phone(PID,Phone) VALUES (974,5983901941);
INSERT INTO passenger_phone(PID,Phone) VALUES (1,2427526924);
INSERT INTO passenger_phone(PID,Phone) VALUES (52,0438065457);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,4802315457);
INSERT INTO passenger_phone(PID,Phone) VALUES (137,1713569352);
INSERT INTO passenger_phone(PID,Phone) VALUES (884,2689626565);
INSERT INTO passenger_phone(PID,Phone) VALUES (911,4895260217);
INSERT INTO passenger_phone(PID,Phone) VALUES (842,6104101453);
INSERT INTO passenger_phone(PID,Phone) VALUES (495,6570354515);
INSERT INTO passenger_phone(PID,Phone) VALUES (917,1169256266);
INSERT INTO passenger_phone(PID,Phone) VALUES (654,9957629883);
INSERT INTO passenger_phone(PID,Phone) VALUES (309,7000960112);
INSERT INTO passenger_phone(PID,Phone) VALUES (135,6000646016);
INSERT INTO passenger_phone(PID,Phone) VALUES (353,7401969217);
INSERT INTO passenger_phone(PID,Phone) VALUES (195,1729517150);
INSERT INTO passenger_phone(PID,Phone) VALUES (644,9948379424);
INSERT INTO passenger_phone(PID,Phone) VALUES (31,5727182307);
INSERT INTO passenger_phone(PID,Phone) VALUES (675,5611910744);
INSERT INTO passenger_phone(PID,Phone) VALUES (613,4227024630);
INSERT INTO passenger_phone(PID,Phone) VALUES (422,5717055382);
INSERT INTO passenger_phone(PID,Phone) VALUES (475,6013921113);
INSERT INTO passenger_phone(PID,Phone) VALUES (492,4851673070);
INSERT INTO passenger_phone(PID,Phone) VALUES (219,7592071920);
INSERT INTO passenger_phone(PID,Phone) VALUES (432,7869637479);
INSERT INTO passenger_phone(PID,Phone) VALUES (906,5458250140);
INSERT INTO passenger_phone(PID,Phone) VALUES (891,0805155978);
INSERT INTO passenger_phone(PID,Phone) VALUES (461,7367897648);
INSERT INTO passenger_phone(PID,Phone) VALUES (67,8667611307);
INSERT INTO passenger_phone(PID,Phone) VALUES (193,5589912734);
INSERT INTO passenger_phone(PID,Phone) VALUES (458,0907096064);
INSERT INTO passenger_phone(PID,Phone) VALUES (614,9685606484);
INSERT INTO passenger_phone(PID,Phone) VALUES (188,6493059678);
INSERT INTO passenger_phone(PID,Phone) VALUES (542,1099505158);
INSERT INTO passenger_phone(PID,Phone) VALUES (517,2919032699);
INSERT INTO passenger_phone(PID,Phone) VALUES (130,0550056050);
INSERT INTO passenger_phone(PID,Phone) VALUES (151,7536835765);
INSERT INTO passenger_phone(PID,Phone) VALUES (753,5890854173);
INSERT INTO passenger_phone(PID,Phone) VALUES (460,3998280972);
INSERT INTO passenger_phone(PID,Phone) VALUES (663,9500207886);
INSERT INTO passenger_phone(PID,Phone) VALUES (317,6794425958);
INSERT INTO passenger_phone(PID,Phone) VALUES (484,9035974700);
INSERT INTO passenger_phone(PID,Phone) VALUES (989,1085484552);
INSERT INTO passenger_phone(PID,Phone) VALUES (751,4569545419);
INSERT INTO passenger_phone(PID,Phone) VALUES (330,3531290247);
INSERT INTO passenger_phone(PID,Phone) VALUES (799,1542920364);
INSERT INTO passenger_phone(PID,Phone) VALUES (167,4497724851);
INSERT INTO passenger_phone(PID,Phone) VALUES (45,5594260466);
INSERT INTO passenger_phone(PID,Phone) VALUES (811,7299217338);
INSERT INTO passenger_phone(PID,Phone) VALUES (18,6610557121);
INSERT INTO passenger_phone(PID,Phone) VALUES (814,7957501386);
INSERT INTO passenger_phone(PID,Phone) VALUES (150,6658913076);
INSERT INTO passenger_phone(PID,Phone) VALUES (675,1917294363);
INSERT INTO passenger_phone(PID,Phone) VALUES (100,0135559307);
INSERT INTO passenger_phone(PID,Phone) VALUES (511,6767786991);
INSERT INTO passenger_phone(PID,Phone) VALUES (734,5848117209);
INSERT INTO passenger_phone(PID,Phone) VALUES (718,6809225141);
INSERT INTO passenger_phone(PID,Phone) VALUES (427,7597643594);
INSERT INTO passenger_phone(PID,Phone) VALUES (724,4403256571);
INSERT INTO passenger_phone(PID,Phone) VALUES (726,3232823500);
INSERT INTO passenger_phone(PID,Phone) VALUES (137,4047254036);
INSERT INTO passenger_phone(PID,Phone) VALUES (707,2137781912);
INSERT INTO passenger_phone(PID,Phone) VALUES (154,0466660855);
INSERT INTO passenger_phone(PID,Phone) VALUES (817,9437400306);
INSERT INTO passenger_phone(PID,Phone) VALUES (257,9290001328);
INSERT INTO passenger_phone(PID,Phone) VALUES (881,8349464389);
INSERT INTO passenger_phone(PID,Phone) VALUES (147,4336341635);
INSERT INTO passenger_phone(PID,Phone) VALUES (716,9297624632);
INSERT INTO passenger_phone(PID,Phone) VALUES (214,3154659241);
INSERT INTO passenger_phone(PID,Phone) VALUES (348,2705923997);
INSERT INTO passenger_phone(PID,Phone) VALUES (300,3033749680);
INSERT INTO passenger_phone(PID,Phone) VALUES (133,1206539234);
INSERT INTO passenger_phone(PID,Phone) VALUES (935,4873252204);
INSERT INTO passenger_phone(PID,Phone) VALUES (781,3499170775);
INSERT INTO passenger_phone(PID,Phone) VALUES (812,3547182175);
INSERT INTO passenger_phone(PID,Phone) VALUES (375,3253030959);
INSERT INTO passenger_phone(PID,Phone) VALUES (800,7794626886);
INSERT INTO passenger_phone(PID,Phone) VALUES (460,2993408731);
INSERT INTO passenger_phone(PID,Phone) VALUES (178,7565513677);
INSERT INTO passenger_phone(PID,Phone) VALUES (500,1470296930);
INSERT INTO passenger_phone(PID,Phone) VALUES (10,8686416563);
INSERT INTO passenger_phone(PID,Phone) VALUES (983,3981657158);
INSERT INTO passenger_phone(PID,Phone) VALUES (526,8286915765);
INSERT INTO passenger_phone(PID,Phone) VALUES (785,5704726062);
INSERT INTO passenger_phone(PID,Phone) VALUES (815,1998460292);
INSERT INTO passenger_phone(PID,Phone) VALUES (262,8179491714);
INSERT INTO passenger_phone(PID,Phone) VALUES (187,0146222656);
INSERT INTO passenger_phone(PID,Phone) VALUES (998,6461551418);
INSERT INTO passenger_phone(PID,Phone) VALUES (100,5041313001);
INSERT INTO passenger_phone(PID,Phone) VALUES (409,8114583818);
INSERT INTO passenger_phone(PID,Phone) VALUES (944,0212484906);
INSERT INTO passenger_phone(PID,Phone) VALUES (42,8687948238);
INSERT INTO passenger_phone(PID,Phone) VALUES (885,9862856857);
INSERT INTO passenger_phone(PID,Phone) VALUES (990,8463281806);
INSERT INTO passenger_phone(PID,Phone) VALUES (900,4752144389);
INSERT INTO passenger_phone(PID,Phone) VALUES (122,7402193355);
INSERT INTO passenger_phone(PID,Phone) VALUES (309,6570146039);
INSERT INTO passenger_phone(PID,Phone) VALUES (249,0602317562);
INSERT INTO passenger_phone(PID,Phone) VALUES (631,4983559403);
INSERT INTO passenger_phone(PID,Phone) VALUES (731,4561596976);
INSERT INTO passenger_phone(PID,Phone) VALUES (374,6587054058);
INSERT INTO passenger_phone(PID,Phone) VALUES (248,8383584952);
INSERT INTO passenger_phone(PID,Phone) VALUES (522,0332656507);
INSERT INTO passenger_phone(PID,Phone) VALUES (968,5710593170);
INSERT INTO passenger_phone(PID,Phone) VALUES (212,3920051097);
INSERT INTO passenger_phone(PID,Phone) VALUES (805,2100426450);
INSERT INTO passenger_phone(PID,Phone) VALUES (330,1739418158);
INSERT INTO passenger_phone(PID,Phone) VALUES (941,3106630966);
INSERT INTO passenger_phone(PID,Phone) VALUES (254,9737737689);
INSERT INTO passenger_phone(PID,Phone) VALUES (522,7602722366);
INSERT INTO passenger_phone(PID,Phone) VALUES (98,9716878172);
INSERT INTO passenger_phone(PID,Phone) VALUES (322,8338931017);
INSERT INTO passenger_phone(PID,Phone) VALUES (196,7544000622);
INSERT INTO passenger_phone(PID,Phone) VALUES (985,9055783814);
INSERT INTO passenger_phone(PID,Phone) VALUES (606,8625541607);
INSERT INTO passenger_phone(PID,Phone) VALUES (317,2279589636);
INSERT INTO passenger_phone(PID,Phone) VALUES (873,5900478443);
INSERT INTO passenger_phone(PID,Phone) VALUES (423,2987035733);
INSERT INTO passenger_phone(PID,Phone) VALUES (127,5677935605);
INSERT INTO passenger_phone(PID,Phone) VALUES (528,1854082114);
INSERT INTO passenger_phone(PID,Phone) VALUES (343,3458058545);
INSERT INTO passenger_phone(PID,Phone) VALUES (858,9974735909);
INSERT INTO passenger_phone(PID,Phone) VALUES (102,6133487644);
INSERT INTO passenger_phone(PID,Phone) VALUES (772,3341509806);
INSERT INTO passenger_phone(PID,Phone) VALUES (589,8324932131);
INSERT INTO passenger_phone(PID,Phone) VALUES (41,5803168162);
INSERT INTO passenger_phone(PID,Phone) VALUES (964,2756943925);
INSERT INTO passenger_phone(PID,Phone) VALUES (435,0164977768);
INSERT INTO passenger_phone(PID,Phone) VALUES (409,0108905316);
INSERT INTO passenger_phone(PID,Phone) VALUES (865,4860744112);
INSERT INTO passenger_phone(PID,Phone) VALUES (149,2265630047);
INSERT INTO passenger_phone(PID,Phone) VALUES (57,9611947262);
INSERT INTO passenger_phone(PID,Phone) VALUES (40,5835167452);
INSERT INTO passenger_phone(PID,Phone) VALUES (650,1790225658);
INSERT INTO passenger_phone(PID,Phone) VALUES (254,1840860627);
INSERT INTO passenger_phone(PID,Phone) VALUES (262,1339219478);
INSERT INTO passenger_phone(PID,Phone) VALUES (912,1498748527);
INSERT INTO passenger_phone(PID,Phone) VALUES (579,0391286002);
INSERT INTO passenger_phone(PID,Phone) VALUES (173,9533618233);
INSERT INTO passenger_phone(PID,Phone) VALUES (29,0050938853);
INSERT INTO passenger_phone(PID,Phone) VALUES (443,6054042833);
INSERT INTO passenger_phone(PID,Phone) VALUES (782,4128358709);
INSERT INTO passenger_phone(PID,Phone) VALUES (238,7070473947);
INSERT INTO passenger_phone(PID,Phone) VALUES (357,2324181658);
INSERT INTO passenger_phone(PID,Phone) VALUES (465,4923709407);
INSERT INTO passenger_phone(PID,Phone) VALUES (596,0355992345);
INSERT INTO passenger_phone(PID,Phone) VALUES (120,1946541580);
INSERT INTO passenger_phone(PID,Phone) VALUES (631,2512178974);
INSERT INTO passenger_phone(PID,Phone) VALUES (808,1308162781);
INSERT INTO passenger_phone(PID,Phone) VALUES (615,4922087648);
INSERT INTO passenger_phone(PID,Phone) VALUES (24,5977342648);
INSERT INTO passenger_phone(PID,Phone) VALUES (851,0885725616);
INSERT INTO passenger_phone(PID,Phone) VALUES (333,0803128248);
INSERT INTO passenger_phone(PID,Phone) VALUES (733,8128647187);
INSERT INTO passenger_phone(PID,Phone) VALUES (866,4796685378);
INSERT INTO passenger_phone(PID,Phone) VALUES (825,4017123443);
INSERT INTO passenger_phone(PID,Phone) VALUES (402,1019064851);
INSERT INTO passenger_phone(PID,Phone) VALUES (379,8741749730);
INSERT INTO passenger_phone(PID,Phone) VALUES (243,9381654532);
INSERT INTO passenger_phone(PID,Phone) VALUES (559,4439935059);
INSERT INTO passenger_phone(PID,Phone) VALUES (589,4461514444);
INSERT INTO passenger_phone(PID,Phone) VALUES (978,7474386848);
INSERT INTO passenger_phone(PID,Phone) VALUES (679,7295548763);
INSERT INTO passenger_phone(PID,Phone) VALUES (646,0135714000);
INSERT INTO passenger_phone(PID,Phone) VALUES (601,2727770599);
INSERT INTO passenger_phone(PID,Phone) VALUES (455,0895955777);
INSERT INTO passenger_phone(PID,Phone) VALUES (603,0214247502);
INSERT INTO passenger_phone(PID,Phone) VALUES (236,1789526723);
INSERT INTO passenger_phone(PID,Phone) VALUES (302,9708553888);
INSERT INTO passenger_phone(PID,Phone) VALUES (110,5842752971);
INSERT INTO passenger_phone(PID,Phone) VALUES (388,8847368001);
INSERT INTO passenger_phone(PID,Phone) VALUES (765,2030973266);
INSERT INTO passenger_phone(PID,Phone) VALUES (598,9322057164);
INSERT INTO passenger_phone(PID,Phone) VALUES (60,6166506624);
INSERT INTO passenger_phone(PID,Phone) VALUES (935,9037419537);
INSERT INTO passenger_phone(PID,Phone) VALUES (665,0225404530);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,9564184967);
INSERT INTO passenger_phone(PID,Phone) VALUES (111,1272866447);
INSERT INTO passenger_phone(PID,Phone) VALUES (355,5656802065);
INSERT INTO passenger_phone(PID,Phone) VALUES (111,7518756397);
INSERT INTO passenger_phone(PID,Phone) VALUES (303,8941316179);
INSERT INTO passenger_phone(PID,Phone) VALUES (857,1767864025);
INSERT INTO passenger_phone(PID,Phone) VALUES (326,5954323090);
INSERT INTO passenger_phone(PID,Phone) VALUES (834,3183374748);
INSERT INTO passenger_phone(PID,Phone) VALUES (805,1956311351);
INSERT INTO passenger_phone(PID,Phone) VALUES (217,2021638110);
INSERT INTO passenger_phone(PID,Phone) VALUES (450,4385871243);
INSERT INTO passenger_phone(PID,Phone) VALUES (420,2241550108);
INSERT INTO passenger_phone(PID,Phone) VALUES (196,5357661899);
INSERT INTO passenger_phone(PID,Phone) VALUES (190,2808261165);
INSERT INTO passenger_phone(PID,Phone) VALUES (530,5447445928);
INSERT INTO passenger_phone(PID,Phone) VALUES (288,3213839481);
INSERT INTO passenger_phone(PID,Phone) VALUES (760,1168703456);
INSERT INTO passenger_phone(PID,Phone) VALUES (136,2627360568);
INSERT INTO passenger_phone(PID,Phone) VALUES (55,1576581376);
INSERT INTO passenger_phone(PID,Phone) VALUES (772,4061794617);
INSERT INTO passenger_phone(PID,Phone) VALUES (766,1729229674);
INSERT INTO passenger_phone(PID,Phone) VALUES (125,9607873117);
INSERT INTO passenger_phone(PID,Phone) VALUES (408,3433340768);
INSERT INTO passenger_phone(PID,Phone) VALUES (397,8141264855);
INSERT INTO passenger_phone(PID,Phone) VALUES (673,8388339673);
INSERT INTO passenger_phone(PID,Phone) VALUES (618,0355085470);
INSERT INTO passenger_phone(PID,Phone) VALUES (378,7658735879);
INSERT INTO passenger_phone(PID,Phone) VALUES (606,4970236970);
INSERT INTO passenger_phone(PID,Phone) VALUES (592,1038509480);
INSERT INTO passenger_phone(PID,Phone) VALUES (295,7485669505);
INSERT INTO passenger_phone(PID,Phone) VALUES (974,4646304636);
INSERT INTO passenger_phone(PID,Phone) VALUES (591,8327113459);
INSERT INTO passenger_phone(PID,Phone) VALUES (83,1199519993);
INSERT INTO passenger_phone(PID,Phone) VALUES (906,8648437111);
INSERT INTO passenger_phone(PID,Phone) VALUES (802,7953261377);
INSERT INTO passenger_phone(PID,Phone) VALUES (578,5311736678);
INSERT INTO passenger_phone(PID,Phone) VALUES (734,4951921688);
INSERT INTO passenger_phone(PID,Phone) VALUES (775,7365056284);
INSERT INTO passenger_phone(PID,Phone) VALUES (959,7800215459);
INSERT INTO passenger_phone(PID,Phone) VALUES (442,7324710294);
INSERT INTO passenger_phone(PID,Phone) VALUES (967,3249311953);
INSERT INTO passenger_phone(PID,Phone) VALUES (904,7550652551);
INSERT INTO passenger_phone(PID,Phone) VALUES (863,6699759730);
INSERT INTO passenger_phone(PID,Phone) VALUES (558,4017142648);
INSERT INTO passenger_phone(PID,Phone) VALUES (1000,9338028167);
INSERT INTO passenger_phone(PID,Phone) VALUES (274,3872251393);
INSERT INTO passenger_phone(PID,Phone) VALUES (162,6949349071);
INSERT INTO passenger_phone(PID,Phone) VALUES (431,4907209882);
INSERT INTO passenger_phone(PID,Phone) VALUES (335,3670542044);
INSERT INTO passenger_phone(PID,Phone) VALUES (390,7980079057);
INSERT INTO passenger_phone(PID,Phone) VALUES (395,4356755364);
INSERT INTO passenger_phone(PID,Phone) VALUES (277,0522119838);
INSERT INTO passenger_phone(PID,Phone) VALUES (500,4334601834);
INSERT INTO passenger_phone(PID,Phone) VALUES (720,8944257959);
INSERT INTO passenger_phone(PID,Phone) VALUES (921,3419745418);
INSERT INTO passenger_phone(PID,Phone) VALUES (858,1402126978);
INSERT INTO passenger_phone(PID,Phone) VALUES (514,6045182335);
INSERT INTO passenger_phone(PID,Phone) VALUES (997,8087963049);
INSERT INTO passenger_phone(PID,Phone) VALUES (252,0808504866);
INSERT INTO passenger_phone(PID,Phone) VALUES (213,5807251804);
INSERT INTO passenger_phone(PID,Phone) VALUES (689,0091895297);
INSERT INTO passenger_phone(PID,Phone) VALUES (667,5525948209);
INSERT INTO passenger_phone(PID,Phone) VALUES (30,8203664215);
INSERT INTO passenger_phone(PID,Phone) VALUES (363,7827062972);
INSERT INTO passenger_phone(PID,Phone) VALUES (11,7462646152);
INSERT INTO passenger_phone(PID,Phone) VALUES (391,2706166599);
INSERT INTO passenger_phone(PID,Phone) VALUES (330,4125788798);
INSERT INTO passenger_phone(PID,Phone) VALUES (636,5960021666);
INSERT INTO passenger_phone(PID,Phone) VALUES (185,1671666447);
INSERT INTO passenger_phone(PID,Phone) VALUES (420,0931539135);
INSERT INTO passenger_phone(PID,Phone) VALUES (132,3831589415);
INSERT INTO passenger_phone(PID,Phone) VALUES (421,2349174094);
INSERT INTO passenger_phone(PID,Phone) VALUES (725,1716751303);
INSERT INTO passenger_phone(PID,Phone) VALUES (939,6887947606);
INSERT INTO passenger_phone(PID,Phone) VALUES (23,8106185778);
INSERT INTO passenger_phone(PID,Phone) VALUES (808,0862595950);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,5382327189);
INSERT INTO passenger_phone(PID,Phone) VALUES (659,5321164470);
INSERT INTO passenger_phone(PID,Phone) VALUES (680,4341779352);
INSERT INTO passenger_phone(PID,Phone) VALUES (181,1848562192);
INSERT INTO passenger_phone(PID,Phone) VALUES (521,4211681508);
INSERT INTO passenger_phone(PID,Phone) VALUES (494,9124236290);
INSERT INTO passenger_phone(PID,Phone) VALUES (981,7137615261);
INSERT INTO passenger_phone(PID,Phone) VALUES (322,0072038101);
INSERT INTO passenger_phone(PID,Phone) VALUES (681,1946395353);
INSERT INTO passenger_phone(PID,Phone) VALUES (146,4366981637);
INSERT INTO passenger_phone(PID,Phone) VALUES (218,2875024410);
INSERT INTO passenger_phone(PID,Phone) VALUES (603,2533276083);
INSERT INTO passenger_phone(PID,Phone) VALUES (419,1997066347);
INSERT INTO passenger_phone(PID,Phone) VALUES (88,5047983338);
INSERT INTO passenger_phone(PID,Phone) VALUES (79,4756560192);
INSERT INTO passenger_phone(PID,Phone) VALUES (586,8524255454);
INSERT INTO passenger_phone(PID,Phone) VALUES (873,5554824192);
INSERT INTO passenger_phone(PID,Phone) VALUES (387,1553766030);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,6332100718);
INSERT INTO passenger_phone(PID,Phone) VALUES (730,8372660480);
INSERT INTO passenger_phone(PID,Phone) VALUES (759,5984068646);
INSERT INTO passenger_phone(PID,Phone) VALUES (925,7597318384);
INSERT INTO passenger_phone(PID,Phone) VALUES (672,8036716405);
INSERT INTO passenger_phone(PID,Phone) VALUES (397,3922057799);
INSERT INTO passenger_phone(PID,Phone) VALUES (897,8386771358);
INSERT INTO passenger_phone(PID,Phone) VALUES (635,8323444452);
INSERT INTO passenger_phone(PID,Phone) VALUES (76,4437463879);
INSERT INTO passenger_phone(PID,Phone) VALUES (570,7394097284);
INSERT INTO passenger_phone(PID,Phone) VALUES (334,4807633981);
INSERT INTO passenger_phone(PID,Phone) VALUES (452,5034378708);
INSERT INTO passenger_phone(PID,Phone) VALUES (630,0379028543);
INSERT INTO passenger_phone(PID,Phone) VALUES (181,5538117645);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,4179166586);
INSERT INTO passenger_phone(PID,Phone) VALUES (323,8997748189);
INSERT INTO passenger_phone(PID,Phone) VALUES (248,8743767136);
INSERT INTO passenger_phone(PID,Phone) VALUES (660,2615463325);
INSERT INTO passenger_phone(PID,Phone) VALUES (46,2634561469);
INSERT INTO passenger_phone(PID,Phone) VALUES (449,7814026669);
INSERT INTO passenger_phone(PID,Phone) VALUES (132,3396914260);
INSERT INTO passenger_phone(PID,Phone) VALUES (48,3130735414);
INSERT INTO passenger_phone(PID,Phone) VALUES (189,9377608156);
INSERT INTO passenger_phone(PID,Phone) VALUES (305,6516408666);
INSERT INTO passenger_phone(PID,Phone) VALUES (593,8770438079);
INSERT INTO passenger_phone(PID,Phone) VALUES (506,5503146850);
INSERT INTO passenger_phone(PID,Phone) VALUES (256,2899378680);
INSERT INTO passenger_phone(PID,Phone) VALUES (769,4173779627);
INSERT INTO passenger_phone(PID,Phone) VALUES (635,4194804088);
INSERT INTO passenger_phone(PID,Phone) VALUES (374,1999136175);
INSERT INTO passenger_phone(PID,Phone) VALUES (720,9397982506);
INSERT INTO passenger_phone(PID,Phone) VALUES (751,0690803963);
INSERT INTO passenger_phone(PID,Phone) VALUES (167,8186941387);
INSERT INTO passenger_phone(PID,Phone) VALUES (796,5651610519);
INSERT INTO passenger_phone(PID,Phone) VALUES (950,5727361857);
INSERT INTO passenger_phone(PID,Phone) VALUES (243,9254644676);
INSERT INTO passenger_phone(PID,Phone) VALUES (494,2993609903);
INSERT INTO passenger_phone(PID,Phone) VALUES (285,2819260019);
INSERT INTO passenger_phone(PID,Phone) VALUES (254,3024001687);
INSERT INTO passenger_phone(PID,Phone) VALUES (348,0209609405);
INSERT INTO passenger_phone(PID,Phone) VALUES (378,9122570951);
INSERT INTO passenger_phone(PID,Phone) VALUES (282,7776432321);
INSERT INTO passenger_phone(PID,Phone) VALUES (892,8668987886);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,4152846068);
INSERT INTO passenger_phone(PID,Phone) VALUES (887,0597398589);
INSERT INTO passenger_phone(PID,Phone) VALUES (592,6077580110);
INSERT INTO passenger_phone(PID,Phone) VALUES (496,5564623686);
INSERT INTO passenger_phone(PID,Phone) VALUES (469,4492610208);
INSERT INTO passenger_phone(PID,Phone) VALUES (580,1861515087);
INSERT INTO passenger_phone(PID,Phone) VALUES (867,5154252282);
INSERT INTO passenger_phone(PID,Phone) VALUES (802,3125557477);
INSERT INTO passenger_phone(PID,Phone) VALUES (742,2224598093);
INSERT INTO passenger_phone(PID,Phone) VALUES (935,9068798535);
INSERT INTO passenger_phone(PID,Phone) VALUES (502,5433631607);
INSERT INTO passenger_phone(PID,Phone) VALUES (215,2055571830);
INSERT INTO passenger_phone(PID,Phone) VALUES (14,0753984174);
INSERT INTO passenger_phone(PID,Phone) VALUES (121,9423995888);
INSERT INTO passenger_phone(PID,Phone) VALUES (154,5649947964);
INSERT INTO passenger_phone(PID,Phone) VALUES (565,9353197448);
INSERT INTO passenger_phone(PID,Phone) VALUES (245,6849166730);
INSERT INTO passenger_phone(PID,Phone) VALUES (94,2565408250);
INSERT INTO passenger_phone(PID,Phone) VALUES (705,2731529215);
INSERT INTO passenger_phone(PID,Phone) VALUES (47,1298888505);
INSERT INTO passenger_phone(PID,Phone) VALUES (690,9500058822);
INSERT INTO passenger_phone(PID,Phone) VALUES (920,7337863455);
INSERT INTO passenger_phone(PID,Phone) VALUES (502,0168791977);
INSERT INTO passenger_phone(PID,Phone) VALUES (947,8905101916);
INSERT INTO passenger_phone(PID,Phone) VALUES (127,9752590531);
INSERT INTO passenger_phone(PID,Phone) VALUES (3,6784945292);
INSERT INTO passenger_phone(PID,Phone) VALUES (802,1926601547);
INSERT INTO passenger_phone(PID,Phone) VALUES (503,4656326971);
INSERT INTO passenger_phone(PID,Phone) VALUES (635,6941738538);
INSERT INTO passenger_phone(PID,Phone) VALUES (25,0909595736);
INSERT INTO passenger_phone(PID,Phone) VALUES (384,5669597656);
INSERT INTO passenger_phone(PID,Phone) VALUES (747,4972796715);
INSERT INTO passenger_phone(PID,Phone) VALUES (848,1791348025);
INSERT INTO passenger_phone(PID,Phone) VALUES (812,0147844741);
INSERT INTO passenger_phone(PID,Phone) VALUES (495,4916641522);
INSERT INTO passenger_phone(PID,Phone) VALUES (671,3882318877);
INSERT INTO passenger_phone(PID,Phone) VALUES (229,3989999674);
INSERT INTO passenger_phone(PID,Phone) VALUES (194,2326781114);
INSERT INTO passenger_phone(PID,Phone) VALUES (922,3592464042);
INSERT INTO passenger_phone(PID,Phone) VALUES (289,4366421136);
INSERT INTO passenger_phone(PID,Phone) VALUES (581,3595159588);
INSERT INTO passenger_phone(PID,Phone) VALUES (338,1205114775);
INSERT INTO passenger_phone(PID,Phone) VALUES (732,7527708321);
INSERT INTO passenger_phone(PID,Phone) VALUES (291,7523351793);
INSERT INTO passenger_phone(PID,Phone) VALUES (811,1628317467);
INSERT INTO passenger_phone(PID,Phone) VALUES (94,3295096211);
INSERT INTO passenger_phone(PID,Phone) VALUES (855,0072382743);
INSERT INTO passenger_phone(PID,Phone) VALUES (891,3788907883);
INSERT INTO passenger_phone(PID,Phone) VALUES (952,8056472935);
INSERT INTO passenger_phone(PID,Phone) VALUES (322,6933780239);
INSERT INTO passenger_phone(PID,Phone) VALUES (35,9027345114);
INSERT INTO passenger_phone(PID,Phone) VALUES (204,0740881956);
INSERT INTO passenger_phone(PID,Phone) VALUES (110,3175066332);
INSERT INTO passenger_phone(PID,Phone) VALUES (671,3744087391);
INSERT INTO passenger_phone(PID,Phone) VALUES (952,8470100774);
INSERT INTO passenger_phone(PID,Phone) VALUES (25,9458814695);
INSERT INTO passenger_phone(PID,Phone) VALUES (516,1482168670);
INSERT INTO passenger_phone(PID,Phone) VALUES (650,1559443277);
INSERT INTO passenger_phone(PID,Phone) VALUES (300,8425319165);
INSERT INTO passenger_phone(PID,Phone) VALUES (761,7147469767);
INSERT INTO passenger_phone(PID,Phone) VALUES (268,5466772762);
INSERT INTO passenger_phone(PID,Phone) VALUES (955,1735095595);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,2741292142);
INSERT INTO passenger_phone(PID,Phone) VALUES (922,8202113064);
INSERT INTO passenger_phone(PID,Phone) VALUES (404,6007509807);
INSERT INTO passenger_phone(PID,Phone) VALUES (543,2871737362);
INSERT INTO passenger_phone(PID,Phone) VALUES (675,9822806946);
INSERT INTO passenger_phone(PID,Phone) VALUES (936,4233476215);
INSERT INTO passenger_phone(PID,Phone) VALUES (469,2915583991);
INSERT INTO passenger_phone(PID,Phone) VALUES (224,3384978366);
INSERT INTO passenger_phone(PID,Phone) VALUES (754,1866194502);
INSERT INTO passenger_phone(PID,Phone) VALUES (945,2709385093);
INSERT INTO passenger_phone(PID,Phone) VALUES (648,4410054029);
INSERT INTO passenger_phone(PID,Phone) VALUES (260,6908720590);
INSERT INTO passenger_phone(PID,Phone) VALUES (459,1034203941);
INSERT INTO passenger_phone(PID,Phone) VALUES (760,7131085645);
INSERT INTO passenger_phone(PID,Phone) VALUES (22,0114599817);
INSERT INTO passenger_phone(PID,Phone) VALUES (362,3177962415);
INSERT INTO passenger_phone(PID,Phone) VALUES (70,5523107606);
INSERT INTO passenger_phone(PID,Phone) VALUES (439,4223042432);
INSERT INTO passenger_phone(PID,Phone) VALUES (398,0779860378);
INSERT INTO passenger_phone(PID,Phone) VALUES (18,2605344198);
INSERT INTO passenger_phone(PID,Phone) VALUES (610,7685457883);
INSERT INTO passenger_phone(PID,Phone) VALUES (521,1846574526);
INSERT INTO passenger_phone(PID,Phone) VALUES (54,9644743340);
INSERT INTO passenger_phone(PID,Phone) VALUES (902,8588492689);
INSERT INTO passenger_phone(PID,Phone) VALUES (465,8640089685);
INSERT INTO passenger_phone(PID,Phone) VALUES (957,9991565888);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,5228806277);
INSERT INTO passenger_phone(PID,Phone) VALUES (289,5563788704);
INSERT INTO passenger_phone(PID,Phone) VALUES (255,8789998864);
INSERT INTO passenger_phone(PID,Phone) VALUES (364,1538288544);
INSERT INTO passenger_phone(PID,Phone) VALUES (873,5797236002);
INSERT INTO passenger_phone(PID,Phone) VALUES (772,2220394559);
INSERT INTO passenger_phone(PID,Phone) VALUES (158,7935009368);
INSERT INTO passenger_phone(PID,Phone) VALUES (887,8332692943);
INSERT INTO passenger_phone(PID,Phone) VALUES (735,3890872063);
INSERT INTO passenger_phone(PID,Phone) VALUES (508,6663186756);
INSERT INTO passenger_phone(PID,Phone) VALUES (554,7567103572);
INSERT INTO passenger_phone(PID,Phone) VALUES (846,6997282183);
INSERT INTO passenger_phone(PID,Phone) VALUES (378,4555157462);
INSERT INTO passenger_phone(PID,Phone) VALUES (269,9086472665);
INSERT INTO passenger_phone(PID,Phone) VALUES (256,8049079380);
INSERT INTO passenger_phone(PID,Phone) VALUES (75,1785333664);
INSERT INTO passenger_phone(PID,Phone) VALUES (115,9467973588);
INSERT INTO passenger_phone(PID,Phone) VALUES (964,2978527995);
INSERT INTO passenger_phone(PID,Phone) VALUES (624,3788854044);
INSERT INTO passenger_phone(PID,Phone) VALUES (921,7164118863);
INSERT INTO passenger_phone(PID,Phone) VALUES (446,6312818711);
INSERT INTO passenger_phone(PID,Phone) VALUES (593,6291568468);
INSERT INTO passenger_phone(PID,Phone) VALUES (678,0914263141);
INSERT INTO passenger_phone(PID,Phone) VALUES (175,7773674813);
INSERT INTO passenger_phone(PID,Phone) VALUES (820,7134899992);
INSERT INTO passenger_phone(PID,Phone) VALUES (558,6036928942);
INSERT INTO passenger_phone(PID,Phone) VALUES (679,9817828175);
INSERT INTO passenger_phone(PID,Phone) VALUES (88,9457016125);
INSERT INTO passenger_phone(PID,Phone) VALUES (585,1658549415);
INSERT INTO passenger_phone(PID,Phone) VALUES (337,0631700139);
INSERT INTO passenger_phone(PID,Phone) VALUES (521,4532968996);
INSERT INTO passenger_phone(PID,Phone) VALUES (708,8626578728);
INSERT INTO passenger_phone(PID,Phone) VALUES (662,0865677827);
INSERT INTO passenger_phone(PID,Phone) VALUES (733,2345951602);
INSERT INTO passenger_phone(PID,Phone) VALUES (122,6256097276);
INSERT INTO passenger_phone(PID,Phone) VALUES (680,7728907047);
INSERT INTO passenger_phone(PID,Phone) VALUES (639,2428939157);
INSERT INTO passenger_phone(PID,Phone) VALUES (73,0462058158);
INSERT INTO passenger_phone(PID,Phone) VALUES (997,4404704479);
INSERT INTO passenger_phone(PID,Phone) VALUES (392,1804331544);
INSERT INTO passenger_phone(PID,Phone) VALUES (604,9151562191);
INSERT INTO passenger_phone(PID,Phone) VALUES (197,5318152549);
INSERT INTO passenger_phone(PID,Phone) VALUES (16,7111599329);
INSERT INTO passenger_phone(PID,Phone) VALUES (977,8385715961);
INSERT INTO passenger_phone(PID,Phone) VALUES (459,6608490124);
INSERT INTO passenger_phone(PID,Phone) VALUES (26,7792673024);
INSERT INTO passenger_phone(PID,Phone) VALUES (764,3937356845);
INSERT INTO passenger_phone(PID,Phone) VALUES (894,8421559417);
INSERT INTO passenger_phone(PID,Phone) VALUES (871,8681765009);
INSERT INTO passenger_phone(PID,Phone) VALUES (366,5987933604);
INSERT INTO passenger_phone(PID,Phone) VALUES (735,6383034181);
INSERT INTO passenger_phone(PID,Phone) VALUES (365,5518716222);
INSERT INTO passenger_phone(PID,Phone) VALUES (128,9250543979);
INSERT INTO passenger_phone(PID,Phone) VALUES (807,3117986635);
INSERT INTO passenger_phone(PID,Phone) VALUES (323,5924603484);
INSERT INTO passenger_phone(PID,Phone) VALUES (105,9345122296);
INSERT INTO passenger_phone(PID,Phone) VALUES (60,3046749381);
INSERT INTO passenger_phone(PID,Phone) VALUES (968,9863776024);
INSERT INTO passenger_phone(PID,Phone) VALUES (995,6981801167);
INSERT INTO passenger_phone(PID,Phone) VALUES (767,2960393088);
INSERT INTO passenger_phone(PID,Phone) VALUES (109,5558198068);
INSERT INTO passenger_phone(PID,Phone) VALUES (830,7826755141);
INSERT INTO passenger_phone(PID,Phone) VALUES (28,5027168112);
INSERT INTO passenger_phone(PID,Phone) VALUES (51,1707800320);
INSERT INTO passenger_phone(PID,Phone) VALUES (36,4971507236);
INSERT INTO passenger_phone(PID,Phone) VALUES (855,8895616867);
INSERT INTO passenger_phone(PID,Phone) VALUES (365,9546977515);
INSERT INTO passenger_phone(PID,Phone) VALUES (552,8358720214);
INSERT INTO passenger_phone(PID,Phone) VALUES (920,2389482629);
INSERT INTO passenger_phone(PID,Phone) VALUES (664,5348531803);
INSERT INTO passenger_phone(PID,Phone) VALUES (883,0977561202);
INSERT INTO passenger_phone(PID,Phone) VALUES (545,7258734750);
INSERT INTO passenger_phone(PID,Phone) VALUES (359,4793953915);
INSERT INTO passenger_phone(PID,Phone) VALUES (871,2133266315);
INSERT INTO passenger_phone(PID,Phone) VALUES (804,8109722594);
INSERT INTO passenger_phone(PID,Phone) VALUES (837,2437843436);
INSERT INTO passenger_phone(PID,Phone) VALUES (555,7257650983);
INSERT INTO passenger_phone(PID,Phone) VALUES (410,4181517118);
INSERT INTO passenger_phone(PID,Phone) VALUES (398,4791490653);
INSERT INTO passenger_phone(PID,Phone) VALUES (750,4497556391);
INSERT INTO passenger_phone(PID,Phone) VALUES (255,3809696883);
INSERT INTO passenger_phone(PID,Phone) VALUES (716,1026042170);
INSERT INTO passenger_phone(PID,Phone) VALUES (584,2623055781);
INSERT INTO passenger_phone(PID,Phone) VALUES (554,5787697690);
INSERT INTO passenger_phone(PID,Phone) VALUES (427,8904667113);
INSERT INTO passenger_phone(PID,Phone) VALUES (248,5056369027);
INSERT INTO passenger_phone(PID,Phone) VALUES (858,5811190689);
INSERT INTO passenger_phone(PID,Phone) VALUES (53,1353120193);
INSERT INTO passenger_phone(PID,Phone) VALUES (126,9780743111);
INSERT INTO passenger_phone(PID,Phone) VALUES (631,8731950082);
INSERT INTO passenger_phone(PID,Phone) VALUES (904,6014315573);
INSERT INTO passenger_phone(PID,Phone) VALUES (902,8625205543);
INSERT INTO passenger_phone(PID,Phone) VALUES (964,7254958717);
INSERT INTO passenger_phone(PID,Phone) VALUES (95,9257798880);
INSERT INTO passenger_phone(PID,Phone) VALUES (406,4993852315);
INSERT INTO passenger_phone(PID,Phone) VALUES (643,7366550329);
INSERT INTO passenger_phone(PID,Phone) VALUES (994,4888063659);
INSERT INTO passenger_phone(PID,Phone) VALUES (943,0935766474);
INSERT INTO passenger_phone(PID,Phone) VALUES (127,2817434379);
INSERT INTO passenger_phone(PID,Phone) VALUES (329,9747316637);
INSERT INTO passenger_phone(PID,Phone) VALUES (315,0461900699);
INSERT INTO passenger_phone(PID,Phone) VALUES (96,4381707375);
INSERT INTO passenger_phone(PID,Phone) VALUES (776,6838281463);
INSERT INTO passenger_phone(PID,Phone) VALUES (243,2191008794);
INSERT INTO passenger_phone(PID,Phone) VALUES (447,1237689475);
INSERT INTO passenger_phone(PID,Phone) VALUES (773,3684177722);
INSERT INTO passenger_phone(PID,Phone) VALUES (539,0338302397);
INSERT INTO passenger_phone(PID,Phone) VALUES (153,8379064087);
INSERT INTO passenger_phone(PID,Phone) VALUES (180,8331460293);
INSERT INTO passenger_phone(PID,Phone) VALUES (820,7154616579);
INSERT INTO passenger_phone(PID,Phone) VALUES (455,8679382878);
INSERT INTO passenger_phone(PID,Phone) VALUES (969,5661523971);
INSERT INTO passenger_phone(PID,Phone) VALUES (396,7566851127);
INSERT INTO passenger_phone(PID,Phone) VALUES (193,1277023922);
INSERT INTO passenger_phone(PID,Phone) VALUES (615,0872023463);
INSERT INTO passenger_phone(PID,Phone) VALUES (275,6733223743);
INSERT INTO passenger_phone(PID,Phone) VALUES (661,9491614216);
INSERT INTO passenger_phone(PID,Phone) VALUES (226,5687136533);
INSERT INTO passenger_phone(PID,Phone) VALUES (93,1694177691);
INSERT INTO passenger_phone(PID,Phone) VALUES (209,9175119821);
INSERT INTO passenger_phone(PID,Phone) VALUES (96,7934309749);
INSERT INTO passenger_phone(PID,Phone) VALUES (125,9493300711);
INSERT INTO passenger_phone(PID,Phone) VALUES (371,6659874036);
INSERT INTO passenger_phone(PID,Phone) VALUES (908,9013866614);
INSERT INTO passenger_phone(PID,Phone) VALUES (840,3337924056);
INSERT INTO passenger_phone(PID,Phone) VALUES (921,1783714124);
INSERT INTO passenger_phone(PID,Phone) VALUES (734,7234893902);
INSERT INTO passenger_phone(PID,Phone) VALUES (752,4437846155);
INSERT INTO passenger_phone(PID,Phone) VALUES (245,6713467635);
INSERT INTO passenger_phone(PID,Phone) VALUES (706,2229786008);
INSERT INTO passenger_phone(PID,Phone) VALUES (396,7744511536);
INSERT INTO passenger_phone(PID,Phone) VALUES (471,4042423821);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,5389981217);
INSERT INTO passenger_phone(PID,Phone) VALUES (505,9422963098);
INSERT INTO passenger_phone(PID,Phone) VALUES (623,1617023960);
INSERT INTO passenger_phone(PID,Phone) VALUES (657,8432970334);
INSERT INTO passenger_phone(PID,Phone) VALUES (269,5793738233);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,2350609975);
INSERT INTO passenger_phone(PID,Phone) VALUES (511,5941483949);
INSERT INTO passenger_phone(PID,Phone) VALUES (656,4598065264);
INSERT INTO passenger_phone(PID,Phone) VALUES (800,8392635712);
INSERT INTO passenger_phone(PID,Phone) VALUES (989,0983781899);
INSERT INTO passenger_phone(PID,Phone) VALUES (589,2037120406);
INSERT INTO passenger_phone(PID,Phone) VALUES (561,2492588331);
INSERT INTO passenger_phone(PID,Phone) VALUES (956,1022803903);
INSERT INTO passenger_phone(PID,Phone) VALUES (769,6541580989);
INSERT INTO passenger_phone(PID,Phone) VALUES (447,5736187829);
INSERT INTO passenger_phone(PID,Phone) VALUES (453,4774921830);
INSERT INTO passenger_phone(PID,Phone) VALUES (89,3750127733);
INSERT INTO passenger_phone(PID,Phone) VALUES (125,9733517558);
INSERT INTO passenger_phone(PID,Phone) VALUES (495,7456746274);
INSERT INTO passenger_phone(PID,Phone) VALUES (150,8952320938);
INSERT INTO passenger_phone(PID,Phone) VALUES (73,3558600637);
INSERT INTO passenger_phone(PID,Phone) VALUES (168,5252478573);
INSERT INTO passenger_phone(PID,Phone) VALUES (963,8134255824);
INSERT INTO passenger_phone(PID,Phone) VALUES (5,0235552118);
INSERT INTO passenger_phone(PID,Phone) VALUES (207,8516243841);
INSERT INTO passenger_phone(PID,Phone) VALUES (582,3160158073);
INSERT INTO passenger_phone(PID,Phone) VALUES (623,7068598245);
INSERT INTO passenger_phone(PID,Phone) VALUES (868,6727067093);
INSERT INTO passenger_phone(PID,Phone) VALUES (225,8739393809);
INSERT INTO passenger_phone(PID,Phone) VALUES (472,6527144184);
INSERT INTO passenger_phone(PID,Phone) VALUES (472,5088177605);
INSERT INTO passenger_phone(PID,Phone) VALUES (443,7480128549);
INSERT INTO passenger_phone(PID,Phone) VALUES (657,5146545547);
INSERT INTO passenger_phone(PID,Phone) VALUES (940,0737365136);
INSERT INTO passenger_phone(PID,Phone) VALUES (777,3839847160);
INSERT INTO passenger_phone(PID,Phone) VALUES (911,4286170820);
INSERT INTO passenger_phone(PID,Phone) VALUES (888,3132279407);
INSERT INTO passenger_phone(PID,Phone) VALUES (294,9534928163);
INSERT INTO passenger_phone(PID,Phone) VALUES (99,5530086078);
INSERT INTO passenger_phone(PID,Phone) VALUES (50,3273389202);
INSERT INTO passenger_phone(PID,Phone) VALUES (731,5876546613);
INSERT INTO passenger_phone(PID,Phone) VALUES (351,6490356630);
INSERT INTO passenger_phone(PID,Phone) VALUES (444,3496697166);
INSERT INTO passenger_phone(PID,Phone) VALUES (278,0669793946);
INSERT INTO passenger_phone(PID,Phone) VALUES (1000,3788129102);
INSERT INTO passenger_phone(PID,Phone) VALUES (639,4300012693);
INSERT INTO passenger_phone(PID,Phone) VALUES (944,3026583826);
INSERT INTO passenger_phone(PID,Phone) VALUES (504,1721580152);
INSERT INTO passenger_phone(PID,Phone) VALUES (988,4267412568);
INSERT INTO passenger_phone(PID,Phone) VALUES (391,3214765846);
INSERT INTO passenger_phone(PID,Phone) VALUES (227,5308277158);
INSERT INTO passenger_phone(PID,Phone) VALUES (590,0978327092);
INSERT INTO passenger_phone(PID,Phone) VALUES (241,8853689499);
INSERT INTO passenger_phone(PID,Phone) VALUES (671,2677794450);
INSERT INTO passenger_phone(PID,Phone) VALUES (963,9920923837);
INSERT INTO passenger_phone(PID,Phone) VALUES (957,6731252322);
INSERT INTO passenger_phone(PID,Phone) VALUES (358,1531030700);
INSERT INTO passenger_phone(PID,Phone) VALUES (655,9708748001);
INSERT INTO passenger_phone(PID,Phone) VALUES (753,0238010026);
INSERT INTO passenger_phone(PID,Phone) VALUES (858,1195848851);
INSERT INTO passenger_phone(PID,Phone) VALUES (308,4917314981);
INSERT INTO passenger_phone(PID,Phone) VALUES (683,1667403683);
INSERT INTO passenger_phone(PID,Phone) VALUES (822,1075203218);
INSERT INTO passenger_phone(PID,Phone) VALUES (581,2077941215);
INSERT INTO passenger_phone(PID,Phone) VALUES (687,3685306724);
INSERT INTO passenger_phone(PID,Phone) VALUES (951,7391028277);
INSERT INTO passenger_phone(PID,Phone) VALUES (826,7962900665);
INSERT INTO passenger_phone(PID,Phone) VALUES (739,1949083159);
INSERT INTO passenger_phone(PID,Phone) VALUES (739,2665865180);
INSERT INTO passenger_phone(PID,Phone) VALUES (376,0080088290);
INSERT INTO passenger_phone(PID,Phone) VALUES (909,5220898929);
INSERT INTO passenger_phone(PID,Phone) VALUES (788,7728806230);
INSERT INTO passenger_phone(PID,Phone) VALUES (949,1119336562);
INSERT INTO passenger_phone(PID,Phone) VALUES (470,3783467017);
INSERT INTO passenger_phone(PID,Phone) VALUES (506,4612263071);
INSERT INTO passenger_phone(PID,Phone) VALUES (81,9628931059);
INSERT INTO passenger_phone(PID,Phone) VALUES (743,8175772977);
INSERT INTO passenger_phone(PID,Phone) VALUES (687,1844576424);
INSERT INTO passenger_phone(PID,Phone) VALUES (118,7354492104);
INSERT INTO passenger_phone(PID,Phone) VALUES (82,7856963455);
INSERT INTO passenger_phone(PID,Phone) VALUES (313,9623267488);
INSERT INTO passenger_phone(PID,Phone) VALUES (457,8992496545);
INSERT INTO passenger_phone(PID,Phone) VALUES (491,8725000964);
INSERT INTO passenger_phone(PID,Phone) VALUES (739,5456864840);
INSERT INTO passenger_phone(PID,Phone) VALUES (727,6483835436);
INSERT INTO passenger_phone(PID,Phone) VALUES (142,9130985932);
INSERT INTO passenger_phone(PID,Phone) VALUES (295,8012308169);
INSERT INTO passenger_phone(PID,Phone) VALUES (931,9643140804);
INSERT INTO passenger_phone(PID,Phone) VALUES (126,3227096224);
INSERT INTO passenger_phone(PID,Phone) VALUES (181,1658129895);
INSERT INTO passenger_phone(PID,Phone) VALUES (865,9811353221);
INSERT INTO passenger_phone(PID,Phone) VALUES (910,6216469765);
INSERT INTO passenger_phone(PID,Phone) VALUES (680,0657475006);
INSERT INTO passenger_phone(PID,Phone) VALUES (621,8068721287);
INSERT INTO passenger_phone(PID,Phone) VALUES (655,3271436269);
INSERT INTO passenger_phone(PID,Phone) VALUES (530,7250755779);
INSERT INTO passenger_phone(PID,Phone) VALUES (601,6193493557);
INSERT INTO passenger_phone(PID,Phone) VALUES (858,7427547877);
INSERT INTO passenger_phone(PID,Phone) VALUES (360,4241276580);
INSERT INTO passenger_phone(PID,Phone) VALUES (730,4906507200);
INSERT INTO passenger_phone(PID,Phone) VALUES (841,1193200981);
INSERT INTO passenger_phone(PID,Phone) VALUES (666,1830219077);
INSERT INTO passenger_phone(PID,Phone) VALUES (90,2489664315);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,5462350506);
INSERT INTO passenger_phone(PID,Phone) VALUES (290,1948891237);
INSERT INTO passenger_phone(PID,Phone) VALUES (786,1651332771);
INSERT INTO passenger_phone(PID,Phone) VALUES (162,6429793525);
INSERT INTO passenger_phone(PID,Phone) VALUES (891,6678576015);
INSERT INTO passenger_phone(PID,Phone) VALUES (723,4776656255);
INSERT INTO passenger_phone(PID,Phone) VALUES (629,6154847364);
INSERT INTO passenger_phone(PID,Phone) VALUES (224,0712178380);
INSERT INTO passenger_phone(PID,Phone) VALUES (723,0976953393);
INSERT INTO passenger_phone(PID,Phone) VALUES (184,4690615362);
INSERT INTO passenger_phone(PID,Phone) VALUES (321,2441566892);
INSERT INTO passenger_phone(PID,Phone) VALUES (271,0409275813);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,9890929036);
INSERT INTO passenger_phone(PID,Phone) VALUES (718,0416486608);
INSERT INTO passenger_phone(PID,Phone) VALUES (736,0543704026);
INSERT INTO passenger_phone(PID,Phone) VALUES (987,8178490954);
INSERT INTO passenger_phone(PID,Phone) VALUES (117,0284366491);
INSERT INTO passenger_phone(PID,Phone) VALUES (662,3940345619);
INSERT INTO passenger_phone(PID,Phone) VALUES (131,2421353527);
INSERT INTO passenger_phone(PID,Phone) VALUES (836,8777697516);
INSERT INTO passenger_phone(PID,Phone) VALUES (295,4971887594);
INSERT INTO passenger_phone(PID,Phone) VALUES (137,8593985970);
INSERT INTO passenger_phone(PID,Phone) VALUES (682,0995723645);
INSERT INTO passenger_phone(PID,Phone) VALUES (541,8456368729);
INSERT INTO passenger_phone(PID,Phone) VALUES (361,3484684696);
INSERT INTO passenger_phone(PID,Phone) VALUES (147,7201166179);
INSERT INTO passenger_phone(PID,Phone) VALUES (823,7242788590);
INSERT INTO passenger_phone(PID,Phone) VALUES (524,1639805147);
INSERT INTO passenger_phone(PID,Phone) VALUES (74,0935072404);
INSERT INTO passenger_phone(PID,Phone) VALUES (152,2150663634);
INSERT INTO passenger_phone(PID,Phone) VALUES (236,0671163125);
INSERT INTO passenger_phone(PID,Phone) VALUES (497,7104535444);
INSERT INTO passenger_phone(PID,Phone) VALUES (170,3159709464);
INSERT INTO passenger_phone(PID,Phone) VALUES (565,5704732386);
INSERT INTO passenger_phone(PID,Phone) VALUES (238,7498292727);
INSERT INTO passenger_phone(PID,Phone) VALUES (984,4206937129);
INSERT INTO passenger_phone(PID,Phone) VALUES (523,3538965263);
INSERT INTO passenger_phone(PID,Phone) VALUES (333,4103792740);
INSERT INTO passenger_phone(PID,Phone) VALUES (218,7139482727);
INSERT INTO passenger_phone(PID,Phone) VALUES (344,9126569983);
INSERT INTO passenger_phone(PID,Phone) VALUES (136,5485282495);
INSERT INTO passenger_phone(PID,Phone) VALUES (561,4005965397);
INSERT INTO passenger_phone(PID,Phone) VALUES (595,0426496578);
INSERT INTO passenger_phone(PID,Phone) VALUES (404,9646901809);
INSERT INTO passenger_phone(PID,Phone) VALUES (734,6118905058);
INSERT INTO passenger_phone(PID,Phone) VALUES (497,9623424626);
INSERT INTO passenger_phone(PID,Phone) VALUES (524,4279907750);
INSERT INTO passenger_phone(PID,Phone) VALUES (184,3233461035);
INSERT INTO passenger_phone(PID,Phone) VALUES (380,0174517957);
INSERT INTO passenger_phone(PID,Phone) VALUES (823,5013642623);
INSERT INTO passenger_phone(PID,Phone) VALUES (887,5313939605);
INSERT INTO passenger_phone(PID,Phone) VALUES (504,6392849106);
INSERT INTO passenger_phone(PID,Phone) VALUES (842,5647273985);
INSERT INTO passenger_phone(PID,Phone) VALUES (681,1796302060);
INSERT INTO passenger_phone(PID,Phone) VALUES (294,0656807391);
INSERT INTO passenger_phone(PID,Phone) VALUES (545,0970909009);
INSERT INTO passenger_phone(PID,Phone) VALUES (62,6719042259);
INSERT INTO passenger_phone(PID,Phone) VALUES (124,2013323964);
INSERT INTO passenger_phone(PID,Phone) VALUES (216,0995826084);
INSERT INTO passenger_phone(PID,Phone) VALUES (346,3796213269);
INSERT INTO passenger_phone(PID,Phone) VALUES (55,0911986424);
INSERT INTO passenger_phone(PID,Phone) VALUES (381,4112962086);
INSERT INTO passenger_phone(PID,Phone) VALUES (150,3741271122);
INSERT INTO passenger_phone(PID,Phone) VALUES (796,9283072017);
INSERT INTO passenger_phone(PID,Phone) VALUES (372,4760339629);
INSERT INTO passenger_phone(PID,Phone) VALUES (933,4076008216);
INSERT INTO passenger_phone(PID,Phone) VALUES (649,5491882933);
INSERT INTO passenger_phone(PID,Phone) VALUES (578,2736710570);
INSERT INTO passenger_phone(PID,Phone) VALUES (374,3044236622);
INSERT INTO passenger_phone(PID,Phone) VALUES (275,0881296808);
INSERT INTO passenger_phone(PID,Phone) VALUES (956,3510429032);
INSERT INTO passenger_phone(PID,Phone) VALUES (917,3261256087);
INSERT INTO passenger_phone(PID,Phone) VALUES (391,2281005329);
INSERT INTO passenger_phone(PID,Phone) VALUES (32,3864559713);
INSERT INTO passenger_phone(PID,Phone) VALUES (711,0120951589);
INSERT INTO passenger_phone(PID,Phone) VALUES (866,9771458902);
INSERT INTO passenger_phone(PID,Phone) VALUES (285,8095824109);
INSERT INTO passenger_phone(PID,Phone) VALUES (973,8429875026);
INSERT INTO passenger_phone(PID,Phone) VALUES (311,7005313267);
INSERT INTO passenger_phone(PID,Phone) VALUES (198,4398249195);
INSERT INTO passenger_phone(PID,Phone) VALUES (815,7326172179);
INSERT INTO passenger_phone(PID,Phone) VALUES (869,8284311668);
INSERT INTO passenger_phone(PID,Phone) VALUES (893,2070101126);
INSERT INTO passenger_phone(PID,Phone) VALUES (562,5887808164);
INSERT INTO passenger_phone(PID,Phone) VALUES (2,4123095951);
INSERT INTO passenger_phone(PID,Phone) VALUES (170,1081351885);
INSERT INTO passenger_phone(PID,Phone) VALUES (820,4485759538);
INSERT INTO passenger_phone(PID,Phone) VALUES (155,8764811202);
INSERT INTO passenger_phone(PID,Phone) VALUES (732,5600243465);
INSERT INTO passenger_phone(PID,Phone) VALUES (743,2599293614);
INSERT INTO passenger_phone(PID,Phone) VALUES (340,7790577174);
INSERT INTO passenger_phone(PID,Phone) VALUES (41,3526422840);
INSERT INTO passenger_phone(PID,Phone) VALUES (334,3347203900);
INSERT INTO passenger_phone(PID,Phone) VALUES (107,9712625046);
INSERT INTO passenger_phone(PID,Phone) VALUES (777,2228606922);
INSERT INTO passenger_phone(PID,Phone) VALUES (650,9686592254);
INSERT INTO passenger_phone(PID,Phone) VALUES (861,9954541396);
INSERT INTO passenger_phone(PID,Phone) VALUES (486,8941064648);
INSERT INTO passenger_phone(PID,Phone) VALUES (98,5285134181);
INSERT INTO passenger_phone(PID,Phone) VALUES (105,4574441330);
INSERT INTO passenger_phone(PID,Phone) VALUES (526,4082592843);
INSERT INTO passenger_phone(PID,Phone) VALUES (462,2522501356);
INSERT INTO passenger_phone(PID,Phone) VALUES (296,8296505397);
INSERT INTO passenger_phone(PID,Phone) VALUES (452,6208812851);
INSERT INTO passenger_phone(PID,Phone) VALUES (701,2103823920);
INSERT INTO passenger_phone(PID,Phone) VALUES (661,8297826419);
INSERT INTO passenger_phone(PID,Phone) VALUES (461,9050315202);
INSERT INTO passenger_phone(PID,Phone) VALUES (573,5879274879);
INSERT INTO passenger_phone(PID,Phone) VALUES (65,5228093859);
INSERT INTO passenger_phone(PID,Phone) VALUES (482,8810641172);
INSERT INTO passenger_phone(PID,Phone) VALUES (829,8272535562);
INSERT INTO passenger_phone(PID,Phone) VALUES (432,2606460942);
INSERT INTO passenger_phone(PID,Phone) VALUES (863,9051413915);
INSERT INTO passenger_phone(PID,Phone) VALUES (332,8740484904);
INSERT INTO passenger_phone(PID,Phone) VALUES (156,1834245815);
INSERT INTO passenger_phone(PID,Phone) VALUES (366,7032984824);
INSERT INTO passenger_phone(PID,Phone) VALUES (551,1601355276);
INSERT INTO passenger_phone(PID,Phone) VALUES (368,0810643592);
INSERT INTO passenger_phone(PID,Phone) VALUES (264,0831175388);
INSERT INTO passenger_phone(PID,Phone) VALUES (491,8498992632);
INSERT INTO passenger_phone(PID,Phone) VALUES (555,2146861274);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,0407515318);
INSERT INTO passenger_phone(PID,Phone) VALUES (788,6008999096);
INSERT INTO passenger_phone(PID,Phone) VALUES (738,3884933993);
INSERT INTO passenger_phone(PID,Phone) VALUES (617,0117616886);
INSERT INTO passenger_phone(PID,Phone) VALUES (922,0398626438);
INSERT INTO passenger_phone(PID,Phone) VALUES (191,3955169620);
INSERT INTO passenger_phone(PID,Phone) VALUES (54,2173421669);
INSERT INTO passenger_phone(PID,Phone) VALUES (638,6558754350);
INSERT INTO passenger_phone(PID,Phone) VALUES (411,4465035725);
INSERT INTO passenger_phone(PID,Phone) VALUES (56,8995843724);
INSERT INTO passenger_phone(PID,Phone) VALUES (708,0658827873);
INSERT INTO passenger_phone(PID,Phone) VALUES (900,9436972622);
INSERT INTO passenger_phone(PID,Phone) VALUES (298,0009734215);
INSERT INTO passenger_phone(PID,Phone) VALUES (239,3067212829);
INSERT INTO passenger_phone(PID,Phone) VALUES (395,0721492286);
INSERT INTO passenger_phone(PID,Phone) VALUES (432,4159545624);
INSERT INTO passenger_phone(PID,Phone) VALUES (962,4569032752);
INSERT INTO passenger_phone(PID,Phone) VALUES (644,9026391300);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,4378640761);
INSERT INTO passenger_phone(PID,Phone) VALUES (523,3213007457);
INSERT INTO passenger_phone(PID,Phone) VALUES (446,5199111025);
INSERT INTO passenger_phone(PID,Phone) VALUES (654,1984932918);
INSERT INTO passenger_phone(PID,Phone) VALUES (45,8305706997);
INSERT INTO passenger_phone(PID,Phone) VALUES (153,7875151399);
INSERT INTO passenger_phone(PID,Phone) VALUES (680,3587739487);
INSERT INTO passenger_phone(PID,Phone) VALUES (53,8621613669);
INSERT INTO passenger_phone(PID,Phone) VALUES (111,4253709755);
INSERT INTO passenger_phone(PID,Phone) VALUES (260,5790822215);
INSERT INTO passenger_phone(PID,Phone) VALUES (631,3137364042);
INSERT INTO passenger_phone(PID,Phone) VALUES (778,4182849135);
INSERT INTO passenger_phone(PID,Phone) VALUES (489,7628049235);
INSERT INTO passenger_phone(PID,Phone) VALUES (788,0233334256);
INSERT INTO passenger_phone(PID,Phone) VALUES (702,3158479480);
INSERT INTO passenger_phone(PID,Phone) VALUES (520,5468346487);
INSERT INTO passenger_phone(PID,Phone) VALUES (844,3476605194);
INSERT INTO passenger_phone(PID,Phone) VALUES (57,2871878541);
INSERT INTO passenger_phone(PID,Phone) VALUES (491,4124919069);
INSERT INTO passenger_phone(PID,Phone) VALUES (84,3439819069);
INSERT INTO passenger_phone(PID,Phone) VALUES (91,3173971390);
INSERT INTO passenger_phone(PID,Phone) VALUES (89,4104082391);
INSERT INTO passenger_phone(PID,Phone) VALUES (405,4589914932);
INSERT INTO passenger_phone(PID,Phone) VALUES (541,9305927789);
INSERT INTO passenger_phone(PID,Phone) VALUES (671,9109100415);
INSERT INTO passenger_phone(PID,Phone) VALUES (351,9713101618);
INSERT INTO passenger_phone(PID,Phone) VALUES (251,5666869385);
INSERT INTO passenger_phone(PID,Phone) VALUES (717,9194563650);
INSERT INTO passenger_phone(PID,Phone) VALUES (748,5230896845);
INSERT INTO passenger_phone(PID,Phone) VALUES (43,9848064621);
INSERT INTO passenger_phone(PID,Phone) VALUES (789,8564518436);
INSERT INTO passenger_phone(PID,Phone) VALUES (185,8821944360);
INSERT INTO passenger_phone(PID,Phone) VALUES (453,0101520159);
INSERT INTO passenger_phone(PID,Phone) VALUES (913,8578490288);
INSERT INTO passenger_phone(PID,Phone) VALUES (630,6215389966);
INSERT INTO passenger_phone(PID,Phone) VALUES (94,6528726535);
INSERT INTO passenger_phone(PID,Phone) VALUES (834,8013128378);
INSERT INTO passenger_phone(PID,Phone) VALUES (47,1695665067);
INSERT INTO passenger_phone(PID,Phone) VALUES (95,3621051505);
INSERT INTO passenger_phone(PID,Phone) VALUES (29,0888841599);
INSERT INTO passenger_phone(PID,Phone) VALUES (353,6899840121);
INSERT INTO passenger_phone(PID,Phone) VALUES (82,0755567236);
INSERT INTO passenger_phone(PID,Phone) VALUES (450,9847049164);
INSERT INTO passenger_phone(PID,Phone) VALUES (62,5316667240);
INSERT INTO passenger_phone(PID,Phone) VALUES (563,6546941731);
INSERT INTO passenger_phone(PID,Phone) VALUES (325,8506122923);
INSERT INTO passenger_phone(PID,Phone) VALUES (972,3888516573);
INSERT INTO passenger_phone(PID,Phone) VALUES (14,5921994144);
INSERT INTO passenger_phone(PID,Phone) VALUES (995,0472502491);
INSERT INTO passenger_phone(PID,Phone) VALUES (538,4911128868);
INSERT INTO passenger_phone(PID,Phone) VALUES (766,4562383797);
INSERT INTO passenger_phone(PID,Phone) VALUES (869,4013755526);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,9823762406);
INSERT INTO passenger_phone(PID,Phone) VALUES (195,0120566667);
INSERT INTO passenger_phone(PID,Phone) VALUES (8,6644877458);
INSERT INTO passenger_phone(PID,Phone) VALUES (360,6416104929);
INSERT INTO passenger_phone(PID,Phone) VALUES (438,1129048255);
INSERT INTO passenger_phone(PID,Phone) VALUES (131,6362717183);
INSERT INTO passenger_phone(PID,Phone) VALUES (786,3024347173);
INSERT INTO passenger_phone(PID,Phone) VALUES (800,4851965276);
INSERT INTO passenger_phone(PID,Phone) VALUES (216,4867958636);
INSERT INTO passenger_phone(PID,Phone) VALUES (668,2300109694);
INSERT INTO passenger_phone(PID,Phone) VALUES (386,1203694342);
INSERT INTO passenger_phone(PID,Phone) VALUES (985,1256379385);
INSERT INTO passenger_phone(PID,Phone) VALUES (735,6222360631);
INSERT INTO passenger_phone(PID,Phone) VALUES (260,4555155684);
INSERT INTO passenger_phone(PID,Phone) VALUES (535,9096887294);
INSERT INTO passenger_phone(PID,Phone) VALUES (673,1202827544);
INSERT INTO passenger_phone(PID,Phone) VALUES (946,2989777744);
INSERT INTO passenger_phone(PID,Phone) VALUES (476,8828064651);
INSERT INTO passenger_phone(PID,Phone) VALUES (435,5648857150);
INSERT INTO passenger_phone(PID,Phone) VALUES (760,6080325182);
INSERT INTO passenger_phone(PID,Phone) VALUES (132,1430648325);
INSERT INTO passenger_phone(PID,Phone) VALUES (929,4456345130);
INSERT INTO passenger_phone(PID,Phone) VALUES (46,0397148623);
INSERT INTO passenger_phone(PID,Phone) VALUES (478,3613742720);
INSERT INTO passenger_phone(PID,Phone) VALUES (638,3603678874);
INSERT INTO passenger_phone(PID,Phone) VALUES (300,8901340945);
INSERT INTO passenger_phone(PID,Phone) VALUES (810,8228310067);
INSERT INTO passenger_phone(PID,Phone) VALUES (711,4159891135);
INSERT INTO passenger_phone(PID,Phone) VALUES (485,1681130221);
INSERT INTO passenger_phone(PID,Phone) VALUES (621,7729408920);
INSERT INTO passenger_phone(PID,Phone) VALUES (303,6446857537);
INSERT INTO passenger_phone(PID,Phone) VALUES (389,5732719162);
INSERT INTO passenger_phone(PID,Phone) VALUES (228,4983173960);
INSERT INTO passenger_phone(PID,Phone) VALUES (952,1340506766);
INSERT INTO passenger_phone(PID,Phone) VALUES (162,5541836794);
INSERT INTO passenger_phone(PID,Phone) VALUES (524,1379219584);
INSERT INTO passenger_phone(PID,Phone) VALUES (952,8369781882);
INSERT INTO passenger_phone(PID,Phone) VALUES (279,4560603345);
INSERT INTO passenger_phone(PID,Phone) VALUES (461,8399735388);
INSERT INTO passenger_phone(PID,Phone) VALUES (670,6264353125);
INSERT INTO passenger_phone(PID,Phone) VALUES (47,3087432683);
INSERT INTO passenger_phone(PID,Phone) VALUES (416,3949622389);
INSERT INTO passenger_phone(PID,Phone) VALUES (335,4592510099);
INSERT INTO passenger_phone(PID,Phone) VALUES (681,6259586092);
INSERT INTO passenger_phone(PID,Phone) VALUES (163,9860120393);
INSERT INTO passenger_phone(PID,Phone) VALUES (745,6814447183);
INSERT INTO passenger_phone(PID,Phone) VALUES (337,7989771865);
INSERT INTO passenger_phone(PID,Phone) VALUES (267,0849420112);
INSERT INTO passenger_phone(PID,Phone) VALUES (223,3578590576);
INSERT INTO passenger_phone(PID,Phone) VALUES (987,0772279349);
INSERT INTO passenger_phone(PID,Phone) VALUES (583,4991746534);
INSERT INTO passenger_phone(PID,Phone) VALUES (831,2915394553);
INSERT INTO passenger_phone(PID,Phone) VALUES (699,9265584637);
INSERT INTO passenger_phone(PID,Phone) VALUES (54,5715573995);
INSERT INTO passenger_phone(PID,Phone) VALUES (552,8043681642);
INSERT INTO passenger_phone(PID,Phone) VALUES (844,9294189991);
INSERT INTO passenger_phone(PID,Phone) VALUES (251,7130588251);
INSERT INTO passenger_phone(PID,Phone) VALUES (904,1036719724);
INSERT INTO passenger_phone(PID,Phone) VALUES (215,7927882025);
INSERT INTO passenger_phone(PID,Phone) VALUES (559,4249705602);
INSERT INTO passenger_phone(PID,Phone) VALUES (523,0246905808);
INSERT INTO passenger_phone(PID,Phone) VALUES (342,3782358341);
INSERT INTO passenger_phone(PID,Phone) VALUES (670,2723335785);
INSERT INTO passenger_phone(PID,Phone) VALUES (577,4086524404);
INSERT INTO passenger_phone(PID,Phone) VALUES (263,1841245311);
INSERT INTO passenger_phone(PID,Phone) VALUES (748,8717857577);
INSERT INTO passenger_phone(PID,Phone) VALUES (555,0055327591);
INSERT INTO passenger_phone(PID,Phone) VALUES (390,1932403847);
INSERT INTO passenger_phone(PID,Phone) VALUES (135,5226097059);
INSERT INTO passenger_phone(PID,Phone) VALUES (918,7420163283);
INSERT INTO passenger_phone(PID,Phone) VALUES (731,9501082864);
INSERT INTO passenger_phone(PID,Phone) VALUES (582,5708830710);
INSERT INTO passenger_phone(PID,Phone) VALUES (167,0701086690);
INSERT INTO passenger_phone(PID,Phone) VALUES (368,2103410899);
INSERT INTO passenger_phone(PID,Phone) VALUES (362,9975039300);
INSERT INTO passenger_phone(PID,Phone) VALUES (612,8731219718);
INSERT INTO passenger_phone(PID,Phone) VALUES (351,3736225544);
INSERT INTO passenger_phone(PID,Phone) VALUES (553,0604561618);
INSERT INTO passenger_phone(PID,Phone) VALUES (647,6513724125);
INSERT INTO passenger_phone(PID,Phone) VALUES (785,3311749071);
INSERT INTO passenger_phone(PID,Phone) VALUES (857,1526280909);
INSERT INTO passenger_phone(PID,Phone) VALUES (929,5081372325);
INSERT INTO passenger_phone(PID,Phone) VALUES (697,4546904401);
INSERT INTO passenger_phone(PID,Phone) VALUES (21,7710123092);
INSERT INTO passenger_phone(PID,Phone) VALUES (109,3838338101);
INSERT INTO passenger_phone(PID,Phone) VALUES (145,3361501456);
INSERT INTO passenger_phone(PID,Phone) VALUES (34,3770037848);
INSERT INTO passenger_phone(PID,Phone) VALUES (44,4582189316);
INSERT INTO passenger_phone(PID,Phone) VALUES (689,9257758081);
INSERT INTO passenger_phone(PID,Phone) VALUES (589,7695262992);
INSERT INTO passenger_phone(PID,Phone) VALUES (114,9052115840);
INSERT INTO passenger_phone(PID,Phone) VALUES (447,9612762661);
INSERT INTO passenger_phone(PID,Phone) VALUES (486,1688128395);
INSERT INTO passenger_phone(PID,Phone) VALUES (717,9274000868);
INSERT INTO passenger_phone(PID,Phone) VALUES (378,8628932239);
INSERT INTO passenger_phone(PID,Phone) VALUES (237,8568823195);
INSERT INTO passenger_phone(PID,Phone) VALUES (25,6058485274);
INSERT INTO passenger_phone(PID,Phone) VALUES (292,7989814909);
INSERT INTO passenger_phone(PID,Phone) VALUES (874,4425133563);
INSERT INTO passenger_phone(PID,Phone) VALUES (656,0359297584);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,2288997861);
INSERT INTO passenger_phone(PID,Phone) VALUES (322,7144372481);
INSERT INTO passenger_phone(PID,Phone) VALUES (635,3099180127);
INSERT INTO passenger_phone(PID,Phone) VALUES (189,7784671753);
INSERT INTO passenger_phone(PID,Phone) VALUES (748,8995247924);
INSERT INTO passenger_phone(PID,Phone) VALUES (501,7122963423);
INSERT INTO passenger_phone(PID,Phone) VALUES (79,1324325708);
INSERT INTO passenger_phone(PID,Phone) VALUES (564,9719764704);
INSERT INTO passenger_phone(PID,Phone) VALUES (334,7822827079);
INSERT INTO passenger_phone(PID,Phone) VALUES (8,9576583700);
INSERT INTO passenger_phone(PID,Phone) VALUES (785,0578428944);
INSERT INTO passenger_phone(PID,Phone) VALUES (166,6149695594);
INSERT INTO passenger_phone(PID,Phone) VALUES (394,8156811097);
INSERT INTO passenger_phone(PID,Phone) VALUES (238,6216902857);
INSERT INTO passenger_phone(PID,Phone) VALUES (429,0436759846);
INSERT INTO passenger_phone(PID,Phone) VALUES (56,8948095724);
INSERT INTO passenger_phone(PID,Phone) VALUES (241,4123442909);
INSERT INTO passenger_phone(PID,Phone) VALUES (493,0971161350);
INSERT INTO passenger_phone(PID,Phone) VALUES (475,4352354889);
INSERT INTO passenger_phone(PID,Phone) VALUES (567,1150645893);
INSERT INTO passenger_phone(PID,Phone) VALUES (340,3891134764);
INSERT INTO passenger_phone(PID,Phone) VALUES (771,8723054295);
INSERT INTO passenger_phone(PID,Phone) VALUES (78,5726986048);
INSERT INTO passenger_phone(PID,Phone) VALUES (881,0830456003);
INSERT INTO passenger_phone(PID,Phone) VALUES (787,9290069611);
INSERT INTO passenger_phone(PID,Phone) VALUES (136,7290719150);
INSERT INTO passenger_phone(PID,Phone) VALUES (44,3633346392);
INSERT INTO passenger_phone(PID,Phone) VALUES (494,8398743870);
INSERT INTO passenger_phone(PID,Phone) VALUES (99,6433994422);
INSERT INTO passenger_phone(PID,Phone) VALUES (185,0198950143);
INSERT INTO passenger_phone(PID,Phone) VALUES (432,9885307556);
INSERT INTO passenger_phone(PID,Phone) VALUES (594,5813215756);
INSERT INTO passenger_phone(PID,Phone) VALUES (852,8799768220);
INSERT INTO passenger_phone(PID,Phone) VALUES (95,4127683838);
INSERT INTO passenger_phone(PID,Phone) VALUES (12,0474856389);
INSERT INTO passenger_phone(PID,Phone) VALUES (985,2714027360);
INSERT INTO passenger_phone(PID,Phone) VALUES (62,7436775243);
INSERT INTO passenger_phone(PID,Phone) VALUES (74,9235115574);
INSERT INTO passenger_phone(PID,Phone) VALUES (726,9505547946);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,6165944573);
INSERT INTO passenger_phone(PID,Phone) VALUES (797,7836201506);
INSERT INTO passenger_phone(PID,Phone) VALUES (489,0958631727);
INSERT INTO passenger_phone(PID,Phone) VALUES (330,1810691967);
INSERT INTO passenger_phone(PID,Phone) VALUES (699,6652222353);
INSERT INTO passenger_phone(PID,Phone) VALUES (771,7229460596);
INSERT INTO passenger_phone(PID,Phone) VALUES (418,1599845915);
INSERT INTO passenger_phone(PID,Phone) VALUES (143,1155054704);
INSERT INTO passenger_phone(PID,Phone) VALUES (829,5478996600);
INSERT INTO passenger_phone(PID,Phone) VALUES (711,4839464389);
INSERT INTO passenger_phone(PID,Phone) VALUES (727,7635374335);
INSERT INTO passenger_phone(PID,Phone) VALUES (810,5966353991);
INSERT INTO passenger_phone(PID,Phone) VALUES (383,9680896836);
INSERT INTO passenger_phone(PID,Phone) VALUES (733,7439879030);
INSERT INTO passenger_phone(PID,Phone) VALUES (170,1934534165);
INSERT INTO passenger_phone(PID,Phone) VALUES (520,0922796672);
INSERT INTO passenger_phone(PID,Phone) VALUES (258,8118861082);
INSERT INTO passenger_phone(PID,Phone) VALUES (767,9389453565);
INSERT INTO passenger_phone(PID,Phone) VALUES (208,6710092961);
INSERT INTO passenger_phone(PID,Phone) VALUES (648,0634627583);
INSERT INTO passenger_phone(PID,Phone) VALUES (134,3297865590);
INSERT INTO passenger_phone(PID,Phone) VALUES (553,6853871267);
INSERT INTO passenger_phone(PID,Phone) VALUES (62,9529447774);
INSERT INTO passenger_phone(PID,Phone) VALUES (139,6736051798);
INSERT INTO passenger_phone(PID,Phone) VALUES (450,8386584948);
INSERT INTO passenger_phone(PID,Phone) VALUES (852,8527322723);
INSERT INTO passenger_phone(PID,Phone) VALUES (853,0902905946);
INSERT INTO passenger_phone(PID,Phone) VALUES (16,5588098382);
INSERT INTO passenger_phone(PID,Phone) VALUES (458,1882258983);
INSERT INTO passenger_phone(PID,Phone) VALUES (493,9124276020);
INSERT INTO passenger_phone(PID,Phone) VALUES (371,6325878258);
INSERT INTO passenger_phone(PID,Phone) VALUES (860,2960225439);
INSERT INTO passenger_phone(PID,Phone) VALUES (927,1469120265);
INSERT INTO passenger_phone(PID,Phone) VALUES (798,2664401639);
INSERT INTO passenger_phone(PID,Phone) VALUES (358,3567309743);
INSERT INTO passenger_phone(PID,Phone) VALUES (612,8487196580);
INSERT INTO passenger_phone(PID,Phone) VALUES (750,7124193803);
INSERT INTO passenger_phone(PID,Phone) VALUES (707,3525865249);
INSERT INTO passenger_phone(PID,Phone) VALUES (516,8583147346);
INSERT INTO passenger_phone(PID,Phone) VALUES (313,0465137216);
INSERT INTO passenger_phone(PID,Phone) VALUES (886,8024857996);
INSERT INTO passenger_phone(PID,Phone) VALUES (703,6133962967);
INSERT INTO passenger_phone(PID,Phone) VALUES (832,2110056603);
INSERT INTO passenger_phone(PID,Phone) VALUES (801,0129657656);
INSERT INTO passenger_phone(PID,Phone) VALUES (55,4611085857);
INSERT INTO passenger_phone(PID,Phone) VALUES (965,4787835740);
INSERT INTO passenger_phone(PID,Phone) VALUES (272,5031136975);
INSERT INTO passenger_phone(PID,Phone) VALUES (158,9492192850);
INSERT INTO passenger_phone(PID,Phone) VALUES (218,3377657564);
INSERT INTO passenger_phone(PID,Phone) VALUES (192,3037839633);
INSERT INTO passenger_phone(PID,Phone) VALUES (225,5629047440);
INSERT INTO passenger_phone(PID,Phone) VALUES (463,8808178915);
INSERT INTO passenger_phone(PID,Phone) VALUES (582,4835945753);
INSERT INTO passenger_phone(PID,Phone) VALUES (83,1868873314);
INSERT INTO passenger_phone(PID,Phone) VALUES (367,0239244091);
INSERT INTO passenger_phone(PID,Phone) VALUES (905,5510277455);
INSERT INTO passenger_phone(PID,Phone) VALUES (19,8596202752);
INSERT INTO passenger_phone(PID,Phone) VALUES (359,8091179062);
INSERT INTO passenger_phone(PID,Phone) VALUES (235,6086257133);
INSERT INTO passenger_phone(PID,Phone) VALUES (112,7268825942);
INSERT INTO passenger_phone(PID,Phone) VALUES (926,4021433434);
INSERT INTO passenger_phone(PID,Phone) VALUES (522,1036902356);
INSERT INTO passenger_phone(PID,Phone) VALUES (530,4327173781);
INSERT INTO passenger_phone(PID,Phone) VALUES (747,0356260950);
INSERT INTO passenger_phone(PID,Phone) VALUES (615,7637018261);
INSERT INTO passenger_phone(PID,Phone) VALUES (631,6584366498);
INSERT INTO passenger_phone(PID,Phone) VALUES (2,9950846456);
INSERT INTO passenger_phone(PID,Phone) VALUES (760,2795455492);
INSERT INTO passenger_phone(PID,Phone) VALUES (760,8659298148);
INSERT INTO passenger_phone(PID,Phone) VALUES (908,5456796323);
INSERT INTO passenger_phone(PID,Phone) VALUES (762,5452272669);
INSERT INTO passenger_phone(PID,Phone) VALUES (991,1000409012);
INSERT INTO passenger_phone(PID,Phone) VALUES (407,5571687309);
INSERT INTO passenger_phone(PID,Phone) VALUES (995,7524825816);
INSERT INTO passenger_phone(PID,Phone) VALUES (891,8366555900);
INSERT INTO passenger_phone(PID,Phone) VALUES (859,1902470220);
INSERT INTO passenger_phone(PID,Phone) VALUES (682,8262014862);
INSERT INTO passenger_phone(PID,Phone) VALUES (312,9137699644);
INSERT INTO passenger_phone(PID,Phone) VALUES (476,5804840275);
INSERT INTO passenger_phone(PID,Phone) VALUES (257,9607486196);
INSERT INTO passenger_phone(PID,Phone) VALUES (993,7664047282);
INSERT INTO passenger_phone(PID,Phone) VALUES (43,0094406066);
INSERT INTO passenger_phone(PID,Phone) VALUES (94,4049284940);
INSERT INTO passenger_phone(PID,Phone) VALUES (997,5221773719);
INSERT INTO passenger_phone(PID,Phone) VALUES (156,2421294419);
INSERT INTO passenger_phone(PID,Phone) VALUES (910,3994155510);
INSERT INTO passenger_phone(PID,Phone) VALUES (408,3222258635);
INSERT INTO passenger_phone(PID,Phone) VALUES (381,0085348807);
INSERT INTO passenger_phone(PID,Phone) VALUES (248,9658106336);
INSERT INTO passenger_phone(PID,Phone) VALUES (533,0405212491);
INSERT INTO passenger_phone(PID,Phone) VALUES (678,0237117777);
INSERT INTO passenger_phone(PID,Phone) VALUES (98,5349375159);
INSERT INTO passenger_phone(PID,Phone) VALUES (894,3560214279);
INSERT INTO passenger_phone(PID,Phone) VALUES (744,3892431900);
INSERT INTO passenger_phone(PID,Phone) VALUES (815,3399642680);
INSERT INTO passenger_phone(PID,Phone) VALUES (168,3118416181);
INSERT INTO passenger_phone(PID,Phone) VALUES (708,7848011448);
INSERT INTO passenger_phone(PID,Phone) VALUES (210,8804077960);
INSERT INTO passenger_phone(PID,Phone) VALUES (47,3938182758);
INSERT INTO passenger_phone(PID,Phone) VALUES (798,9228689303);
INSERT INTO passenger_phone(PID,Phone) VALUES (688,2712253378);
INSERT INTO passenger_phone(PID,Phone) VALUES (4,5685209349);
INSERT INTO passenger_phone(PID,Phone) VALUES (352,9914184668);
INSERT INTO passenger_phone(PID,Phone) VALUES (305,9954001840);
INSERT INTO passenger_phone(PID,Phone) VALUES (91,8797042642);
INSERT INTO passenger_phone(PID,Phone) VALUES (118,6932789350);
INSERT INTO passenger_phone(PID,Phone) VALUES (266,2643828838);
INSERT INTO passenger_phone(PID,Phone) VALUES (60,7832043648);
INSERT INTO passenger_phone(PID,Phone) VALUES (420,0945678403);
INSERT INTO passenger_phone(PID,Phone) VALUES (961,8802683357);
INSERT INTO passenger_phone(PID,Phone) VALUES (787,4017936644);
INSERT INTO passenger_phone(PID,Phone) VALUES (584,0471212545);
INSERT INTO passenger_phone(PID,Phone) VALUES (495,1610792641);
INSERT INTO passenger_phone(PID,Phone) VALUES (328,1926447701);
INSERT INTO passenger_phone(PID,Phone) VALUES (172,6629314836);
INSERT INTO passenger_phone(PID,Phone) VALUES (542,2449463603);
INSERT INTO passenger_phone(PID,Phone) VALUES (670,5678681166);
INSERT INTO passenger_phone(PID,Phone) VALUES (29,2453493674);
INSERT INTO passenger_phone(PID,Phone) VALUES (674,2745546515);
INSERT INTO passenger_phone(PID,Phone) VALUES (232,1540858701);
INSERT INTO passenger_phone(PID,Phone) VALUES (213,3345302731);
INSERT INTO passenger_phone(PID,Phone) VALUES (535,3764132135);
INSERT INTO passenger_phone(PID,Phone) VALUES (521,4470321696);
INSERT INTO passenger_phone(PID,Phone) VALUES (714,5178504112);
INSERT INTO passenger_phone(PID,Phone) VALUES (877,6209809213);
INSERT INTO passenger_phone(PID,Phone) VALUES (77,0561263625);
INSERT INTO passenger_phone(PID,Phone) VALUES (613,6742241002);
INSERT INTO passenger_phone(PID,Phone) VALUES (440,7414696435);
INSERT INTO passenger_phone(PID,Phone) VALUES (649,6328700440);
INSERT INTO passenger_phone(PID,Phone) VALUES (319,0571397600);
INSERT INTO passenger_phone(PID,Phone) VALUES (515,8451592057);
INSERT INTO passenger_phone(PID,Phone) VALUES (986,2489206910);
INSERT INTO passenger_phone(PID,Phone) VALUES (966,0785429597);
INSERT INTO passenger_phone(PID,Phone) VALUES (940,9408094334);
INSERT INTO passenger_phone(PID,Phone) VALUES (992,9478192151);
INSERT INTO passenger_phone(PID,Phone) VALUES (683,1806894722);
INSERT INTO passenger_phone(PID,Phone) VALUES (4,6950212126);
INSERT INTO passenger_phone(PID,Phone) VALUES (418,5372124683);
INSERT INTO passenger_phone(PID,Phone) VALUES (201,0933110088);
INSERT INTO passenger_phone(PID,Phone) VALUES (539,6062565296);
INSERT INTO passenger_phone(PID,Phone) VALUES (206,5315298893);
INSERT INTO passenger_phone(PID,Phone) VALUES (410,5817699300);
INSERT INTO passenger_phone(PID,Phone) VALUES (275,3210569185);
INSERT INTO passenger_phone(PID,Phone) VALUES (9,3864785044);
INSERT INTO passenger_phone(PID,Phone) VALUES (953,2135893363);
INSERT INTO passenger_phone(PID,Phone) VALUES (186,3696095495);
INSERT INTO passenger_phone(PID,Phone) VALUES (360,8670271065);
INSERT INTO passenger_phone(PID,Phone) VALUES (888,9881048337);
INSERT INTO passenger_phone(PID,Phone) VALUES (354,4002850787);
INSERT INTO passenger_phone(PID,Phone) VALUES (439,7757280761);
INSERT INTO passenger_phone(PID,Phone) VALUES (302,6587631165);
INSERT INTO passenger_phone(PID,Phone) VALUES (116,5059448873);
INSERT INTO passenger_phone(PID,Phone) VALUES (971,0614194977);
INSERT INTO passenger_phone(PID,Phone) VALUES (729,9181444901);
INSERT INTO passenger_phone(PID,Phone) VALUES (58,6421238028);
INSERT INTO passenger_phone(PID,Phone) VALUES (175,9122386883);
INSERT INTO passenger_phone(PID,Phone) VALUES (373,4855826314);
INSERT INTO passenger_phone(PID,Phone) VALUES (933,8743608534);
INSERT INTO passenger_phone(PID,Phone) VALUES (261,0530418617);
INSERT INTO passenger_phone(PID,Phone) VALUES (396,7704287185);
INSERT INTO passenger_phone(PID,Phone) VALUES (34,7808011473);
INSERT INTO passenger_phone(PID,Phone) VALUES (985,5891189083);
INSERT INTO passenger_phone(PID,Phone) VALUES (496,7899293754);
INSERT INTO passenger_phone(PID,Phone) VALUES (402,0146367025);
INSERT INTO passenger_phone(PID,Phone) VALUES (43,9402140472);
INSERT INTO passenger_phone(PID,Phone) VALUES (809,1948631557);
INSERT INTO passenger_phone(PID,Phone) VALUES (654,3419342469);
INSERT INTO passenger_phone(PID,Phone) VALUES (822,8684410156);
INSERT INTO passenger_phone(PID,Phone) VALUES (661,7905898218);
INSERT INTO passenger_phone(PID,Phone) VALUES (131,2785973551);
INSERT INTO passenger_phone(PID,Phone) VALUES (115,0529202592);
INSERT INTO passenger_phone(PID,Phone) VALUES (290,1365096831);
INSERT INTO passenger_phone(PID,Phone) VALUES (857,6510457568);
INSERT INTO passenger_phone(PID,Phone) VALUES (448,3844328509);
INSERT INTO passenger_phone(PID,Phone) VALUES (466,1116056317);
INSERT INTO passenger_phone(PID,Phone) VALUES (752,3960478904);
INSERT INTO passenger_phone(PID,Phone) VALUES (802,5269231254);
INSERT INTO passenger_phone(PID,Phone) VALUES (451,8284536632);
INSERT INTO passenger_phone(PID,Phone) VALUES (266,0668831513);
INSERT INTO passenger_phone(PID,Phone) VALUES (771,4620896991);
INSERT INTO passenger_phone(PID,Phone) VALUES (777,0109172455);
INSERT INTO passenger_phone(PID,Phone) VALUES (399,0659889417);
INSERT INTO passenger_phone(PID,Phone) VALUES (471,6681612215);
INSERT INTO passenger_phone(PID,Phone) VALUES (867,2735667754);
INSERT INTO passenger_phone(PID,Phone) VALUES (5,5082493962);
INSERT INTO passenger_phone(PID,Phone) VALUES (875,5606074425);
INSERT INTO passenger_phone(PID,Phone) VALUES (707,0238991585);
INSERT INTO passenger_phone(PID,Phone) VALUES (711,0202353078);
INSERT INTO passenger_phone(PID,Phone) VALUES (811,1002373106);
INSERT INTO passenger_phone(PID,Phone) VALUES (50,5026566823);
INSERT INTO passenger_phone(PID,Phone) VALUES (973,2065554611);
INSERT INTO passenger_phone(PID,Phone) VALUES (515,1937594323);
INSERT INTO passenger_phone(PID,Phone) VALUES (272,3330981633);
INSERT INTO passenger_phone(PID,Phone) VALUES (580,2972180902);
INSERT INTO passenger_phone(PID,Phone) VALUES (932,5601718340);
INSERT INTO passenger_phone(PID,Phone) VALUES (189,3004946421);
INSERT INTO passenger_phone(PID,Phone) VALUES (658,3587026633);
INSERT INTO passenger_phone(PID,Phone) VALUES (962,5240355941);
INSERT INTO passenger_phone(PID,Phone) VALUES (224,9048300310);
INSERT INTO passenger_phone(PID,Phone) VALUES (856,9715367806);
INSERT INTO passenger_phone(PID,Phone) VALUES (677,9546259285);
INSERT INTO passenger_phone(PID,Phone) VALUES (179,6611283895);
INSERT INTO passenger_phone(PID,Phone) VALUES (844,4280033858);
INSERT INTO passenger_phone(PID,Phone) VALUES (190,0258675560);
INSERT INTO passenger_phone(PID,Phone) VALUES (784,9468057677);
INSERT INTO passenger_phone(PID,Phone) VALUES (941,0140269647);
INSERT INTO passenger_phone(PID,Phone) VALUES (180,2573771517);
INSERT INTO passenger_phone(PID,Phone) VALUES (96,3972370237);
INSERT INTO passenger_phone(PID,Phone) VALUES (437,8705689243);
INSERT INTO passenger_phone(PID,Phone) VALUES (373,1147587112);
INSERT INTO passenger_phone(PID,Phone) VALUES (551,3761091209);
INSERT INTO passenger_phone(PID,Phone) VALUES (608,1409441045);
INSERT INTO passenger_phone(PID,Phone) VALUES (420,9434290311);
INSERT INTO passenger_phone(PID,Phone) VALUES (687,9175847726);
INSERT INTO passenger_phone(PID,Phone) VALUES (806,1249626401);
INSERT INTO passenger_phone(PID,Phone) VALUES (909,1599365841);
INSERT INTO passenger_phone(PID,Phone) VALUES (478,6812962220);
INSERT INTO passenger_phone(PID,Phone) VALUES (773,3908803012);
INSERT INTO passenger_phone(PID,Phone) VALUES (853,5505727340);
INSERT INTO passenger_phone(PID,Phone) VALUES (540,1239183506);
INSERT INTO passenger_phone(PID,Phone) VALUES (933,2214235389);
INSERT INTO passenger_phone(PID,Phone) VALUES (28,6534094720);
INSERT INTO passenger_phone(PID,Phone) VALUES (175,5198422891);
INSERT INTO passenger_phone(PID,Phone) VALUES (366,3754012100);
INSERT INTO passenger_phone(PID,Phone) VALUES (2,6482433400);
INSERT INTO passenger_phone(PID,Phone) VALUES (641,3984125972);
INSERT INTO passenger_phone(PID,Phone) VALUES (791,3291768856);
INSERT INTO passenger_phone(PID,Phone) VALUES (788,9746876375);
INSERT INTO passenger_phone(PID,Phone) VALUES (17,9627738308);
INSERT INTO passenger_phone(PID,Phone) VALUES (3,2221346164);
INSERT INTO passenger_phone(PID,Phone) VALUES (593,6973505456);
INSERT INTO passenger_phone(PID,Phone) VALUES (325,0080789955);
INSERT INTO passenger_phone(PID,Phone) VALUES (332,4789510415);
INSERT INTO passenger_phone(PID,Phone) VALUES (539,0109437140);
INSERT INTO passenger_phone(PID,Phone) VALUES (273,6335485997);
INSERT INTO passenger_phone(PID,Phone) VALUES (787,9476016034);
INSERT INTO passenger_phone(PID,Phone) VALUES (107,0288058229);
INSERT INTO passenger_phone(PID,Phone) VALUES (501,0042126224);
INSERT INTO passenger_phone(PID,Phone) VALUES (948,9539273135);
INSERT INTO passenger_phone(PID,Phone) VALUES (65,7928698631);
INSERT INTO passenger_phone(PID,Phone) VALUES (429,0355623068);
INSERT INTO passenger_phone(PID,Phone) VALUES (89,2604322415);
INSERT INTO passenger_phone(PID,Phone) VALUES (561,1234541686);
INSERT INTO passenger_phone(PID,Phone) VALUES (267,3779320868);
INSERT INTO passenger_phone(PID,Phone) VALUES (376,6249137392);
INSERT INTO passenger_phone(PID,Phone) VALUES (675,6394353347);
INSERT INTO passenger_phone(PID,Phone) VALUES (755,0622017389);
INSERT INTO passenger_phone(PID,Phone) VALUES (589,0482233513);
INSERT INTO passenger_phone(PID,Phone) VALUES (258,5715743362);
INSERT INTO passenger_phone(PID,Phone) VALUES (837,6498411456);
INSERT INTO passenger_phone(PID,Phone) VALUES (647,8665554781);
INSERT INTO passenger_phone(PID,Phone) VALUES (13,0198062470);
INSERT INTO passenger_phone(PID,Phone) VALUES (179,5646090323);
INSERT INTO passenger_phone(PID,Phone) VALUES (722,8235022455);
INSERT INTO passenger_phone(PID,Phone) VALUES (822,1359823038);
INSERT INTO passenger_phone(PID,Phone) VALUES (892,8720806253);
INSERT INTO passenger_phone(PID,Phone) VALUES (7,3082705820);
INSERT INTO passenger_phone(PID,Phone) VALUES (778,3050990670);
INSERT INTO passenger_phone(PID,Phone) VALUES (771,8295840302);
INSERT INTO passenger_phone(PID,Phone) VALUES (455,0716277550);
INSERT INTO passenger_phone(PID,Phone) VALUES (410,2339685741);
INSERT INTO passenger_phone(PID,Phone) VALUES (516,6216991246);
INSERT INTO passenger_phone(PID,Phone) VALUES (636,8250079309);
INSERT INTO passenger_phone(PID,Phone) VALUES (25,3985712223);
INSERT INTO passenger_phone(PID,Phone) VALUES (99,6862127606);
INSERT INTO passenger_phone(PID,Phone) VALUES (600,0782728647);
INSERT INTO passenger_phone(PID,Phone) VALUES (570,3088491253);
INSERT INTO passenger_phone(PID,Phone) VALUES (530,8209386178);
INSERT INTO passenger_phone(PID,Phone) VALUES (875,2170016768);
INSERT INTO passenger_phone(PID,Phone) VALUES (9,6637833393);
INSERT INTO passenger_phone(PID,Phone) VALUES (197,8457658846);
INSERT INTO passenger_phone(PID,Phone) VALUES (785,5986475811);
INSERT INTO passenger_phone(PID,Phone) VALUES (18,1544600772);
INSERT INTO passenger_phone(PID,Phone) VALUES (212,3662746291);
INSERT INTO passenger_phone(PID,Phone) VALUES (195,5499447941);
INSERT INTO passenger_phone(PID,Phone) VALUES (951,5626658932);
INSERT INTO passenger_phone(PID,Phone) VALUES (678,5876176150);
INSERT INTO passenger_phone(PID,Phone) VALUES (17,4307644506);
INSERT INTO passenger_phone(PID,Phone) VALUES (429,1404921368);
INSERT INTO passenger_phone(PID,Phone) VALUES (790,3953276876);
INSERT INTO passenger_phone(PID,Phone) VALUES (264,8991494263);
INSERT INTO passenger_phone(PID,Phone) VALUES (187,9647429597);
INSERT INTO passenger_phone(PID,Phone) VALUES (739,7997146657);
INSERT INTO passenger_phone(PID,Phone) VALUES (408,4486207518);
INSERT INTO passenger_phone(PID,Phone) VALUES (387,0468258270);
INSERT INTO passenger_phone(PID,Phone) VALUES (2,1246035214);
INSERT INTO passenger_phone(PID,Phone) VALUES (156,3823989986);
INSERT INTO passenger_phone(PID,Phone) VALUES (57,3849652626);
INSERT INTO passenger_phone(PID,Phone) VALUES (654,1821841006);
INSERT INTO passenger_phone(PID,Phone) VALUES (235,7098136312);
INSERT INTO passenger_phone(PID,Phone) VALUES (683,7359911333);
INSERT INTO passenger_phone(PID,Phone) VALUES (205,8537917928);
INSERT INTO passenger_phone(PID,Phone) VALUES (445,9085615479);
INSERT INTO passenger_phone(PID,Phone) VALUES (243,1663935676);
INSERT INTO passenger_phone(PID,Phone) VALUES (74,7847870230);
INSERT INTO passenger_phone(PID,Phone) VALUES (792,6809425440);
INSERT INTO passenger_phone(PID,Phone) VALUES (558,3628980221);
INSERT INTO passenger_phone(PID,Phone) VALUES (694,7968270048);
INSERT INTO passenger_phone(PID,Phone) VALUES (872,0866250629);
INSERT INTO passenger_phone(PID,Phone) VALUES (718,0487477163);
INSERT INTO passenger_phone(PID,Phone) VALUES (797,2939898381);
INSERT INTO passenger_phone(PID,Phone) VALUES (111,6200005981);
INSERT INTO passenger_phone(PID,Phone) VALUES (130,4252407645);
INSERT INTO passenger_phone(PID,Phone) VALUES (928,3458852849);
INSERT INTO passenger_phone(PID,Phone) VALUES (614,7803361419);
INSERT INTO passenger_phone(PID,Phone) VALUES (204,8990876742);
INSERT INTO passenger_phone(PID,Phone) VALUES (982,6585846831);
INSERT INTO passenger_phone(PID,Phone) VALUES (1,7439991219);
INSERT INTO passenger_phone(PID,Phone) VALUES (419,3873325545);
INSERT INTO passenger_phone(PID,Phone) VALUES (946,2646514176);
INSERT INTO passenger_phone(PID,Phone) VALUES (617,7502747332);
INSERT INTO passenger_phone(PID,Phone) VALUES (77,3586361857);
INSERT INTO passenger_phone(PID,Phone) VALUES (44,9377385580);
INSERT INTO passenger_phone(PID,Phone) VALUES (838,1548363409);
INSERT INTO passenger_phone(PID,Phone) VALUES (163,7190831554);
INSERT INTO passenger_phone(PID,Phone) VALUES (493,1373590671);
INSERT INTO passenger_phone(PID,Phone) VALUES (161,5919365270);
INSERT INTO passenger_phone(PID,Phone) VALUES (119,6657329658);
INSERT INTO passenger_phone(PID,Phone) VALUES (370,3651921006);
INSERT INTO passenger_phone(PID,Phone) VALUES (590,8789321782);
INSERT INTO passenger_phone(PID,Phone) VALUES (656,4961468925);
INSERT INTO passenger_phone(PID,Phone) VALUES (133,0795972069);
INSERT INTO passenger_phone(PID,Phone) VALUES (619,4592623264);
INSERT INTO passenger_phone(PID,Phone) VALUES (561,4219953460);
INSERT INTO passenger_phone(PID,Phone) VALUES (723,8948377049);
INSERT INTO passenger_phone(PID,Phone) VALUES (439,9930098009);
INSERT INTO passenger_phone(PID,Phone) VALUES (904,3365238096);
INSERT INTO passenger_phone(PID,Phone) VALUES (317,2314170881);
INSERT INTO passenger_phone(PID,Phone) VALUES (8,4499182765);
INSERT INTO passenger_phone(PID,Phone) VALUES (577,1009919859);
INSERT INTO passenger_phone(PID,Phone) VALUES (623,9487750040);
INSERT INTO passenger_phone(PID,Phone) VALUES (828,0009361868);
INSERT INTO passenger_phone(PID,Phone) VALUES (669,9666076929);
INSERT INTO passenger_phone(PID,Phone) VALUES (415,5379724455);
INSERT INTO passenger_phone(PID,Phone) VALUES (287,8875112708);
INSERT INTO passenger_phone(PID,Phone) VALUES (368,0075256247);
INSERT INTO passenger_phone(PID,Phone) VALUES (214,9519279757);
INSERT INTO passenger_phone(PID,Phone) VALUES (726,4756034822);
INSERT INTO passenger_phone(PID,Phone) VALUES (487,9440628843);
INSERT INTO passenger_phone(PID,Phone) VALUES (261,6342991755);
INSERT INTO passenger_phone(PID,Phone) VALUES (891,7509153930);
INSERT INTO passenger_phone(PID,Phone) VALUES (195,5783955947);
INSERT INTO passenger_phone(PID,Phone) VALUES (461,1483903002);
INSERT INTO passenger_phone(PID,Phone) VALUES (244,3625483855);
INSERT INTO passenger_phone(PID,Phone) VALUES (474,5516260007);
INSERT INTO passenger_phone(PID,Phone) VALUES (532,7612045888);
INSERT INTO passenger_phone(PID,Phone) VALUES (83,9028034990);
INSERT INTO passenger_phone(PID,Phone) VALUES (957,3363271719);
INSERT INTO passenger_phone(PID,Phone) VALUES (816,6430772475);
INSERT INTO passenger_phone(PID,Phone) VALUES (812,6880914196);
INSERT INTO passenger_phone(PID,Phone) VALUES (557,0674710093);
INSERT INTO passenger_phone(PID,Phone) VALUES (827,2524833709);
INSERT INTO passenger_phone(PID,Phone) VALUES (597,4405736782);
INSERT INTO passenger_phone(PID,Phone) VALUES (778,3682940050);
INSERT INTO passenger_phone(PID,Phone) VALUES (765,1252860412);
INSERT INTO passenger_phone(PID,Phone) VALUES (238,3645062791);
INSERT INTO passenger_phone(PID,Phone) VALUES (985,4171260284);
INSERT INTO passenger_phone(PID,Phone) VALUES (258,8621229307);
INSERT INTO passenger_phone(PID,Phone) VALUES (893,8454331704);
INSERT INTO passenger_phone(PID,Phone) VALUES (148,6175484523);
INSERT INTO passenger_phone(PID,Phone) VALUES (655,4062566291);
INSERT INTO passenger_phone(PID,Phone) VALUES (13,6492388857);
INSERT INTO passenger_phone(PID,Phone) VALUES (44,1648600322);
INSERT INTO passenger_phone(PID,Phone) VALUES (234,0229101157);
INSERT INTO passenger_phone(PID,Phone) VALUES (934,2549349856);
INSERT INTO passenger_phone(PID,Phone) VALUES (110,2639638344);
INSERT INTO passenger_phone(PID,Phone) VALUES (800,1038209122);
INSERT INTO passenger_phone(PID,Phone) VALUES (422,4737118470);
INSERT INTO passenger_phone(PID,Phone) VALUES (696,4302399388);
INSERT INTO passenger_phone(PID,Phone) VALUES (661,6866215622);
INSERT INTO passenger_phone(PID,Phone) VALUES (784,7549424999);
INSERT INTO passenger_phone(PID,Phone) VALUES (991,6358366132);
INSERT INTO passenger_phone(PID,Phone) VALUES (535,0220024664);
INSERT INTO passenger_phone(PID,Phone) VALUES (797,5235287847);
INSERT INTO passenger_phone(PID,Phone) VALUES (454,4026598383);
INSERT INTO passenger_phone(PID,Phone) VALUES (800,0932699858);
INSERT INTO passenger_phone(PID,Phone) VALUES (607,2725464880);
INSERT INTO passenger_phone(PID,Phone) VALUES (972,4517651824);
INSERT INTO passenger_phone(PID,Phone) VALUES (842,2685254811);
INSERT INTO passenger_phone(PID,Phone) VALUES (868,5156367937);
INSERT INTO passenger_phone(PID,Phone) VALUES (758,3222658240);
INSERT INTO passenger_phone(PID,Phone) VALUES (693,7531070908);
INSERT INTO passenger_phone(PID,Phone) VALUES (226,9930732763);
INSERT INTO passenger_phone(PID,Phone) VALUES (691,0165344730);
INSERT INTO passenger_phone(PID,Phone) VALUES (102,8827305250);
INSERT INTO passenger_phone(PID,Phone) VALUES (13,9993315253);
INSERT INTO passenger_phone(PID,Phone) VALUES (452,1408085140);
INSERT INTO passenger_phone(PID,Phone) VALUES (211,2903978772);
INSERT INTO passenger_phone(PID,Phone) VALUES (781,2410474820);
INSERT INTO passenger_phone(PID,Phone) VALUES (825,0892033875);
INSERT INTO passenger_phone(PID,Phone) VALUES (377,5602770720);
INSERT INTO passenger_phone(PID,Phone) VALUES (102,0746636119);
INSERT INTO passenger_phone(PID,Phone) VALUES (431,3172421823);
INSERT INTO passenger_phone(PID,Phone) VALUES (433,7731906334);
INSERT INTO passenger_phone(PID,Phone) VALUES (695,9855357658);
INSERT INTO passenger_phone(PID,Phone) VALUES (43,4130456919);
INSERT INTO passenger_phone(PID,Phone) VALUES (604,3547580924);
INSERT INTO passenger_phone(PID,Phone) VALUES (506,7131905776);
INSERT INTO passenger_phone(PID,Phone) VALUES (477,6290639432);
INSERT INTO passenger_phone(PID,Phone) VALUES (852,7874459366);
INSERT INTO passenger_phone(PID,Phone) VALUES (262,2017542665);
INSERT INTO passenger_phone(PID,Phone) VALUES (920,4148767974);
INSERT INTO passenger_phone(PID,Phone) VALUES (574,3897987859);
INSERT INTO passenger_phone(PID,Phone) VALUES (169,1425548481);
INSERT INTO passenger_phone(PID,Phone) VALUES (622,7339075120);
INSERT INTO passenger_phone(PID,Phone) VALUES (657,7191129315);
INSERT INTO passenger_phone(PID,Phone) VALUES (856,3073612427);
INSERT INTO passenger_phone(PID,Phone) VALUES (720,5743160656);
INSERT INTO passenger_phone(PID,Phone) VALUES (427,3197186484);
INSERT INTO passenger_phone(PID,Phone) VALUES (409,3162729496);
INSERT INTO passenger_phone(PID,Phone) VALUES (567,2240104628);
INSERT INTO passenger_phone(PID,Phone) VALUES (969,4215045046);
INSERT INTO passenger_phone(PID,Phone) VALUES (662,5173286483);
INSERT INTO passenger_phone(PID,Phone) VALUES (584,7265730772);
INSERT INTO passenger_phone(PID,Phone) VALUES (476,9341071882);
INSERT INTO passenger_phone(PID,Phone) VALUES (95,3882137680);
INSERT INTO passenger_phone(PID,Phone) VALUES (646,6009581246);
INSERT INTO passenger_phone(PID,Phone) VALUES (624,9376119598);
INSERT INTO passenger_phone(PID,Phone) VALUES (59,8428511916);
INSERT INTO passenger_phone(PID,Phone) VALUES (990,8936931481);
INSERT INTO passenger_phone(PID,Phone) VALUES (606,4819494637);
INSERT INTO passenger_phone(PID,Phone) VALUES (160,1654927670);
INSERT INTO passenger_phone(PID,Phone) VALUES (438,7251509356);
INSERT INTO passenger_phone(PID,Phone) VALUES (318,3603261882);
INSERT INTO passenger_phone(PID,Phone) VALUES (432,3715406963);
INSERT INTO passenger_phone(PID,Phone) VALUES (710,9861366340);
INSERT INTO passenger_phone(PID,Phone) VALUES (452,0015892660);
INSERT INTO passenger_phone(PID,Phone) VALUES (347,2183689757);
INSERT INTO passenger_phone(PID,Phone) VALUES (857,1701355042);
INSERT INTO passenger_phone(PID,Phone) VALUES (957,0670437081);
INSERT INTO passenger_phone(PID,Phone) VALUES (936,2412518197);
INSERT INTO passenger_phone(PID,Phone) VALUES (609,0305954949);
INSERT INTO passenger_phone(PID,Phone) VALUES (318,9768131516);
INSERT INTO passenger_phone(PID,Phone) VALUES (806,6081323388);
INSERT INTO passenger_phone(PID,Phone) VALUES (385,3142394732);

INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1723073015,'Ned','X.','Martin',6182,6767209658,'F','1955-01-18','2017-09-15');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1228881547,'Sawyer','L.','Dixon',9249,7233038713,'M','1964-03-30','2017-04-20');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (4089035780,'Brianna','C.','Perkins',7973,6331256894,'M','1981-12-30','2016-11-16');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2596009902,'Mary','K.','Melissa',9394,4399549740,'F','2004-10-05','1998-09-19');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1818624322,'Adrian','X.','Harris',27319,2389664803,'M','1974-04-08','2017-03-21');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7782466558,'Sharon','O.','Anne',39139,5228516392,'F','1984-06-14','2020-12-11');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6004615448,'Harold','C.','Joe',36194,5055451320,'M','1969-07-21','2018-05-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1071916066,'Cadie','I.','Bailey',46207,4403095817,'F','1958-04-30','1999-02-14');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9455396887,'Carina','S.','Watson',6919,4098812342,'M','1967-07-10','2023-03-09');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2552794347,'Edgar','B.','Spencer',30543,4537002429,'M','1984-09-21','2003-09-13');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5666989915,'Jared','W.','Thomas',31348,2938654496,'F','1956-04-20','2001-12-21');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6471839288,'Amelia','L.','Moore',17299,7166539731,'M','1970-03-07','2004-08-09');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (4775339493,'James','Q.','Morrison',14150,4095169758,'F','1991-01-11','2004-10-13');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6839710329,'Donna','S.','Carl',9836,9099145640,'F','1979-05-16','2020-04-22');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6144043210,'Sophia','E.','Andrews',9408,9749441704,'M','1965-05-10','2019-10-23');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6889127768,'Myra','T.','Harris',11949,5482141634,'M','2004-10-04','2003-10-30');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6795700315,'Antony','U.','Hawkins',60854,6266275512,'M','1997-06-15','2004-02-22');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6762227282,'Brenda','K.','Jimmy',35063,8393450665,'F','1965-04-03','2015-04-30');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3253673037,'Kelvin','H.','Ferguson',10707,6437561662,'F','1974-07-30','1999-12-30');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6979274052,'Tara','K.','Reed',9992,1811188368,'F','1998-06-05','2006-04-09');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1242581599,'Briony','M.','Anderson',10985,4947227165,'M','1984-05-17','2009-12-05');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9656325312,'Maximilian','R.','Nelson',10678,9292327435,'M','1971-04-29','2014-07-26');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5094754453,'Kellan','V.','Elliott',10020,4907179430,'F','2002-04-30','1996-09-28');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7162241260,'Jared','O.','Robinson',12302,6781554132,'F','1978-09-21','2004-01-26');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5656436115,'Patrick','L.','Brooks',11707,9226071227,'M','1978-04-06','1999-02-08');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8660516635,'Chelsea','K.','Evans',10576,6124892628,'F','1986-08-16','2013-06-27');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6154727188,'Adrian','R.','Ellis',10481,2702961493,'F','1957-10-10','1999-02-12');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7856451395,'James','K.','Hawkins',12465,4727527357,'M','1968-02-05','2008-10-15');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7029451799,'Roy','A.','Jason',10895,3081978275,'M','1961-04-09','2019-05-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7514048819,'Tony','I.','Warren',10166,1766616855,'M','1950-04-24','2013-10-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9993757512,'Michael','J.','Brown',9018,7505374919,'F','1997-11-02','2014-10-22');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6378527201,'Alexia','K.','Perkins',24445,6706734298,'M','1962-05-27','1997-02-15');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6560444561,'Alan','S.','Hall',10966,8888419465,'F','1954-10-12','2015-02-02');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9923912715,'Antony','G.','Morrison',8293,9150128637,'F','1960-02-13','1997-03-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2199130905,'Samantha','U.','Carter',26681,3632315913,'M','1965-06-28','2015-01-26');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2049569671,'Audrey','U.','Alexander',4775,3958687192,'M','1952-12-10','2000-12-22');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8235456444,'Ryan','P.','Gray',49443,5162882057,'M','2003-11-28','2005-01-18');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3058929914,'Amanda','B.','Hawkins',9959,1265125699,'M','1958-02-10','2016-12-19');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6224231677,'Arianna','O.','Mitchell',6421,5777060586,'M','1954-03-05','1997-11-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9777755494,'Jenna','L.','Allen',12233,7183761517,'M','1953-10-03','1997-10-25');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7415504759,'Luke','X.','Johnston',10721,3213567281,'M','1964-05-05','1995-09-02');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8607533006,'Antony','B.','Mason',10925,8137190487,'F','1989-08-27','2016-10-20');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6794118189,'Aldus','I.','Higgins',30557,2962467263,'F','1998-02-28','1999-01-13');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9559423186,'Ned','X.','Anderson',8653,9848653818,'F','1997-03-24','2022-06-24');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2532145686,'Jessica','M.','Lloyd',8246,8316256919,'M','1969-03-29','2022-10-31');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (9812666138,'Lois','L.','Brenda',8251,2833773195,'M','1952-07-19','2010-08-28');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5738691381,'Alissa','X.','Parker',8494,3731790377,'F','1966-11-30','2023-10-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1036077180,'Maximilian','B.','Andrews',8191,5645059872,'M','1968-10-14','2006-12-05');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2306046365,'Nicholas','R.','Bailey',8358,4187954512,'M','1983-04-05','2001-06-15');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3949455487,'Elizabeth','X.','Jimmy',18420,5442487176,'M','1989-02-01','2011-10-22');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8281942741,'Carina','X.','Campbell',9737,4247811494,'M','1951-02-28','2018-11-07');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3879160954,'Sophia','A.','Reed',9636,7364688681,'M','1977-10-08','2014-05-20');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8698663522,'Melissa','A.','Chapman',11535,9936217459,'F','1987-12-02','2021-12-28');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1063563524,'Steven','L.','Montgomery',6529,7447049406,'F','1951-12-28','2019-01-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6920182756,'Arthur','K.','Foster',40080,6812874426,'M','1953-04-13','2014-11-28');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2067415434,'Chester','T.','Williams',7404,4176186111,'F','1971-08-20','2014-11-14');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7556917806,'Violet','W.','Farrell',7637,3249073557,'F','1954-03-22','1998-11-05');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5880889912,'Emma','R.','Ferguson',9459,2255785771,'M','1972-03-30','2023-05-28');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2343867626,'Lucas','K.','Bennett',41951,8082382208,'M','1956-11-18','2014-04-11');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2049010047,'Darcy','C.','Tucker',36239,5902257248,'F','1961-05-08','2005-04-05');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6735638271,'Alberta','B.','Robinson',9792,4154114257,'F','1965-05-04','2009-02-04');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3300076804,'Daryl','Q.','Martin',30480,9798767966,'M','1970-04-18','1995-12-23');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (6625811960,'Kristian','M.','Morgan',9852,1726864584,'F','1999-08-11','2018-11-24');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1250946629,'Amy','Y.','Mitchell',57429,2662994532,'M','1982-09-22','2006-06-11');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8581806435,'Arnold','W.','Andrews',9708,1610709074,'M','2005-09-11','2021-01-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7635460557,'Lillian','D.','Andrea',9878,7415001314,'M','2004-07-28','2006-09-08');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (1443933295,'Brooke','O.','Brown',38961,9987276344,'M','1983-12-04','2004-04-12');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5391252459,'Martin','P.','Dixon',36942,3743912473,'M','1979-07-19','2014-05-17');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2741700391,'Isabella','Q.','Johnston',22305,8426773758,'F','1981-03-08','2013-07-27');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7353415534,'Isabella','Q.','Robinson',58049,4604201791,'F','1979-01-27','2011-02-18');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7356719401,'Haris','R.','Harper',14121,5409750199,'F','2001-05-05','2002-11-19');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7715981543,'Mike','P.','Russell',27786,7473829460,'F','1989-05-03','2004-11-08');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5557227589,'David','O.','Fowler',46594,9627386173,'M','1986-08-30','2012-07-11');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (8323992682,'Dainton','P.','Perry',6747,1291865750,'M','1962-01-22','2013-06-11');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (7376558750,'Maddie','J.','Craig',7604,5375878852,'F','2001-07-09','2010-11-26');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (3544575412,'Rosie','W.','Harrison',31019,9832595092,'F','1984-08-05','2007-02-20');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5977334394,'Eric','B.','Fowler',10322,5781934274,'M','1958-11-29','2002-05-04');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (4662500655,'Sofia','O.','Wright',9786,9384404000,'M','1995-05-15','2017-11-14');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (2564929537,'Anne','P.','Theresa',14426,4504035844,'F','1990-08-16','2010-04-29');
INSERT INTO employee(SSN,Fname,Minit,Lname,Salary,Phone,Sex,DOB,Date_Start) VALUES (5064863999,'Nicole','R.','Hall',40496,5397469450,'M','2003-12-19','2005-04-17');


INSERT INTO employee_address(SSN,Street,City,District) VALUES (2049569671,'114-36 Sutter Ave','Hamden','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (4662500655,'67 Dexter Ave','Methuen','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6794118189,'79 Benjamin Dr','Latham','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3544575412,'216-10 17th Ave Unit TH53','Putnam','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6144043210,'1815 College Point Blvd','North Reading','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6378527201,'84-11 165th Ave','New Haven','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6004615448,'679 W 239th St Apt 5J','Monroe','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9455396887,'80 Town Line Rd','Naugatuck','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7415504759,'860 E 232nd St','Enterprise','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8323992682,'60 Lyman Pl','Glenville','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5094754453,'2501 Palisade Ave Apt D2','Alexander City','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6154727188,'42417 Hwy 195','Hoover','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2049010047,'45-33 Zion St','Fall River','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8698663522,'220 Riverside Blvd Apt 24G','Southington','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6004615448,'3176 South Eufaula Avenue','Brockport','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8698663522,'685 Schillinger Rd','Plymouth','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6154727188,'1905 Fulton St','Latham','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3058929914,'378 W End Ave Apt 4A','New Milford','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9923912715,'421 W 154th St','Clanton','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2741700391,'3115 Glenwood Rd','Andalusia','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7715981543,'57 Neutral Ave','West Haven','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3544575412,'37-30 83rd St Unit 4EF','Demopolis','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6625811960,'344 Ashford St','Semmes','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (4775339493,'244-89 61st Ave','Malone','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5656436115,'445 Lafayette St Apt 14A','New Milford','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3058929914,'137 Beach 140th St','Northhampton','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (1242581599,'905 Union St Apt 1','Cheektowaga','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2564929537,'107 Salamander Ct','Centereach','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7415504759,'1100 Clove Rd Unit G0','Sturbridge','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5738691381,'1970 S University Blvd','Homewood','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2049010047,'35-31 85th St Unit 7F','Fredonia','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6889127768,'137 Beach 140th St','Middletown','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7782466558,'529 W 42nd St Apt 2G','Sylacauga','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7715981543,'12-86 Augustina Ave','East Syracuse','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6224231677,'601 Frank Stottile Blvd','Leicester','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9993757512,'5100 Hwy 31','Halfmoon','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3949455487,'465 Park Ave Unit 34E','Cicero','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9923912715,'4346 Edson Ave','Geneva','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2596009902,'540 West Bypass','Glenville','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (4775339493,'18-70 211 St Unit 2A','Catskill','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2741700391,'373 Manor Rd','Avon','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5656436115,'780 Lynnway','Torrington','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3879160954,'6350 Cottage Hill Road','Auburn','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9656325312,'32-40 48 St','Hueytown','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6378527201,'137-06 132nd Ave','Cicero','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5656436115,'144-28 72nd Rd','Russellville','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2199130905,'411 Montauk Ave','Derby','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9777755494,'71-28 Manse St','Vestavia Hills','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7514048819,'215 E 73rd St Unit 4A','Clarence','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6471839288,'30-36 88th St','Glenville','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9993757512,'32 Village Rd N','Sumiton','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7514048819,'12310 Ocean Promenade Apt 7H','Tuscaloosa','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (1250946629,'2501 Palisade Ave Apt D2','Arab','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6839710329,'664 W 161st St Apt 1F','Branford','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7356719401,'62-48 Mount Olivet Cres Unit 1B','Wareham','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (1443933295,'148-05 111th Ave','Huntsville','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5094754453,'67 Riverside Dr Apt 1C','Enterprise','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2564929537,'246 Newman Ave','Montgomery','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8235456444,'4211 Snyder Ave','Abington','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (1071916066,'66-4 Parkhurst Rd','Northport','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8281942741,'90-07 107th Ave','New Milford','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8323992682,'1348 E 7th St','Lynn','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3949455487,'6 Greentree Ln Unit 6','Chicopee','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8323992682,'550 Providence Hwy','Central Square','CT');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3544575412,'333 Main Street','Monroeville','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9812666138,'2200 Sparkman Drive','Adamsville','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6795700315,'25 Tarring St','Huntsville','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (3300076804,'233 5th Ave Ext','Greenville','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (9812666138,'558 E 34th St','Millbrook','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (1063563524,'418 Beach 37th St','Centereach','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2199130905,'591 4th St','Southington','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2564929537,'333 Main Street','Springville','MA');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (7162241260,'88 Greenwich St Apt 2307','Cicero','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6004615448,'3191 County rd 10','Montgomery','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (2564929537,'108 Dutchess Ave','Northhampton','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (5094754453,'82 Vineland Ave','Alexander City','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (8660516635,'87 Saint Marks Pl Apt 4C','Roanoke','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6378527201,'91 Flagg Ct','Boaz','AL');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6004615448,'8200 Narrows Ave Unit Townhouse','Middletown','NY');
INSERT INTO employee_address(SSN,Street,City,District) VALUES (6154727188,'1462 E 23rd St','Halfmoon','CT');

INSERT INTO administrative_support(SSN,ASType) VALUES (3879160954,'Communications');
INSERT INTO administrative_support(SSN,ASType) VALUES (5391252459,'Ground Service');
INSERT INTO administrative_support(SSN,ASType) VALUES (7376558750,'HR');
INSERT INTO administrative_support(SSN,ASType) VALUES (1818624322,'Data Entry');
INSERT INTO administrative_support(SSN,ASType) VALUES (3253673037,'Security');
INSERT INTO administrative_support(SSN,ASType) VALUES (2199130905,'Secretary');
INSERT INTO administrative_support(SSN,ASType) VALUES (6560444561,'Security');
INSERT INTO administrative_support(SSN,ASType) VALUES (2741700391,'PR');
INSERT INTO administrative_support(SSN,ASType) VALUES (6735638271,'Emergency Service');
INSERT INTO administrative_support(SSN,ASType) VALUES (5094754453,'Data Entry');

INSERT INTO engineer(SSN,EType) VALUES (9812666138,'Electric Engineer');
INSERT INTO engineer(SSN,EType) VALUES (7715981543,'Electric Engineer');
INSERT INTO engineer(SSN,EType) VALUES (6920182756,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (5557227589,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (1228881547,'Avionic Engineer');
INSERT INTO engineer(SSN,EType) VALUES (6979274052,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (2596009902,'Electric Engineer');
INSERT INTO engineer(SSN,EType) VALUES (5738691381,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (8698663522,'Electric Engineer');
INSERT INTO engineer(SSN,EType) VALUES (8660516635,'Avionic Engineer');
INSERT INTO engineer(SSN,EType) VALUES (2049010047,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (9455396887,'Electric Engineer');
INSERT INTO engineer(SSN,EType) VALUES (1723073015,'Avionic Engineer');
INSERT INTO engineer(SSN,EType) VALUES (6625811960,'Mechanical Engineer');
INSERT INTO engineer(SSN,EType) VALUES (6471839288,'Electric Engineer');

INSERT INTO flight_employee(FESSN) VALUES (8281942741);
INSERT INTO flight_employee(FESSN) VALUES (6795700315);
INSERT INTO flight_employee(FESSN) VALUES (7162241260);
INSERT INTO flight_employee(FESSN) VALUES (4662500655);
INSERT INTO flight_employee(FESSN) VALUES (2343867626);
INSERT INTO flight_employee(FESSN) VALUES (5977334394);
INSERT INTO flight_employee(FESSN) VALUES (8323992682);
INSERT INTO flight_employee(FESSN) VALUES (1250946629);
INSERT INTO flight_employee(FESSN) VALUES (5880889912);
INSERT INTO flight_employee(FESSN) VALUES (8235456444);
INSERT INTO flight_employee(FESSN) VALUES (3949455487);
INSERT INTO flight_employee(FESSN) VALUES (6004615448);
INSERT INTO flight_employee(FESSN) VALUES (4775339493);
INSERT INTO flight_employee(FESSN) VALUES (1071916066);
INSERT INTO flight_employee(FESSN) VALUES (7556917806);
INSERT INTO flight_employee(FESSN) VALUES (5064863999);
INSERT INTO flight_employee(FESSN) VALUES (2049569671);
INSERT INTO flight_employee(FESSN) VALUES (1063563524);
INSERT INTO flight_employee(FESSN) VALUES (3544575412);
INSERT INTO flight_employee(FESSN) VALUES (7353415534);
INSERT INTO flight_employee(FESSN) VALUES (2564929537);
INSERT INTO flight_employee(FESSN) VALUES (6889127768);
INSERT INTO flight_employee(FESSN) VALUES (7415504759);
INSERT INTO flight_employee(FESSN) VALUES (9923912715);
INSERT INTO flight_employee(FESSN) VALUES (2552794347);
INSERT INTO flight_employee(FESSN) VALUES (2067415434);
INSERT INTO flight_employee(FESSN) VALUES (7635460557);
INSERT INTO flight_employee(FESSN) VALUES (2306046365);
INSERT INTO flight_employee(FESSN) VALUES (1036077180);
INSERT INTO flight_employee(FESSN) VALUES (7356719401);
INSERT INTO flight_employee(FESSN) VALUES (7029451799);
INSERT INTO flight_employee(FESSN) VALUES (6224231677);
INSERT INTO flight_employee(FESSN) VALUES (1242581599);
INSERT INTO flight_employee(FESSN) VALUES (8581806435);
INSERT INTO flight_employee(FESSN) VALUES (7856451395);
INSERT INTO flight_employee(FESSN) VALUES (8607533006);
INSERT INTO flight_employee(FESSN) VALUES (6839710329);
INSERT INTO flight_employee(FESSN) VALUES (6762227282);
INSERT INTO flight_employee(FESSN) VALUES (7514048819);
INSERT INTO flight_employee(FESSN) VALUES (5656436115);

INSERT INTO flight_attendant(SSN,Year_experience) VALUES (8281942741,0.6);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (7162241260,4);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (4662500655,3);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (2343867626,3.4);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (8323992682,2.6);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (8235456444,1.8);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (6004615448,2.6);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (4775339493,4.1);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (1071916066,3.1);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (2049569671,2.3);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (1063563524,4.2);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (3544575412,1.9);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (7353415534,3.1);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (9923912715,2.5);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (2067415434,1.7);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (7635460557,3);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (2306046365,1.5);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (7029451799,2.9);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (8581806435,2.5);
INSERT INTO flight_attendant(SSN,Year_experience) VALUES (6762227282,1.1);

INSERT INTO pilot(SSN,License) VALUES (7856451395,278447263284);
INSERT INTO pilot(SSN,License) VALUES (6795700315,368121436830);
INSERT INTO pilot(SSN,License) VALUES (5977334394,455277894902);
INSERT INTO pilot(SSN,License) VALUES (5880889912,586372610923);
INSERT INTO pilot(SSN,License) VALUES (7415504759,284739946004);
INSERT INTO pilot(SSN,License) VALUES (2552794347,223303613347);
INSERT INTO pilot(SSN,License) VALUES (7556917806,458799019561);
INSERT INTO pilot(SSN,License) VALUES (6889127768,944644826705);
INSERT INTO pilot(SSN,License) VALUES (5064863999,974952636991);
INSERT INTO pilot(SSN,License) VALUES (1250946629,427733108402);
INSERT INTO pilot(SSN,License) VALUES (1036077180,963177445340);
INSERT INTO pilot(SSN,License) VALUES (6839710329,628409586556);
INSERT INTO pilot(SSN,License) VALUES (2564929537,761921335170);
INSERT INTO pilot(SSN,License) VALUES (8607533006,711947499110);
INSERT INTO pilot(SSN,License) VALUES (6224231677,345308465441);
INSERT INTO pilot(SSN,License) VALUES (7356719401,232100783633);
INSERT INTO pilot(SSN,License) VALUES (7514048819,137485426576);
INSERT INTO pilot(SSN,License) VALUES (5656436115,679247900551);
INSERT INTO pilot(SSN,License) VALUES (3949455487,378905025378);
INSERT INTO pilot(SSN,License) VALUES (1242581599,203389713290);

INSERT INTO traffic_controller(SSN) VALUES (9993757512);
INSERT INTO traffic_controller(SSN) VALUES (1443933295);
INSERT INTO traffic_controller(SSN) VALUES (6154727188);
INSERT INTO traffic_controller(SSN) VALUES (4089035780);
INSERT INTO traffic_controller(SSN) VALUES (6144043210);
INSERT INTO traffic_controller(SSN) VALUES (9559423186);
INSERT INTO traffic_controller(SSN) VALUES (9656325312);
INSERT INTO traffic_controller(SSN) VALUES (7782466558);
INSERT INTO traffic_controller(SSN) VALUES (3058929914);
INSERT INTO traffic_controller(SSN) VALUES (6378527201);
INSERT INTO traffic_controller(SSN) VALUES (2532145686);
INSERT INTO traffic_controller(SSN) VALUES (5666989915);
INSERT INTO traffic_controller(SSN) VALUES (6794118189);
INSERT INTO traffic_controller(SSN) VALUES (9777755494);
INSERT INTO traffic_controller(SSN) VALUES (3300076804);

INSERT INTO tcshift(TCSSN,Shift) VALUES (4089035780,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (7782466558,'Evening');
INSERT INTO tcshift(TCSSN,Shift) VALUES (2532145686,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (5666989915,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (1443933295,'Morning');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9559423186,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9777755494,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (6154727188,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (5666989915,'Evening');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9656325312,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9777755494,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (6794118189,'Morning');
INSERT INTO tcshift(TCSSN,Shift) VALUES (3300076804,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9656325312,'Evening');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9656325312,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9656325312,'Morning');
INSERT INTO tcshift(TCSSN,Shift) VALUES (7782466558,'Morning');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9993757512,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (6144043210,'Morning');
INSERT INTO tcshift(TCSSN,Shift) VALUES (6794118189,'Night');
INSERT INTO tcshift(TCSSN,Shift) VALUES (3058929914,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9993757512,'Afternoon');
INSERT INTO tcshift(TCSSN,Shift) VALUES (9559423186,'Morning');

INSERT INTO expertise(ESSN,ModelID) VALUES (5738691381,13);
INSERT INTO expertise(ESSN,ModelID) VALUES (5557227589,12);
INSERT INTO expertise(ESSN,ModelID) VALUES (5738691381,8);
INSERT INTO expertise(ESSN,ModelID) VALUES (8660516635,6);
INSERT INTO expertise(ESSN,ModelID) VALUES (6979274052,16);
INSERT INTO expertise(ESSN,ModelID) VALUES (7715981543,11);
INSERT INTO expertise(ESSN,ModelID) VALUES (9812666138,12);
INSERT INTO expertise(ESSN,ModelID) VALUES (8698663522,16);
INSERT INTO expertise(ESSN,ModelID) VALUES (6920182756,15);
INSERT INTO expertise(ESSN,ModelID) VALUES (1228881547,1);
INSERT INTO expertise(ESSN,ModelID) VALUES (1228881547,12);
INSERT INTO expertise(ESSN,ModelID) VALUES (8698663522,10);
INSERT INTO expertise(ESSN,ModelID) VALUES (5557227589,10);
INSERT INTO expertise(ESSN,ModelID) VALUES (8660516635,4);
INSERT INTO expertise(ESSN,ModelID) VALUES (6920182756,9);
INSERT INTO expertise(ESSN,ModelID) VALUES (6920182756,20);
INSERT INTO expertise(ESSN,ModelID) VALUES (6979274052,5);
INSERT INTO expertise(ESSN,ModelID) VALUES (8660516635,9);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,19);
INSERT INTO expertise(ESSN,ModelID) VALUES (5557227589,3);
INSERT INTO expertise(ESSN,ModelID) VALUES (2596009902,2);
INSERT INTO expertise(ESSN,ModelID) VALUES (8698663522,12);
INSERT INTO expertise(ESSN,ModelID) VALUES (9455396887,15);
INSERT INTO expertise(ESSN,ModelID) VALUES (6920182756,17);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,3);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,7);
INSERT INTO expertise(ESSN,ModelID) VALUES (9455396887,13);
INSERT INTO expertise(ESSN,ModelID) VALUES (6979274052,14);
INSERT INTO expertise(ESSN,ModelID) VALUES (1228881547,2);
INSERT INTO expertise(ESSN,ModelID) VALUES (8698663522,9);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,15);
INSERT INTO expertise(ESSN,ModelID) VALUES (5557227589,1);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,10);
INSERT INTO expertise(ESSN,ModelID) VALUES (1723073015,9);
INSERT INTO expertise(ESSN,ModelID) VALUES (6920182756,7);
INSERT INTO expertise(ESSN,ModelID) VALUES (2596009902,18);
INSERT INTO expertise(ESSN,ModelID) VALUES (1228881547,6);
INSERT INTO expertise(ESSN,ModelID) VALUES (5738691381,7);

INSERT INTO consultant(ID,Name) VALUES (1,'Wojciech Jordan');
INSERT INTO consultant(ID,Name) VALUES (2,'Leah Zamora');
INSERT INTO consultant(ID,Name) VALUES (3,'Umair Davies');
INSERT INTO consultant(ID,Name) VALUES (4,'Velma Baker');
INSERT INTO consultant(ID,Name) VALUES (5,'Aled Lucero');
INSERT INTO consultant(ID,Name) VALUES (6,'Kenny Francis');
INSERT INTO consultant(ID,Name) VALUES (7,'Yasir David');
INSERT INTO consultant(ID,Name) VALUES (8,'Dillan Benjamin');
INSERT INTO consultant(ID,Name) VALUES (9,'Kristina Soto');
INSERT INTO consultant(ID,Name) VALUES (10,'Ian Savage');

INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (3,'SYQ',3);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ARW',2);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ROB',15);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (6,'ROB',3);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (5,'ROB',1);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (2,'VAV',10);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (4,'ADE',13);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ARW',19);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (6,'BGW',4);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (7,'SYQ',18);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ROR',4);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (3,'VAV',12);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ARW',10);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (5,'NGB',12);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (7,'AQP',8);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (2,'ARW',5);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (10,'ADE',2);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (10,'KTM',7);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (1,'AQP',8);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (4,'CNX',11);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (9,'VAV',3);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (10,'AQP',17);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (3,'ARW',2);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (10,'SYQ',6);
INSERT INTO expert_at(ConsultID,APCode,ModelID) VALUES (8,'ROR',11);

INSERT INTO supervision(SSN,SuperSSN) VALUES (6154727188,1443933295);
INSERT INTO supervision(SSN,SuperSSN) VALUES (3300076804,5557227589);
INSERT INTO supervision(SSN,SuperSSN) VALUES (6979274052,2552794347);
INSERT INTO supervision(SSN,SuperSSN) VALUES (9656325312,7782466558);
INSERT INTO supervision(SSN,SuperSSN) VALUES (2067415434,6762227282);
INSERT INTO supervision(SSN,SuperSSN) VALUES (7415504759,6004615448);
INSERT INTO supervision(SSN,SuperSSN) VALUES (1818624322,6920182756);
INSERT INTO supervision(SSN,SuperSSN) VALUES (7715981543,5666989915);
INSERT INTO supervision(SSN,SuperSSN) VALUES (1063563524,1818624322);
INSERT INTO supervision(SSN,SuperSSN) VALUES (7635460557,7715981543);
INSERT INTO supervision(SSN,SuperSSN) VALUES (1228881547,3300076804);
INSERT INTO supervision(SSN,SuperSSN) VALUES (6004615448,1071916066);
INSERT INTO supervision(SSN,SuperSSN) VALUES (2552794347,2049010047);
INSERT INTO supervision(SSN,SuperSSN) VALUES (6144043210,5391252459);
INSERT INTO supervision(SSN,SuperSSN) VALUES (6889127768,6471839288);
INSERT INTO supervision(SSN,SuperSSN) VALUES (3879160954,6794118189);
INSERT INTO supervision(SSN,SuperSSN) VALUES (2741700391,3544575412);
INSERT INTO supervision(SSN,SuperSSN) VALUES (5391252459,5064863999);
INSERT INTO supervision(SSN,SuperSSN) VALUES (5666989915,7353415534);
INSERT INTO supervision(SSN,SuperSSN) VALUES (9777755494,3949455487);
INSERT INTO supervision(SSN,SuperSSN) VALUES (3058929914,3544575412);
INSERT INTO supervision(SSN,SuperSSN) VALUES (7356719401,6378527201);
INSERT INTO supervision(SSN,SuperSSN) VALUES (8235456444,6795700315);
INSERT INTO supervision(SSN,SuperSSN) VALUES (5094754453,2199130905);
INSERT INTO supervision(SSN,SuperSSN) VALUES (5557227589,8235456444);
INSERT INTO supervision(SSN,SuperSSN) VALUES (5880889912,4775339493);
-- INSERT INTO supervision(SSN,SuperSSN) VALUES (7514048819,6144043210);
INSERT INTO supervision(SSN,SuperSSN) VALUES (7556917806,5557227589);
-- INSERT INTO supervision(SSN,SuperSSN) VALUES (6794118189,8698663522);
INSERT INTO supervision(SSN,SuperSSN) VALUES (6560444561,1443933295);
INSERT INTO supervision(SSN,SuperSSN) VALUES (1723073015,6471839288);

INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (1,3,'Unassigned',9,9993757512,'EQ0101','2024-04-17 14:44:38.844114','2024-04-18 00:13:48.844114','1970-01-01','1970-01-01',0.057);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (2,26,'Landed',13,9656325312,'LO0101','2024-04-14 17:30:59.844114','2024-04-14 22:43:13.844114','2024-04-14 16:54:24.844114','2024-04-14 21:54:20.844114',0.066);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (3,22,'Landed',30,5666989915,'NZ0101','2024-04-16 05:12:20.844114','2024-04-16 08:52:56.844114','2024-04-16 06:06:04.844114','2024-04-16 08:20:23.844114',0.098);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (4,13,'Landed',14,9559423186,'QC0101','2024-04-14 10:07:01.844114','2024-04-14 18:19:51.844114','2024-04-14 09:34:23.844114','2024-04-14 18:24:05.844114',0.059);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (5,14,'Landed',23,2532145686,'AD0101','2024-04-14 17:44:54.844114','2024-04-14 23:35:50.844114','2024-04-14 18:13:54.844114','2024-04-14 23:00:18.844114',0.088);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (6,4,'Landed',6,5666989915,'LA0101','2024-04-15 22:32:00.844114','2024-04-16 05:36:27.844114','2024-04-15 22:10:06.844114','2024-04-16 05:19:04.844114',0.073);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (7,25,'Landed',1,9656325312,'PN0101','2024-04-15 11:41:32.844114','2024-04-15 15:20:06.844114','2024-04-15 12:01:38.844114','2024-04-15 14:48:04.844114',0.057);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (8,21,'Landed',16,7782466558,'LA0102','2024-04-16 02:16:51.844114','2024-04-16 06:47:49.844114','2024-04-16 02:41:52.844114','2024-04-16 05:58:39.844114',0.06);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (9,16,'Unassigned',28,7782466558,'NO0101','2024-04-17 23:20:11.844114','2024-04-18 08:34:43.844114','1970-01-01','1970-01-01',0.084);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (10,9,'Landed',8,1443933295,'DE0101','2024-04-17 06:33:57.844114','2024-04-17 13:26:38.844114','2024-04-17 06:42:29.844114','2024-04-17 09:52:15.844114',0.057);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (11,16,'Unassigned',5,5666989915,'QC0102','2024-04-17 20:45:12.844114','2024-04-18 06:02:21.844114','1970-01-01','1970-01-01',0.071);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (12,9,'Landed',10,5666989915,'DE0102','2024-04-16 21:31:58.844114','2024-04-17 02:38:01.844114','2024-04-16 22:15:32.844114','2024-04-17 02:03:13.844114',0.073);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (13,5,'Landed',9,3300076804,'EQ0102','2024-04-15 03:38:21.844114','2024-04-15 07:42:02.844114','2024-04-15 03:55:29.844114','2024-04-15 06:55:51.844114',0.081);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (14,22,'Unassigned',28,9559423186,'NO0102','2024-04-17 12:17:57.844114','2024-04-17 21:06:16.844114','1970-01-01','1970-01-01',0.063);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (15,22,'Unassigned',5,2532145686,'QC0103','2024-04-17 16:29:12.844114','2024-04-18 01:12:01.844114','1970-01-01','1970-01-01',0.073);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (16,14,'Landed',14,9993757512,'QC0104','2024-04-14 15:33:28.844114','2024-04-14 21:23:24.844114','2024-04-14 15:47:59.844114','2024-04-14 21:29:05.844114',0.058);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (17,12,'Landed',19,5666989915,'QC0105','2024-04-15 20:24:56.844114','2024-04-15 23:59:15.844114','2024-04-15 20:43:17.844114','2024-04-16 00:06:59.844114',0.093);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (18,22,'Landed',1,9777755494,'PN0102','2024-04-16 04:48:32.844114','2024-04-16 13:26:25.844114','2024-04-16 04:42:04.844114','2024-04-16 13:50:40.844114',0.058);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (19,24,'Landed',16,1443933295,'LA0103','2024-04-16 07:20:44.844114','2024-04-16 11:23:06.844114','2024-04-16 08:03:16.844114','2024-04-16 10:28:57.844114',0.054);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (20,14,'Landed',6,7782466558,'LA0104','2024-04-15 23:48:09.844114','2024-04-16 07:56:20.844114','2024-04-16 00:01:11.844114','2024-04-16 07:57:34.844114',0.095);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (21,13,'Landed',28,9656325312,'NO0103','2024-04-16 18:23:09.844114','2024-04-17 02:37:07.844114','2024-04-16 18:43:41.844114','2024-04-17 03:17:59.844114',0.065);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (22,20,'Landed',20,5666989915,'NZ0102','2024-04-14 21:17:39.844114','2024-04-15 03:37:53.844114','2024-04-14 20:46:05.844114','2024-04-15 02:57:43.844114',0.088);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (23,15,'Landed',8,3058929914,'DE0103','2024-04-14 16:13:03.844114','2024-04-15 01:30:42.844114','2024-04-14 16:09:20.844114','2024-04-15 01:59:00.844114',0.07);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (24,8,'Landed',25,5666989915,'DV0101','2024-04-14 20:39:48.844114','2024-04-15 02:23:12.844114','2024-04-14 19:55:12.844114','2024-04-15 03:13:39.844114',0.072);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (25,13,'Unassigned',14,9993757512,'QC0106','2024-04-17 12:03:59.844114','2024-04-17 19:06:44.844114','1970-01-01','1970-01-01',0.058);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (26,23,'Unassigned',14,1443933295,'QC0107','2024-04-18 08:08:22.844114','2024-04-18 14:04:10.844114','1970-01-01','1970-01-01',0.057);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (27,7,'Landed',25,9656325312,'DV0102','2024-04-15 09:25:30.844114','2024-04-15 13:41:57.844114','2024-04-15 08:33:16.844114','2024-04-15 14:21:38.844114',0.057);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (28,5,'Landed',8,1443933295,'DE0104','2024-04-15 06:20:51.844114','2024-04-15 13:44:47.844114','2024-04-15 07:05:39.844114','2024-04-15 13:23:10.844114',0.076);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (29,8,'Landed',11,5666989915,'DE0105','2024-04-15 19:00:48.844114','2024-04-16 00:38:53.844114','2024-04-15 19:30:34.844114','2024-04-16 01:10:12.844114',0.075);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (30,15,'Unassigned',23,6144043210,'AD0102','2024-04-17 11:31:22.844114','2024-04-17 17:20:57.844114','1970-01-01','1970-01-01',0.081);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (31,14,'Landed',20,7782466558,'NZ0103','2024-04-16 00:36:36.844114','2024-04-16 05:45:13.844114','2024-04-16 00:25:36.844114','2024-04-16 05:39:49.844114',0.072);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (32,16,'Unassigned',24,7782466558,'SN0101','2024-04-17 19:14:12.844114','2024-04-18 04:48:27.844114','1970-01-01','1970-01-01',0.053);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (33,1,'Landed',5,6144043210,'QC0108','2024-04-16 11:34:34.844114','2024-04-16 19:57:24.844114','2024-04-16 12:20:55.844114','2024-04-16 20:07:37.844114',0.05);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (34,23,'Landed',14,7782466558,'QC0109','2024-04-15 03:52:04.844114','2024-04-15 08:44:15.844114','2024-04-15 04:13:11.844114','2024-04-15 07:49:17.844114',0.061);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (35,26,'Landed',1,5666989915,'PN0103','2024-04-16 23:38:37.844114','2024-04-17 09:35:25.844114','2024-04-16 23:22:31.844114','2024-04-17 09:16:25.844114',0.093);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (36,14,'Unassigned',1,9993757512,'PN0104','2024-04-18 05:19:39.844114','2024-04-18 13:14:21.844114','1970-01-01','1970-01-01',0.063);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (37,23,'Landed',5,6154727188,'QC0110','2024-04-16 12:11:54.844114','2024-04-16 18:59:10.844114','2024-04-16 12:07:27.844114','2024-04-16 18:28:46.844114',0.08);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (38,21,'On Air',3,9656325312,'EQ0103','2024-04-17 07:58:23.844114','2024-04-17 16:03:05.844114','2024-04-17 08:09:02.844114','1970-01-01',0.08);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (39,17,'Landed',4,7782466558,'LA0105','2024-04-16 19:53:10.844114','2024-04-17 03:54:59.844114','2024-04-16 19:37:56.844114','2024-04-17 03:11:41.844114',0.1);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (40,7,'On Air',3,1443933295,'EQ0104','2024-04-17 08:44:49.844114','2024-04-17 18:10:44.844114','2024-04-17 08:34:37.844114','1970-01-01',0.06);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (41,7,'Landed',14,9656325312,'QC0111','2024-04-14 19:02:51.844114','2024-04-14 23:29:46.844114','2024-04-14 19:27:49.844114','2024-04-15 00:02:54.844114',0.088);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (42,13,'Landed',18,6794118189,'PN0105','2024-04-17 04:23:48.844114','2024-04-17 10:53:11.844114','2024-04-17 04:45:33.844114','2024-04-17 09:52:15.844114',0.062);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (43,15,'Landed',10,2532145686,'DE0106','2024-04-16 14:31:06.844114','2024-04-16 20:39:47.844114','2024-04-16 15:18:25.844114','2024-04-16 20:15:17.844114',0.066);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (44,12,'Landed',12,5666989915,'PO0101','2024-04-16 21:10:18.844114','2024-04-17 02:40:25.844114','2024-04-16 21:16:39.844114','2024-04-17 02:23:24.844114',0.05);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (45,14,'Landed',16,3058929914,'LA0106','2024-04-16 12:47:29.844114','2024-04-16 22:20:04.844114','2024-04-16 12:06:44.844114','2024-04-16 22:10:12.844114',0.1);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (46,19,'Landed',3,9993757512,'EQ0105','2024-04-16 13:22:21.844114','2024-04-16 22:15:45.844114','2024-04-16 12:40:45.844114','2024-04-16 23:07:16.844114',0.072);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (47,28,'On Air',26,9656325312,'JS0101','2024-04-17 09:39:48.844114','2024-04-17 16:56:46.844114','2024-04-17 08:43:56.844114','1970-01-01',0.1);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (48,19,'Landed',12,2532145686,'PO0102','2024-04-16 15:23:21.844114','2024-04-17 00:17:59.844114','2024-04-16 14:42:41.844114','2024-04-16 23:57:03.844114',0.06);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (49,25,'Landed',28,9656325312,'NO0104','2024-04-15 19:59:49.844114','2024-04-16 05:45:57.844114','2024-04-15 19:35:09.844114','2024-04-16 05:53:43.844114',0.056);
INSERT INTO flight(FlightID,RID,Status,AirplaneID,TCSSN,FlightCode,EDT,EAT,ADT,AAT,BasePrice) VALUES (50,17,'Landed',5,9656325312,'QC0112','2024-04-16 18:17:56.844114','2024-04-16 23:49:40.844114','2024-04-16 19:10:13.844114','2024-04-16 23:46:55.844114',0.063);

INSERT INTO operates(FlightID,FSSN,Role) VALUES (1,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (1,1036077180,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (1,6004615448,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (1,3544575412,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (1,7415504759,'Pilot');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (2,7415504759,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (2,2552794347,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (2,2306046365,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (2,2049569671,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (3,2564929537,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (3,1250946629,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (3,7353415534,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (3,7162241260,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,7356719401,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,4662500655,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,8281942741,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (4,8581806435,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (5,7856451395,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (5,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (5,8581806435,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (5,7635460557,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (6,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (6,6889127768,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (6,7162241260,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (6,3544575412,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (7,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (7,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (7,6004615448,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (7,3544575412,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (8,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (8,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (8,1063563524,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (8,2049569671,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (9,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (9,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (9,7029451799,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (9,6762227282,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (10,6889127768,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (10,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (10,4775339493,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (10,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (10,1063563524,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (11,7356719401,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (11,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (11,7353415534,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (11,6762227282,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (12,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (12,2552794347,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (12,8235456444,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (12,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (13,7415504759,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (13,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (13,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (13,1063563524,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (14,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (14,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (14,7029451799,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (14,6004615448,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (15,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (15,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (15,4662500655,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (15,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (16,7856451395,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (16,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (16,8281942741,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (16,2067415434,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (17,1250946629,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (17,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (17,2306046365,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (17,6004615448,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (18,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (18,7415504759,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (18,8323992682,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (18,6004615448,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (19,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (19,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (19,3544575412,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (19,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (20,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (20,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (20,1071916066,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (20,7353415534,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (21,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (21,6795700315,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (21,4662500655,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (21,1063563524,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (22,7356719401,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (22,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (22,1063563524,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (22,7029451799,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (23,2564929537,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (23,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (23,6762227282,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (23,8281942741,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (24,3949455487,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (24,7856451395,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (24,8581806435,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (24,8281942741,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (25,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (25,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (25,2049569671,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (25,8235456444,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (26,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (26,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (26,7162241260,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (26,2067415434,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (27,2552794347,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (27,6795700315,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (27,8323992682,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (27,3544575412,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (28,1036077180,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (28,1250946629,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (28,1063563524,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (28,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (29,3949455487,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (29,7356719401,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (29,7353415534,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (29,9923912715,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (30,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (30,1036077180,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (30,8581806435,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (30,4662500655,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (31,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (31,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (31,3544575412,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (31,7162241260,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (32,2564929537,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (32,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (32,2067415434,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (32,4662500655,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (32,9923912715,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,3949455487,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,3544575412,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,7029451799,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,6004615448,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (33,2049569671,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (34,5977334394,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (34,7415504759,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (34,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (34,2049569671,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,3949455487,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,7856451395,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,7415504759,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,6762227282,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (35,9923912715,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (36,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (36,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (36,3544575412,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (36,9923912715,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (37,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (37,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (37,6762227282,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (37,7353415534,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (38,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (38,7856451395,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (38,2306046365,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (38,4775339493,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (39,5880889912,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (39,1242581599,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (39,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (39,8281942741,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (39,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (40,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (40,8607533006,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (40,8323992682,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (40,7353415534,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (41,2552794347,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (41,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (41,8281942741,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (41,2343867626,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (42,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (42,1036077180,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (42,7635460557,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (42,2306046365,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (43,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (43,1250946629,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (43,8235456444,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (43,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (44,5977334394,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (44,6795700315,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (44,8235456444,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (44,2049569671,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (45,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (45,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (45,8235456444,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (45,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (46,5977334394,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (46,5656436115,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (46,9923912715,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (46,8323992682,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,6224231677,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,5064863999,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,5977334394,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,6004615448,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (47,7353415534,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (48,6889127768,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (48,7514048819,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (48,7162241260,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (48,9923912715,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (49,5880889912,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (49,6839710329,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (49,8323992682,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (49,7353415534,'Flight Attendant');

INSERT INTO operates(FlightID,FSSN,Role) VALUES (50,7556917806,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (50,6795700315,'Pilot');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (50,6004615448,'Flight Attendant');
INSERT INTO operates(FlightID,FSSN,Role) VALUES (50,9923912715,'Flight Attendant');

INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0030,325,1,'2024-02-01 23:32:01.844114','01A','1970-01-01','2024-04-17 14:24:22.021005','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0043,245,1,'2024-02-07 08:07:52.844114','01B','2024-03-14 02:16:52.732219','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0063,569,1,'2024-04-02 10:15:53.844114','02A','2024-04-08 21:19:13.871694','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0089,641,1,'2024-01-21 17:26:25.844114','02B','2024-04-06 03:17:26.891469','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0150,649,1,'2024-01-21 02:18:00.844114','02C','1970-01-01','2024-04-13 20:49:17.584053','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0164,615,1,'2024-03-25 08:32:17.844114','02D','1970-01-01','2024-04-14 02:12:36.241784','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0258,777,1,'2024-04-09 12:40:02.844114','02E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0290,723,1,'2024-02-10 15:03:00.844114','02F','1970-01-01','2024-04-15 18:54:43.543858','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0325,630,1,'2024-02-13 13:31:17.844114','03A','1970-01-01','2024-04-17 05:29:05.905916','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0347,778,1,'2024-01-20 17:22:47.844114','03B','2024-02-11 08:56:14.151173','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0503,591,1,'2024-01-30 20:34:17.844114','03C','1970-01-01','2024-04-14 13:07:13.799683','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0540,381,1,'2024-03-15 13:30:03.844114','03D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0589,724,1,'2024-02-12 19:06:37.844114','03E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0605,144,1,'2024-03-29 08:21:08.844114','03F','2024-04-07 15:53:10.623209','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0724,852,1,'2024-02-20 22:31:38.844114','04A','2024-02-23 10:50:48.612771','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0938,609,1,'2024-02-29 15:59:41.844114','04B','2024-04-03 14:35:58.798447','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0970,672,1,'2024-04-01 23:23:17.844114','04C','1970-01-01','2024-04-18 02:43:13.089688','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0016,243,2,'2024-03-05 06:24:51.844114','01A','1970-01-01','2024-04-17 10:24:57.958392','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0171,967,2,'2024-02-23 17:16:12.844114','01B','2024-03-17 17:49:38.813922','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0229,932,2,'2024-03-05 03:00:09.844114','02A','1970-01-01','2024-04-15 17:27:12.217452','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0352,275,2,'2024-01-18 18:08:46.844114','02B','1970-01-01','2024-04-17 04:07:58.039958','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0380,203,2,'2024-01-26 11:31:31.844114','02C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0405,25,2,'2024-03-07 21:25:38.844114','02D','2024-03-11 01:24:44.893194','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0456,996,2,'2024-03-01 20:48:45.844114','02E','1970-01-01','2024-04-16 00:14:35.159411','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0573,568,2,'2024-02-28 18:22:15.844114','02F','2024-04-06 03:28:54.940042','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0591,484,2,'2024-03-15 19:47:27.844114','03A','1970-01-01','2024-04-14 04:50:31.896665','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0596,705,2,'2024-01-29 21:51:17.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0660,396,2,'2024-03-18 22:50:10.844114','03C','2024-04-01 09:07:10.688757','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0710,255,2,'2024-02-28 23:03:53.844114','03D','1970-01-01','2024-04-16 03:52:19.225085','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0711,147,2,'2024-02-14 05:29:00.844114','03E','2024-03-10 09:41:11.543749','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0781,447,2,'2024-03-10 03:22:07.844114','03F','1970-01-01','2024-04-16 15:25:38.857729','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0809,907,2,'2024-02-25 18:33:52.844114','04A','1970-01-01','2024-04-14 20:39:50.2833','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0843,231,2,'2024-02-25 20:41:00.844114','04B','2024-03-04 06:29:20.717402','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0864,685,2,'2024-01-21 14:07:12.844114','04C','2024-03-17 17:54:49.362787','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0878,902,2,'2024-02-05 08:38:31.844114','04D','2024-02-21 10:57:36.81347','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0934,409,2,'2024-02-16 15:05:05.844114','04E','1970-01-01','2024-04-17 03:37:46.23718','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0953,337,2,'2024-01-22 17:43:38.844114','04F','2024-03-22 22:42:16.607582','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0022,955,3,'2024-02-28 21:00:46.844114','01A','2024-03-30 09:26:15.491317','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0026,437,3,'2024-01-23 03:03:03.844114','01B','2024-02-14 17:49:15.951252','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0049,96,3,'2024-03-25 10:50:07.844114','02A','2024-04-09 15:36:38.986521','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0073,725,3,'2024-04-06 08:31:02.844114','02B','1970-01-01','2024-04-14 04:23:20.212089','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0185,951,3,'2024-02-21 00:16:14.844114','02C','2024-03-02 08:12:14.928448','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0200,355,3,'2024-03-29 12:04:20.844114','02D','2024-03-31 18:47:58.749241','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0207,539,3,'2024-03-17 04:31:36.844114','02E','2024-03-22 04:53:50.684338','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0275,830,3,'2024-03-04 21:36:26.844114','02F','2024-04-07 12:47:01.971102','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0295,305,3,'2024-03-24 23:33:05.844114','03A','2024-03-27 05:24:34.392584','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0367,995,3,'2024-03-23 17:07:19.844114','03B','1970-01-01','2024-04-17 02:49:17.274778','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0446,810,3,'2024-03-30 05:42:41.844114','03C','2024-04-07 05:45:16.267042','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0614,849,3,'2024-03-14 11:47:05.844114','03D','2024-03-30 07:13:54.491586','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0650,392,3,'2024-02-20 04:29:25.844114','03E','2024-03-23 13:37:13.831763','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0661,964,3,'2024-03-27 03:13:56.844114','03F','2024-04-11 02:29:51.346048','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0718,688,3,'2024-02-01 08:16:40.844114','04A','2024-03-30 04:41:00.454557','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0731,746,3,'2024-02-09 04:55:18.844114','04B','2024-02-21 22:49:20.52141','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0752,329,3,'2024-03-22 03:22:17.844114','04C','2024-04-14 23:00:35.669194','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0800,539,3,'2024-02-20 22:05:25.844114','04D','1970-01-01','2024-04-14 00:39:00.507529','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0870,224,3,'2024-03-09 05:35:40.844114','04E','1970-01-01','2024-04-14 14:34:03.212218','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0985,564,3,'2024-02-26 03:37:15.844114','04F','2024-04-03 15:45:20.422485','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0070,248,4,'2024-03-29 05:08:46.844114','01A','2024-03-30 20:59:11.509511','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0081,592,4,'2024-03-04 12:02:06.844114','01B','2024-04-15 18:48:02.739045','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0092,999,4,'2024-01-27 14:15:11.844114','02A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0184,584,4,'2024-01-30 11:34:11.844114','02B','1970-01-01','2024-04-13 18:34:29.193445','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0398,500,4,'2024-02-18 09:10:22.844114','02C','2024-02-28 21:20:26.148649','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0536,382,4,'2024-04-06 22:52:29.844114','02D','2024-04-13 14:29:08.834871','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0537,422,4,'2024-03-10 14:42:37.844114','02E','2024-03-17 16:01:44.01391','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0554,65,4,'2024-03-07 20:36:45.844114','02F','2024-04-04 21:56:57.244992','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0561,140,4,'2024-03-09 19:31:32.844114','03A','2024-03-10 10:12:43.711361','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0572,395,4,'2024-01-26 22:40:53.844114','03B','1970-01-01','2024-04-17 14:14:01.833692','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0582,416,4,'2024-02-24 09:26:53.844114','03C','2024-03-25 10:09:34.810115','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0677,712,4,'2024-02-21 21:38:52.844114','03D','1970-01-01','2024-04-16 03:38:17.805906','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0683,77,4,'2024-02-22 17:43:36.844114','03E','1970-01-01','2024-04-15 18:21:26.88752','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0761,221,4,'2024-02-29 14:56:45.844114','03F','2024-04-03 16:01:58.892664','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0774,968,4,'2024-02-21 05:52:32.844114','04A','1970-01-01','2024-04-16 05:44:06.901665','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0777,291,4,'2024-04-10 17:08:04.844114','04B','2024-04-14 20:10:52.701598','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0902,416,4,'2024-03-09 10:38:37.844114','04C','1970-01-01','2024-04-14 17:17:22.385192','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0922,34,4,'2024-01-20 06:00:01.844114','04D','2024-02-08 12:03:09.959743','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0987,22,4,'2024-01-22 10:57:31.844114','04E','1970-01-01','2024-04-18 03:26:51.034282','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0095,670,5,'2024-03-17 06:30:40.844114','01A','1970-01-01','2024-04-15 05:35:22.217239','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0121,547,5,'2024-03-16 15:14:45.844114','01B','2024-04-05 20:05:33.823039','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0162,796,5,'2024-03-25 17:11:02.844114','02A','2024-03-27 07:43:48.201961','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0179,126,5,'2024-02-20 11:20:17.844114','02B','1970-01-01','2024-04-14 09:56:01.926504','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0301,86,5,'2024-01-28 20:30:43.844114','02C','1970-01-01','2024-04-15 20:43:15.021796','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0509,535,5,'2024-03-18 16:42:25.844114','02D','2024-04-01 20:05:46.468816','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0595,337,5,'2024-02-08 21:40:25.844114','02E','2024-02-12 07:36:36.17881','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0638,129,5,'2024-02-19 08:55:46.844114','02F','2024-04-10 21:46:15.971648','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0832,576,5,'2024-02-02 04:20:36.844114','03A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0877,975,5,'2024-02-09 01:12:23.844114','03B','2024-03-14 21:28:59.529185','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0924,702,5,'2024-04-11 19:40:14.844114','03C','2024-04-15 18:01:28.531419','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0949,332,5,'2024-02-12 22:32:42.844114','03D','1970-01-01','2024-04-16 14:16:09.408679','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0968,585,5,'2024-04-09 22:54:22.844114','03E','2024-04-13 20:34:25.640149','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0094,79,6,'2024-02-01 19:55:55.844114','01A','2024-02-08 16:29:38.045458','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0139,31,6,'2024-01-29 06:06:01.844114','01B','2024-03-02 15:23:55.486727','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0249,892,6,'2024-03-23 00:33:02.844114','02A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0331,170,6,'2024-01-22 14:29:20.844114','02B','2024-03-04 05:01:50.786123','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0354,216,6,'2024-01-18 19:07:41.844114','02C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0363,811,6,'2024-02-12 04:35:30.844114','02D','2024-02-29 13:31:45.666406','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0411,529,6,'2024-01-30 18:54:33.844114','02E','1970-01-01','2024-04-17 18:59:06.250901','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0423,84,6,'2024-03-23 14:00:43.844114','02F','1970-01-01','2024-04-16 21:04:43.587609','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0467,955,6,'2024-01-20 14:13:07.844114','03A','1970-01-01','2024-04-16 04:25:28.004699','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0519,16,6,'2024-02-25 13:45:06.844114','03B','2024-04-01 20:16:41.069331','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0555,117,6,'2024-02-22 01:54:11.844114','03C','1970-01-01','2024-04-17 08:34:14.465667','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0644,206,6,'2024-03-28 20:53:46.844114','03D','1970-01-01','2024-04-15 14:07:47.141947','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0721,308,6,'2024-01-18 16:27:43.844114','03E','2024-02-27 01:57:13.046916','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0743,275,6,'2024-01-29 11:22:10.844114','03F','1970-01-01','2024-04-15 20:20:52.93088','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0759,478,6,'2024-03-06 08:40:43.844114','04A','1970-01-01','2024-04-16 16:16:57.061544','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0771,100,6,'2024-03-20 11:43:34.844114','04B','2024-03-26 19:18:10.723331','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0808,61,6,'2024-01-19 09:24:11.844114','04C','2024-01-19 15:37:42.292939','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0812,137,6,'2024-02-05 08:50:43.844114','04D','2024-03-04 08:50:46.34111','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0901,574,6,'2024-04-05 06:07:57.844114','04E','1970-01-01','2024-04-13 21:47:03.259839','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0965,580,6,'2024-02-25 16:28:38.844114','04F','1970-01-01','2024-04-18 01:44:43.548387','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0969,807,6,'2024-04-07 19:11:55.844114','05A','2024-04-16 09:50:52.589349','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0972,72,6,'2024-01-25 22:53:24.844114','05B','1970-01-01','2024-04-18 06:17:52.996665','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0131,921,7,'2024-01-22 16:35:16.844114','01A','2024-02-17 19:09:59.443522','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0192,460,7,'2024-02-05 17:18:47.844114','01B','2024-03-03 13:01:11.085901','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0204,659,7,'2024-02-14 19:05:13.844114','02A','2024-02-27 03:34:55.96745','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0297,606,7,'2024-03-17 09:21:42.844114','02B','2024-03-19 11:23:45.227942','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0315,460,7,'2024-04-02 01:46:56.844114','02C','2024-04-12 16:16:10.042849','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0335,614,7,'2024-01-20 23:14:47.844114','02D','2024-03-29 17:05:35.99039','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0407,206,7,'2024-04-01 03:30:06.844114','02E','2024-04-05 14:10:22.784458','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0599,774,7,'2024-04-08 22:23:55.844114','02F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0610,120,7,'2024-01-24 10:20:03.844114','03A','2024-02-05 01:19:59.08637','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0652,796,7,'2024-04-12 16:41:44.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0915,507,7,'2024-04-08 09:38:45.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0008,902,8,'2024-02-05 08:40:21.844114','01A','2024-03-25 13:05:55.391181','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0134,66,8,'2024-02-20 18:33:18.844114','01B','2024-04-09 12:12:39.999492','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0152,709,8,'2024-04-09 10:24:59.844114','02A','2024-04-13 17:17:49.28976','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0220,165,8,'2024-02-17 13:43:29.844114','02B','2024-02-20 04:05:23.318236','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0283,7,8,'2024-03-11 06:04:58.844114','02C','2024-04-10 08:52:21.489854','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0345,140,8,'2024-04-14 18:54:07.844114','02D','2024-04-15 16:20:22.052517','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0356,891,8,'2024-03-07 22:54:12.844114','02E','1970-01-01','2024-04-16 19:26:28.591878','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0406,924,8,'2024-04-15 16:10:17.844114','02F','1970-01-01','2024-04-17 01:46:55.065284','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0443,97,8,'2024-03-22 02:48:05.844114','03A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0470,731,8,'2024-04-16 02:06:42.844114','03B','2024-04-16 03:25:10.003482','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0592,573,8,'2024-02-29 08:07:42.844114','03C','2024-03-23 07:19:56.36956','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0621,939,8,'2024-03-25 10:05:38.844114','03D','1970-01-01','2024-04-14 23:25:23.894018','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0635,143,8,'2024-03-12 03:56:52.844114','03E','1970-01-01','2024-04-15 10:36:10.671192','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0738,493,8,'2024-03-21 19:58:41.844114','03F','2024-03-22 17:33:43.384359','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0823,760,8,'2024-02-07 12:32:51.844114','04A','2024-03-07 15:30:16.883265','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0837,836,8,'2024-02-17 04:32:11.844114','04B','2024-03-21 02:57:57.112812','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0910,962,8,'2024-03-13 16:25:53.844114','04C','1970-01-01','2024-04-14 00:17:55.958088','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0979,186,8,'2024-03-20 05:10:39.844114','04D','2024-03-24 03:55:47.900559','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0066,689,9,'2024-03-10 04:15:45.844114','01A','2024-03-27 02:52:45.845775','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0075,704,9,'2024-03-19 15:26:16.844114','01B','2024-04-08 22:12:14.602135','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0090,562,9,'2024-01-23 21:01:09.844114','02A','1970-01-01','2024-04-15 22:37:34.346236','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0100,392,9,'2024-02-26 01:14:52.844114','02B','2024-04-07 22:50:07.329078','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0146,643,9,'2024-03-04 07:54:02.844114','02C','1970-01-01','2024-04-13 17:24:51.544656','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0178,206,9,'2024-04-03 17:06:34.844114','02D','2024-04-11 07:59:03.170215','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0280,547,9,'2024-02-24 11:58:43.844114','02E','1970-01-01','2024-04-15 17:53:13.21349','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0313,940,9,'2024-02-13 19:59:21.844114','02F','2024-02-28 09:55:29.032262','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0424,237,9,'2024-03-19 22:33:45.844114','03A','2024-04-06 10:53:37.480498','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0506,590,9,'2024-03-06 01:08:43.844114','03B','1970-01-01','2024-04-14 14:30:48.534319','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0559,169,9,'2024-02-21 02:34:08.844114','03C','2024-03-29 23:10:36.090016','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0567,89,9,'2024-02-20 15:10:49.844114','03D','1970-01-01','2024-04-17 08:38:14.790081','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0616,359,9,'2024-02-21 11:09:30.844114','03E','1970-01-01','2024-04-13 22:28:48.897371','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0624,916,9,'2024-03-26 11:59:21.844114','03F','2024-04-13 15:47:53.110039','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0645,52,9,'2024-04-11 03:00:12.844114','04A','1970-01-01','2024-04-15 02:02:20.787914','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0658,548,9,'2024-02-28 03:22:40.844114','04B','2024-03-09 02:51:07.81694','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0665,805,9,'2024-02-06 03:08:54.844114','04C','2024-03-04 19:42:15.087188','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0673,955,9,'2024-02-18 23:45:13.844114','04D','2024-03-05 02:05:14.099175','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0763,292,9,'2024-01-27 09:26:02.844114','04E','2024-02-26 03:45:30.431294','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0849,699,9,'2024-04-03 03:18:30.844114','04F','2024-04-15 22:06:09.730152','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0906,987,9,'2024-02-13 10:58:50.844114','05A','2024-04-09 02:01:49.155931','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0031,679,10,'2024-03-27 23:03:21.844114','01A','2024-04-03 02:32:44.799882','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0035,866,10,'2024-04-16 06:52:54.844114','01B','2024-04-16 07:36:36.72273','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0041,256,10,'2024-03-28 21:08:10.844114','02A','1970-01-01','2024-04-14 08:00:06.763228','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0088,226,10,'2024-02-14 04:42:53.844114','02B','2024-04-14 02:58:51.55767','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0108,826,10,'2024-03-21 22:07:03.844114','02C','2024-04-03 22:03:18.261501','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0112,583,10,'2024-02-18 06:15:39.844114','02D','2024-03-20 07:00:18.171375','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0117,143,10,'2024-03-20 07:09:01.844114','02E','1970-01-01','2024-04-13 16:02:31.439348','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0252,565,10,'2024-03-18 00:52:42.844114','02F','2024-04-09 18:07:27.119251','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0318,207,10,'2024-03-26 21:52:48.844114','03A','1970-01-01','2024-04-17 08:58:37.084395','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0393,463,10,'2024-02-11 17:44:24.844114','03B','1970-01-01','2024-04-17 02:18:59.960112','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0499,7,10,'2024-03-23 08:51:41.844114','03C','1970-01-01','2024-04-14 10:28:27.583919','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0515,858,10,'2024-02-12 02:05:47.844114','03D','1970-01-01','2024-04-14 13:26:11.308964','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0534,190,10,'2024-03-31 15:02:13.844114','03E','2024-04-12 21:41:12.669004','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0612,787,10,'2024-03-15 16:07:23.844114','03F','2024-04-07 13:38:16.325604','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0699,33,10,'2024-03-13 22:48:10.844114','04A','1970-01-01','2024-04-15 11:35:09.313666','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0733,299,10,'2024-03-24 02:31:03.844114','04B','2024-04-15 11:19:52.636413','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0747,73,10,'2024-03-09 12:45:11.844114','04C','2024-03-21 11:07:38.161187','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0769,641,10,'2024-01-30 06:35:14.844114','04D','1970-01-01','2024-04-16 08:24:09.133959','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0801,275,10,'2024-02-07 11:47:10.844114','04E','2024-04-13 06:12:25.353771','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0805,294,10,'2024-04-09 07:13:06.844114','04F','1970-01-01','2024-04-14 14:54:48.684716','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0822,386,10,'2024-04-16 01:12:31.844114','05A','2024-04-16 04:44:52.675636','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0824,114,10,'2024-02-29 06:54:25.844114','05B','2024-04-12 18:37:01.310476','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0833,75,10,'2024-04-01 18:05:27.844114','05C','1970-01-01','2024-04-14 17:53:16.155558','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0839,340,10,'2024-01-21 18:21:46.844114','05D','2024-01-24 18:34:46.920029','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0966,474,10,'2024-03-29 13:00:21.844114','05E','2024-03-29 16:18:13.123557','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0011,244,11,'2024-01-22 02:42:57.844114','01A','1970-01-01','2024-04-17 11:41:45.243548','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0053,321,11,'2024-04-10 09:15:31.844114','01B','2024-04-14 16:19:04.893617','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0057,69,11,'2024-03-21 07:03:57.844114','02A','2024-04-09 14:38:17.099389','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0122,490,11,'2024-02-21 17:20:14.844114','02B','2024-03-13 17:31:54.160802','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0163,383,11,'2024-03-10 12:02:53.844114','02C','2024-03-17 10:51:09.221132','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0194,303,11,'2024-04-14 10:25:40.844114','02D','1970-01-01','2024-04-14 23:35:41.377343','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0212,789,11,'2024-04-04 23:09:55.844114','02E','2024-04-15 19:03:43.65412','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0231,472,11,'2024-03-16 02:40:13.844114','02F','2024-03-16 20:02:37.254821','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0377,520,11,'2024-03-04 13:26:59.844114','03A','2024-04-15 14:34:42.438453','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0435,621,11,'2024-02-10 06:09:07.844114','03B','1970-01-01','2024-04-17 20:15:21.682117','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0475,421,11,'2024-02-14 05:45:18.844114','03C','2024-03-06 07:33:39.188799','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0498,314,11,'2024-03-30 02:17:51.844114','03D','2024-04-02 15:44:35.712488','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0505,999,11,'2024-04-13 14:18:31.844114','03E','2024-04-14 16:47:59.996803','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0576,23,11,'2024-02-28 08:49:44.844114','03F','1970-01-01','2024-04-16 21:37:43.768728','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0584,364,11,'2024-04-11 16:18:56.844114','04A','2024-04-16 06:45:06.008488','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0648,191,11,'2024-03-05 21:29:27.844114','04B','1970-01-01','2024-04-15 09:53:16.159854','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0697,215,11,'2024-02-04 09:27:32.844114','04C','2024-02-14 14:31:46.425828','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0744,385,11,'2024-03-17 21:42:12.844114','04D','2024-04-01 20:23:20.954344','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0758,412,11,'2024-01-27 19:26:12.844114','04E','2024-02-04 16:09:32.02528','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0817,285,11,'2024-01-21 00:41:08.844114','04F','2024-04-12 18:14:27.617012','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0825,590,11,'2024-03-31 14:13:34.844114','05A','2024-04-04 15:21:37.331161','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0925,672,11,'2024-02-15 08:00:48.844114','05B','2024-03-01 13:00:06.955248','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0927,672,11,'2024-02-05 17:37:44.844114','05C','2024-03-10 05:02:34.852688','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0964,231,11,'2024-02-02 19:00:30.844114','05D','2024-03-05 14:52:01.943172','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0045,427,12,'2024-01-28 23:13:34.844114','01A','2024-04-05 21:37:41.274144','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0072,231,12,'2024-01-29 14:05:45.844114','01B','1970-01-01','2024-04-14 11:48:49.590248','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0188,719,12,'2024-04-14 11:23:29.844114','02A','2024-04-15 06:42:30.565614','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0191,865,12,'2024-01-24 05:48:57.844114','02B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0266,366,12,'2024-02-07 02:51:41.844114','02C','1970-01-01','2024-04-14 15:23:21.430196','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0328,10,12,'2024-02-24 00:25:22.844114','02D','2024-03-04 07:47:03.200957','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0520,941,12,'2024-03-18 09:55:09.844114','02E','2024-03-19 13:54:33.092767','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0633,451,12,'2024-04-03 05:36:38.844114','02F','2024-04-11 19:46:52.287462','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0646,351,12,'2024-03-01 16:29:27.844114','03A','2024-03-11 02:56:15.01553','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0755,334,12,'2024-02-06 11:29:55.844114','03B','2024-02-23 00:04:26.785288','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0783,486,12,'2024-03-07 18:27:53.844114','03C','1970-01-01','2024-04-16 13:04:12.791704','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0791,876,12,'2024-04-01 01:45:56.844114','03D','1970-01-01','2024-04-16 09:13:10.284271','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0853,298,12,'2024-04-07 12:20:34.844114','03E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0941,928,12,'2024-03-04 13:42:29.844114','03F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0981,839,12,'2024-02-09 14:58:43.844114','04A','2024-04-12 16:44:59.772689','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0009,119,13,'2024-04-02 00:46:34.844114','01A','2024-04-16 06:20:05.917094','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0012,222,13,'2024-03-06 18:44:06.844114','01B','2024-04-12 14:25:26.905858','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0038,158,13,'2024-03-15 04:06:09.844114','02A','2024-04-09 05:32:19.512277','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0046,468,13,'2024-02-02 17:30:38.844114','02B','2024-02-07 01:43:36.539865','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0061,916,13,'2024-04-07 07:04:26.844114','02C','1970-01-01','2024-04-14 15:23:29.018143','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0067,4,13,'2024-03-10 10:31:19.844114','02D','2024-03-11 02:48:14.22404','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0107,872,13,'2024-01-19 08:32:06.844114','02E','1970-01-01','2024-04-15 20:35:03.518141','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0151,187,13,'2024-04-06 19:48:48.844114','02F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0228,493,13,'2024-01-23 01:36:08.844114','03A','1970-01-01','2024-04-15 09:46:01.030511','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0256,182,13,'2024-04-02 17:25:56.844114','03B','2024-04-11 10:59:44.005348','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0287,100,13,'2024-04-13 23:22:18.844114','03C','2024-04-14 12:20:15.421541','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0454,888,13,'2024-02-13 00:09:49.844114','03D','2024-03-11 18:29:04.021581','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0457,623,13,'2024-03-16 22:28:04.844114','03E','2024-03-25 15:28:09.804312','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0553,495,13,'2024-03-26 07:28:26.844114','03F','2024-03-29 10:09:39.495953','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0597,949,13,'2024-03-15 20:02:51.844114','04A','2024-04-13 08:56:37.436458','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0680,907,13,'2024-04-05 16:41:45.844114','04B','1970-01-01','2024-04-15 12:20:11.342878','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0706,96,13,'2024-01-27 13:47:54.844114','04C','1970-01-01','2024-04-15 16:44:34.250882','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0715,941,13,'2024-04-01 09:44:00.844114','04D','1970-01-01','2024-04-15 09:08:58.786179','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0726,29,13,'2024-01-29 14:01:52.844114','04E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0827,956,13,'2024-01-22 02:38:40.844114','04F','1970-01-01','2024-04-14 14:03:16.15571','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0834,124,13,'2024-03-07 23:01:37.844114','05A','1970-01-01','2024-04-14 15:54:03.056027','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0954,986,13,'2024-02-10 08:00:47.844114','05B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0984,713,13,'2024-02-03 09:26:59.844114','05C','1970-01-01','2024-04-17 19:36:56.299482','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0014,387,14,'2024-03-13 05:06:03.844114','01A','1970-01-01','2024-04-17 05:33:51.381432','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0042,436,14,'2024-02-21 00:33:15.844114','01B','1970-01-01','2024-04-13 19:02:48.757684','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0071,407,14,'2024-03-28 06:26:35.844114','02A','2024-04-09 12:15:24.063843','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0091,249,14,'2024-03-10 11:38:34.844114','02B','2024-04-04 10:24:43.171728','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0135,555,14,'2024-03-01 18:55:33.844114','02C','2024-04-11 10:00:50.423862','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0221,688,14,'2024-03-27 12:26:45.844114','02D','1970-01-01','2024-04-15 21:43:03.65508','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0237,245,14,'2024-02-01 19:26:12.844114','02E','1970-01-01','2024-04-14 21:45:52.57864','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0286,676,14,'2024-03-23 07:33:11.844114','02F','1970-01-01','2024-04-15 14:26:25.063432','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0337,774,14,'2024-02-04 22:22:39.844114','03A','1970-01-01','2024-04-17 19:23:36.166702','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0430,96,14,'2024-03-20 15:54:51.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0459,18,14,'2024-02-24 18:33:41.844114','03C','1970-01-01','2024-04-16 04:10:36.307102','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0464,514,14,'2024-03-23 14:45:18.844114','03D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0472,912,14,'2024-03-27 00:30:33.844114','03E','2024-04-13 12:57:12.055571','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0479,268,14,'2024-04-11 01:11:37.844114','03F','2024-04-14 11:05:42.160703','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0552,761,14,'2024-02-26 10:29:40.844114','04A','1970-01-01','2024-04-17 11:20:39.972117','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0692,773,14,'2024-03-29 12:57:07.844114','04B','2024-04-04 06:25:06.491799','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0819,1000,14,'2024-03-11 02:54:57.844114','04C','2024-03-18 01:25:58.152693','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0871,139,14,'2024-02-13 12:00:32.844114','04D','2024-03-12 15:41:07.020063','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0899,94,14,'2024-03-16 14:43:50.844114','04E','2024-03-28 02:21:09.727467','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0918,605,14,'2024-01-21 12:51:54.844114','04F','1970-01-01','2024-04-17 00:55:34.187944','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0961,513,14,'2024-01-25 20:39:24.844114','05A','2024-02-12 00:43:01.099301','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0983,46,14,'2024-02-04 16:37:37.844114','05B','2024-03-05 15:05:16.377283','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0097,560,15,'2024-04-14 01:26:25.844114','01A','2024-04-14 06:49:38.040655','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0138,553,15,'2024-03-30 17:23:13.844114','01B','2024-04-14 11:47:08.37437','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0247,136,15,'2024-04-07 07:59:19.844114','02A','2024-04-15 09:11:37.514071','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0260,669,15,'2024-02-18 21:38:10.844114','02B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0384,116,15,'2024-02-12 08:54:37.844114','02C','1970-01-01','2024-04-17 01:42:40.965729','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0433,450,15,'2024-02-13 21:07:57.844114','02D','2024-02-17 12:14:37.110506','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0455,46,15,'2024-03-20 10:20:58.844114','02E','2024-04-03 01:42:54.62755','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0551,856,15,'2024-03-29 02:09:23.844114','02F','2024-04-08 10:17:53.166737','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0593,62,15,'2024-04-03 05:59:39.844114','03A','2024-04-03 17:33:35.940795','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0598,163,15,'2024-03-31 06:23:08.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0632,629,15,'2024-02-18 00:55:19.844114','03C','2024-02-26 16:47:22.617058','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0675,101,15,'2024-01-28 19:39:28.844114','03D','2024-02-13 20:51:13.154385','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0735,961,15,'2024-02-12 11:21:43.844114','03E','2024-02-29 11:57:04.574682','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0736,481,15,'2024-03-23 18:38:30.844114','03F','1970-01-01','2024-04-15 03:30:31.228046','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0784,581,15,'2024-03-03 05:51:10.844114','04A','1970-01-01','2024-04-15 21:56:12.409288','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0882,673,15,'2024-01-24 11:12:27.844114','04B','2024-02-18 23:44:22.966048','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0931,331,15,'2024-04-06 09:45:00.844114','04C','2024-04-11 09:34:05.077941','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0007,332,16,'2024-02-22 05:59:51.844114','01A','2024-03-31 10:22:12.962647','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0028,127,16,'2024-03-15 15:18:10.844114','01B','2024-03-22 20:31:50.319925','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0149,825,16,'2024-03-10 04:58:51.844114','02A','1970-01-01','2024-04-14 08:24:29.685658','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0202,188,16,'2024-02-23 03:48:33.844114','02B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0243,179,16,'2024-02-03 19:42:09.844114','02C','1970-01-01','2024-04-14 14:31:59.102263','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0350,400,16,'2024-03-24 07:18:54.844114','02D','2024-04-07 23:19:08.240542','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0355,386,16,'2024-01-27 19:01:12.844114','02E','1970-01-01','2024-04-17 01:27:00.809289','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0444,54,16,'2024-03-08 00:11:41.844114','02F','2024-04-03 06:12:30.564132','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0532,907,16,'2024-03-25 13:46:47.844114','03A','1970-01-01','2024-04-16 14:10:43.661209','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0550,557,16,'2024-03-22 13:05:05.844114','03B','1970-01-01','2024-04-16 23:36:17.330904','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0556,260,16,'2024-02-20 21:26:52.844114','03C','2024-02-28 13:20:53.844654','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0560,761,16,'2024-01-30 13:27:44.844114','03D','1970-01-01','2024-04-16 17:33:24.719553','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0579,233,16,'2024-03-06 15:05:05.844114','03E','1970-01-01','2024-04-17 15:35:27.552146','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0630,867,16,'2024-02-29 14:05:21.844114','03F','2024-04-15 14:26:53.202459','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0831,665,16,'2024-03-04 14:06:27.844114','04A','1970-01-01','2024-04-13 21:59:20.877049','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0852,635,16,'2024-02-14 13:27:43.844114','04B','2024-03-10 14:41:18.545881','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0857,418,16,'2024-04-11 16:05:27.844114','04C','1970-01-01','2024-04-14 01:27:58.940054','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0869,513,16,'2024-03-03 10:35:16.844114','04D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0907,918,16,'2024-03-17 02:36:22.844114','04E','1970-01-01','2024-04-13 22:44:32.555192','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0967,979,16,'2024-02-16 02:45:49.844114','04F','1970-01-01','2024-04-17 23:31:19.575662','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0980,304,16,'2024-01-28 06:57:01.844114','05A','2024-03-17 07:39:10.329927','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0025,987,17,'2024-03-31 09:59:29.844114','01A','1970-01-01','2024-04-16 19:55:16.705543','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0027,985,17,'2024-03-23 13:58:32.844114','01B','2024-04-08 04:33:23.748091','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0055,591,17,'2024-04-10 15:03:59.844114','02A','1970-01-01','2024-04-13 21:59:21.561164','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0125,270,17,'2024-02-13 09:50:37.844114','02B','1970-01-01','2024-04-13 14:46:43.497935','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0130,822,17,'2024-02-01 16:39:50.844114','02C','2024-03-27 17:24:39.895506','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0154,63,17,'2024-01-31 23:08:55.844114','02D','2024-03-04 11:27:49.409353','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0161,153,17,'2024-03-29 09:01:55.844114','02E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0257,969,17,'2024-04-10 12:45:34.844114','02F','1970-01-01','2024-04-14 18:04:59.22373','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0284,262,17,'2024-01-29 22:18:41.844114','03A','1970-01-01','2024-04-16 00:09:24.383842','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0296,909,17,'2024-02-08 22:27:26.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0339,664,17,'2024-03-11 10:17:31.844114','03C','2024-03-12 10:13:32.918977','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0353,547,17,'2024-03-13 15:11:09.844114','03D','1970-01-01','2024-04-17 21:34:58.489638','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0394,915,17,'2024-04-10 19:50:44.844114','03E','2024-04-15 03:55:38.293711','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0586,508,17,'2024-04-05 20:47:01.844114','03F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0640,156,17,'2024-02-25 07:21:00.844114','04A','2024-03-25 10:37:29.154042','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0691,894,17,'2024-02-19 09:34:11.844114','04B','1970-01-01','2024-04-15 09:05:18.078773','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0760,37,17,'2024-01-22 03:42:53.844114','04C','2024-03-02 22:57:03.822577','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0811,56,17,'2024-02-25 18:40:55.844114','04D','2024-03-30 22:44:51.471233','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0912,404,17,'2024-03-19 08:27:32.844114','04E','1970-01-01','2024-04-17 07:54:21.392217','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (1000,938,17,'2024-03-17 15:49:26.844114','04F','1970-01-01','2024-04-14 15:19:50.775767','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0019,346,18,'2024-03-14 14:59:28.844114','01A','1970-01-01','2024-04-17 11:53:32.843193','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0033,2,18,'2024-03-26 20:04:07.844114','01B','2024-04-15 04:58:51.219701','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0060,116,18,'2024-02-26 12:32:14.844114','02A','1970-01-01','2024-04-14 08:57:56.793593','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0080,647,18,'2024-01-21 09:59:56.844114','02B','2024-02-28 17:37:06.939569','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0087,38,18,'2024-03-31 22:09:19.844114','02C','2024-04-02 13:12:15.027981','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0159,414,18,'2024-02-11 10:43:58.844114','02D','2024-03-27 07:59:16.489092','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0206,723,18,'2024-02-27 12:06:56.844114','02E','2024-04-06 07:36:14.654016','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0210,588,18,'2024-01-19 03:39:34.844114','02F','1970-01-01','2024-04-15 00:15:52.695549','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0273,341,18,'2024-02-11 14:25:14.844114','03A','2024-03-18 09:43:26.391223','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0323,493,18,'2024-02-13 17:52:45.844114','03B','2024-02-24 22:01:54.408604','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0326,670,18,'2024-02-08 10:51:56.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0343,968,18,'2024-02-25 07:08:33.844114','03D','2024-03-16 04:03:44.865584','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0381,479,18,'2024-02-23 17:44:29.844114','03E','2024-03-16 13:46:59.12606','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0458,627,18,'2024-02-29 09:43:54.844114','03F','1970-01-01','2024-04-16 16:20:52.93479','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0461,916,18,'2024-02-27 21:44:40.844114','04A','2024-04-15 09:21:07.798008','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0462,30,18,'2024-04-02 22:54:37.844114','04B','1970-01-01','2024-04-16 12:44:08.746854','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0568,132,18,'2024-02-25 00:13:30.844114','04C','2024-03-05 01:09:30.495129','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0656,185,18,'2024-03-05 17:37:15.844114','04D','1970-01-01','2024-04-15 10:28:09.944787','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0700,593,18,'2024-03-05 01:37:35.844114','04E','2024-03-12 01:07:01.242313','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0713,594,18,'2024-01-18 17:19:34.844114','04F','1970-01-01','2024-04-15 23:10:21.330209','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0714,135,18,'2024-02-15 05:07:18.844114','05A','2024-03-02 16:22:11.871475','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0776,24,18,'2024-02-23 06:43:37.844114','05B','2024-02-28 15:55:49.786035','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0855,663,18,'2024-03-15 14:45:48.844114','05C','2024-03-20 12:50:31.162819','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0872,436,18,'2024-01-31 08:09:01.844114','05D','2024-02-23 19:55:13.2874','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0916,259,18,'2024-02-23 22:46:31.844114','05E','2024-03-25 03:36:31.097692','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0977,341,18,'2024-02-06 23:22:57.844114','05F','2024-03-15 11:23:19.216429','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0040,750,19,'2024-03-01 06:44:53.844114','01A','2024-04-09 23:46:40.693328','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0083,685,19,'2024-03-21 02:37:01.844114','01B','2024-03-30 18:11:00.183646','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0116,344,19,'2024-02-29 21:34:22.844114','02A','1970-01-01','2024-04-14 01:49:01.830308','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0119,1,19,'2024-03-29 22:13:58.844114','02B','2024-04-08 16:32:49.079641','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0177,137,19,'2024-03-26 00:01:57.844114','02C','1970-01-01','2024-04-14 01:10:40.67672','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0248,730,19,'2024-03-23 22:02:57.844114','02D','2024-04-05 07:57:35.803023','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0448,650,19,'2024-02-28 10:10:01.844114','02E','2024-02-29 17:40:00.775126','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0465,293,19,'2024-03-19 19:55:38.844114','02F','2024-04-12 02:22:21.740148','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0545,468,19,'2024-02-12 03:25:52.844114','03A','2024-03-04 18:39:17.256521','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0619,630,19,'2024-03-14 12:51:19.844114','03B','2024-03-31 19:14:08.351479','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0637,755,19,'2024-02-01 04:07:13.844114','03C','2024-04-11 07:47:58.092873','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0653,107,19,'2024-04-02 08:20:24.844114','03D','1970-01-01','2024-04-14 22:42:53.225','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0686,864,19,'2024-04-16 08:27:24.844114','03E','1970-01-01','2024-04-15 17:24:28.25937','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0749,490,19,'2024-03-11 22:38:03.844114','03F','1970-01-01','2024-04-15 09:15:22.570514','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0945,442,19,'2024-04-04 03:56:58.844114','04A','2024-04-12 04:37:08.372736','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0002,555,20,'2024-03-04 17:44:56.844114','01A','2024-04-14 06:34:36.521106','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0096,235,20,'2024-02-26 15:08:32.844114','01B','2024-02-28 21:51:57.724972','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0113,920,20,'2024-03-29 05:41:35.844114','02A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0142,64,20,'2024-03-26 15:32:28.844114','02B','1970-01-01','2024-04-13 12:16:33.629898','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0173,700,20,'2024-02-11 15:32:03.844114','02C','1970-01-01','2024-04-14 16:53:04.043051','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0234,403,20,'2024-03-08 21:17:38.844114','02D','1970-01-01','2024-04-14 16:42:03.579355','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0330,481,20,'2024-03-13 18:15:33.844114','02E','2024-03-28 02:40:14.113262','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0361,308,20,'2024-02-29 11:40:07.844114','02F','2024-04-08 17:46:50.870843','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0364,604,20,'2024-02-04 23:08:29.844114','03A','1970-01-01','2024-04-16 16:24:47.932265','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0434,807,20,'2024-03-14 03:45:50.844114','03B','1970-01-01','2024-04-17 13:16:35.875775','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0440,653,20,'2024-01-20 10:56:32.844114','03C','1970-01-01','2024-04-17 19:05:02.697342','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0504,431,20,'2024-04-06 07:12:10.844114','03D','1970-01-01','2024-04-14 19:55:45.193211','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0508,685,20,'2024-02-12 04:10:10.844114','03E','1970-01-01','2024-04-14 22:09:00.84707','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0566,366,20,'2024-03-01 15:04:59.844114','03F','2024-03-13 21:23:06.826622','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0628,724,20,'2024-02-16 11:38:04.844114','04A','2024-04-04 06:27:46.20277','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0668,897,20,'2024-03-23 14:28:24.844114','04B','2024-03-26 08:22:06.028896','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0723,526,20,'2024-02-21 11:16:48.844114','04C','1970-01-01','2024-04-15 07:20:04.944019','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0730,315,20,'2024-03-11 22:38:53.844114','04D','1970-01-01','2024-04-15 14:21:13.633296','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0862,319,20,'2024-04-04 14:06:26.844114','04E','2024-04-08 20:30:41.562093','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0928,95,20,'2024-04-01 07:45:02.844114','04F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0937,995,20,'2024-02-21 01:43:20.844114','05A','1970-01-01','2024-04-16 15:25:45.207921','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0988,126,20,'2024-02-16 01:08:14.844114','05B','2024-03-05 09:40:28.604807','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0010,206,21,'2024-03-12 12:22:13.844114','01A','2024-04-07 05:40:16.744578','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0082,881,21,'2024-03-07 16:28:45.844114','01B','2024-03-21 23:58:06.119631','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0114,571,21,'2024-03-20 02:42:51.844114','02A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0126,622,21,'2024-01-30 08:39:24.844114','02B','2024-04-02 15:47:26.561682','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0140,459,21,'2024-04-08 12:28:31.844114','02C','1970-01-01','2024-04-14 02:24:05.234532','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0144,989,21,'2024-03-25 12:31:32.844114','02D','2024-04-12 10:49:49.38843','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0215,920,21,'2024-01-20 07:35:02.844114','02E','2024-03-02 08:14:59.427321','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0219,825,21,'2024-03-24 13:54:49.844114','02F','1970-01-01','2024-04-15 07:38:46.934279','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0281,38,21,'2024-02-14 10:05:11.844114','03A','1970-01-01','2024-04-15 04:34:25.346518','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0351,818,21,'2024-04-04 18:16:45.844114','03B','2024-04-09 05:16:33.600189','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0442,443,21,'2024-01-25 02:31:40.844114','03C','1970-01-01','2024-04-16 13:25:25.636932','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0450,424,21,'2024-02-22 13:59:03.844114','03D','2024-03-15 08:56:40.091513','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0484,80,21,'2024-03-18 00:22:52.844114','03E','1970-01-01','2024-04-14 15:11:01.907826','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0558,138,21,'2024-03-08 10:11:52.844114','03F','2024-04-07 00:05:25.153968','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0757,710,21,'2024-03-29 02:36:26.844114','04A','1970-01-01','2024-04-15 14:35:41.067759','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0780,452,21,'2024-04-06 22:50:32.844114','04B','2024-04-07 05:11:35.383649','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0810,819,21,'2024-03-17 16:28:16.844114','04C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0815,925,21,'2024-04-02 22:25:20.844114','04D','2024-04-10 20:48:38.086389','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0884,295,21,'2024-03-09 16:46:46.844114','04E','1970-01-01','2024-04-14 20:13:29.575424','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0905,562,21,'2024-02-14 07:15:33.844114','04F','1970-01-01','2024-04-14 13:46:56.35905','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0962,645,21,'2024-03-29 05:01:49.844114','05A','2024-04-07 19:17:18.604022','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0052,930,22,'2024-02-22 10:25:11.844114','01A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0104,702,22,'2024-03-12 14:41:52.844114','01B','2024-04-09 02:44:56.612088','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0181,833,22,'2024-04-08 01:52:02.844114','02A','2024-04-10 17:29:15.491916','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0263,178,22,'2024-02-21 14:53:39.844114','02B','2024-03-25 02:19:19.173398','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0333,840,22,'2024-02-16 01:58:21.844114','02C','1970-01-01','2024-04-17 14:57:18.783745','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0370,43,22,'2024-04-08 20:09:24.844114','02D','1970-01-01','2024-04-17 02:35:40.51463','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0415,709,22,'2024-03-12 03:03:37.844114','02E','1970-01-01','2024-04-17 12:24:33.191376','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0418,642,22,'2024-02-10 10:40:16.844114','02F','2024-03-07 04:54:52.859813','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0419,132,22,'2024-03-12 13:50:38.844114','03A','2024-04-12 03:31:28.97415','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0513,339,22,'2024-02-23 03:10:03.844114','03B','1970-01-01','2024-04-14 21:03:17.839425','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0539,142,22,'2024-02-08 08:39:30.844114','03C','1970-01-01','2024-04-16 16:48:16.758529','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0548,592,22,'2024-03-20 06:02:44.844114','03D','1970-01-01','2024-04-16 14:45:02.487324','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0564,44,22,'2024-01-23 08:45:52.844114','03E','2024-03-02 11:18:24.741105','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0720,39,22,'2024-02-04 13:19:11.844114','03F','2024-03-25 10:59:51.199004','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0779,197,22,'2024-04-06 04:55:44.844114','04A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0792,496,22,'2024-02-14 14:41:48.844114','04B','2024-03-22 18:12:13.246619','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0797,309,22,'2024-02-01 12:25:14.844114','04C','2024-02-22 22:01:50.994063','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0844,868,22,'2024-02-28 12:44:55.844114','04D','2024-03-19 13:19:40.166765','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0861,774,22,'2024-01-27 19:26:02.844114','04E','1970-01-01','2024-04-14 00:26:47.759423','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0873,628,22,'2024-04-02 11:09:01.844114','04F','2024-04-12 05:18:34.457905','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0895,190,22,'2024-04-08 12:45:33.844114','05A','1970-01-01','2024-04-14 20:08:32.621749','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0978,147,22,'2024-03-04 17:00:11.844114','05B','2024-03-09 05:41:33.43947','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0986,846,22,'2024-02-02 23:50:07.844114','05C','2024-03-24 05:07:16.989189','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0037,475,23,'2024-01-24 05:00:04.844114','01A','1970-01-01','2024-04-14 00:39:59.319625','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0056,354,23,'2024-02-04 11:50:22.844114','01B','2024-02-13 19:47:32.549336','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0078,42,23,'2024-03-26 17:09:23.844114','02A','1970-01-01','2024-04-15 20:34:02.899891','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0099,22,23,'2024-02-06 09:43:04.844114','02B','1970-01-01','2024-04-15 07:30:03.426329','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0102,879,23,'2024-02-11 10:46:44.844114','02C','1970-01-01','2024-04-15 10:38:08.959349','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0109,446,23,'2024-03-30 23:42:54.844114','02D','2024-04-08 01:54:57.381746','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0141,426,23,'2024-03-10 03:07:01.844114','02E','2024-03-10 20:23:18.106626','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0253,387,23,'2024-02-12 23:26:42.844114','02F','1970-01-01','2024-04-15 10:36:43.668356','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0259,423,23,'2024-04-11 08:26:12.844114','03A','2024-04-16 09:26:35.176539','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0285,423,23,'2024-01-28 11:39:03.844114','03B','2024-04-15 22:13:41.832109','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0292,216,23,'2024-03-05 05:30:51.844114','03C','1970-01-01','2024-04-15 10:37:29.831034','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0316,209,23,'2024-03-23 06:56:00.844114','03D','2024-04-13 17:36:14.48683','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0324,886,23,'2024-01-31 12:37:04.844114','03E','2024-03-25 14:36:15.629886','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0369,782,23,'2024-01-19 20:29:23.844114','03F','2024-03-29 21:59:14.482362','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0389,24,23,'2024-02-28 09:37:04.844114','04A','1970-01-01','2024-04-16 17:15:40.863959','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0410,327,23,'2024-03-02 22:10:32.844114','04B','1970-01-01','2024-04-17 02:49:29.907098','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0428,967,23,'2024-03-03 15:33:59.844114','04C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0436,844,23,'2024-03-19 10:53:21.844114','04D','1970-01-01','2024-04-17 18:35:08.907658','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0522,823,23,'2024-02-03 14:22:54.844114','04E','2024-04-01 09:30:43.700634','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0525,317,23,'2024-02-03 15:39:26.844114','04F','1970-01-01','2024-04-16 16:11:15.161689','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0549,456,23,'2024-03-30 15:18:30.844114','05A','1970-01-01','2024-04-17 08:35:43.210275','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0601,630,23,'2024-02-14 22:08:11.844114','05B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0603,53,23,'2024-03-04 22:41:04.844114','05C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0729,224,23,'2024-03-26 19:00:12.844114','05D','2024-04-11 22:18:00.020359','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0898,914,23,'2024-02-24 00:01:17.844114','05E','2024-03-22 23:46:58.307402','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0974,323,23,'2024-03-17 11:20:10.844114','05F','2024-03-29 14:46:01.865566','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0005,179,24,'2024-02-14 17:53:59.844114','01A','2024-03-01 23:55:32.761679','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0017,978,24,'2024-01-26 00:54:30.844114','01B','1970-01-01','2024-04-17 00:42:32.570094','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0018,877,24,'2024-04-15 01:43:09.844114','02A','2024-04-15 23:55:24.62682','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0110,359,24,'2024-01-23 05:36:21.844114','02B','1970-01-01','2024-04-15 15:15:12.438895','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0190,265,24,'2024-03-18 14:28:09.844114','02C','2024-04-12 05:49:38.765551','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0233,852,24,'2024-04-10 12:15:42.844114','02D','1970-01-01','2024-04-15 05:47:53.491876','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0401,553,24,'2024-03-25 09:11:56.844114','02E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0402,238,24,'2024-04-10 03:34:04.844114','02F','1970-01-01','2024-04-16 22:11:06.642962','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0432,274,24,'2024-04-16 09:36:51.844114','03A','2024-04-16 09:42:13.739835','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0453,138,24,'2024-03-02 18:25:26.844114','03B','2024-03-11 09:09:35.639816','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0474,607,24,'2024-01-27 07:09:35.844114','03C','1970-01-01','2024-04-16 17:40:55.710307','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0511,226,24,'2024-01-23 22:36:25.844114','03D','2024-01-27 12:34:27.695399','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0516,475,24,'2024-02-07 17:48:03.844114','03E','2024-02-20 12:30:14.056174','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0585,395,24,'2024-02-11 22:25:15.844114','03F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0672,449,24,'2024-02-10 22:42:51.844114','04A','2024-03-08 09:22:58.551227','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0685,761,24,'2024-03-01 17:27:56.844114','04B','2024-03-25 23:50:49.203568','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0712,409,24,'2024-03-14 21:25:01.844114','04C','2024-03-26 15:30:08.867745','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0753,87,24,'2024-02-06 01:45:42.844114','04D','1970-01-01','2024-04-15 06:15:20.091647','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0765,412,24,'2024-03-18 10:30:38.844114','04E','2024-04-14 08:26:05.766575','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0883,358,24,'2024-02-02 21:51:52.844114','04F','1970-01-01','2024-04-14 06:46:02.458022','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0957,721,24,'2024-03-15 02:40:31.844114','05A','2024-04-01 14:44:15.322552','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0959,402,24,'2024-01-27 08:09:08.844114','05B','2024-03-13 19:57:12.978883','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0994,748,24,'2024-04-05 08:43:12.844114','05C','2024-04-06 19:58:28.138534','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0133,425,25,'2024-04-04 18:12:12.844114','01A','2024-04-09 17:36:06.057726','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0155,243,25,'2024-04-13 20:25:59.844114','01B','1970-01-01','2024-04-13 20:45:51.113437','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0235,696,25,'2024-04-03 16:30:33.844114','02A','2024-04-14 17:43:23.607847','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0261,961,25,'2024-04-11 21:20:25.844114','02B','1970-01-01','2024-04-15 10:57:45.236414','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0289,576,25,'2024-01-21 05:26:19.844114','02C','1970-01-01','2024-04-15 07:41:43.881552','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0312,5,25,'2024-04-13 21:17:21.844114','02D','1970-01-01','2024-04-15 19:43:46.410434','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0360,50,25,'2024-03-05 23:05:37.844114','02E','2024-04-02 11:06:30.800055','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0399,727,25,'2024-02-16 11:19:09.844114','02F','2024-03-09 15:25:22.451347','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0476,66,25,'2024-02-26 11:36:10.844114','03A','2024-03-05 02:00:45.240148','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0502,166,25,'2024-03-11 07:28:42.844114','03B','2024-03-26 23:31:20.997684','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0523,187,25,'2024-03-24 02:52:54.844114','03C','1970-01-01','2024-04-17 03:40:27.274837','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0574,603,25,'2024-02-22 13:24:15.844114','03D','2024-02-25 20:10:29.887931','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0587,165,25,'2024-02-19 00:52:24.844114','03E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0611,55,25,'2024-02-02 09:52:09.844114','03F','2024-02-13 03:51:17.120445','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0620,175,25,'2024-02-09 06:53:00.844114','04A','1970-01-01','2024-04-15 10:58:17.564973','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0625,916,25,'2024-03-14 23:35:39.844114','04B','1970-01-01','2024-04-15 19:46:04.952649','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0663,359,25,'2024-02-03 03:48:48.844114','04C','2024-02-13 21:58:04.607988','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0704,711,25,'2024-03-07 04:27:32.844114','04D','2024-03-20 00:05:18.152899','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0746,207,25,'2024-02-16 06:39:48.844114','04E','1970-01-01','2024-04-15 21:10:42.220747','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0751,720,25,'2024-03-14 17:04:46.844114','04F','2024-04-03 17:18:27.116977','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0756,765,25,'2024-03-08 10:43:46.844114','05A','1970-01-01','2024-04-15 02:56:07.316146','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0886,764,25,'2024-03-16 00:35:50.844114','05B','2024-04-06 21:07:15.722363','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0068,700,26,'2024-02-19 00:49:36.844114','01A','2024-03-24 09:45:03.162063','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0166,524,26,'2024-04-02 07:41:37.844114','01B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0180,495,26,'2024-04-12 07:33:07.844114','02A','2024-04-14 23:16:11.692874','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0209,14,26,'2024-02-29 04:04:41.844114','02B','2024-04-12 05:45:18.719336','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0255,208,26,'2024-02-03 07:36:49.844114','02C','1970-01-01','2024-04-15 02:02:18.324763','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0299,969,26,'2024-02-17 19:05:13.844114','02D','2024-03-03 16:21:11.523635','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0365,88,26,'2024-03-16 10:56:28.844114','02E','2024-04-11 09:09:04.306745','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0412,466,26,'2024-03-02 20:53:55.844114','02F','2024-04-14 00:56:52.947862','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0489,490,26,'2024-03-16 08:29:23.844114','03A','2024-04-14 19:10:30.912857','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0530,335,26,'2024-02-04 08:51:34.844114','03B','1970-01-01','2024-04-17 05:04:12.227746','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0622,609,26,'2024-03-18 11:27:15.844114','03C','1970-01-01','2024-04-14 22:30:52.435659','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0627,744,26,'2024-03-24 09:07:15.844114','03D','2024-04-09 16:49:11.028876','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0688,990,26,'2024-03-22 15:42:08.844114','03E','1970-01-01','2024-04-15 11:45:51.036218','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0727,292,26,'2024-03-15 17:10:14.844114','03F','2024-03-31 06:23:23.87222','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0803,461,26,'2024-01-26 00:01:23.844114','04A','1970-01-01','2024-04-14 19:08:59.02729','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0816,823,26,'2024-01-27 06:42:59.844114','04B','1970-01-01','2024-04-14 09:00:57.394947','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0821,448,26,'2024-01-22 15:25:46.844114','04C','1970-01-01','2024-04-14 03:34:45.010926','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0836,896,26,'2024-04-03 18:36:35.844114','04D','2024-04-10 06:34:38.530105','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0858,609,26,'2024-03-05 06:40:19.844114','04E','1970-01-01','2024-04-13 23:53:58.048696','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0874,431,26,'2024-02-21 21:55:50.844114','04F','2024-04-05 05:39:53.366087','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0897,173,26,'2024-01-20 14:05:12.844114','05A','2024-03-21 01:48:22.282199','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0908,11,26,'2024-04-02 22:55:54.844114','05B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0950,92,26,'2024-02-06 10:12:26.844114','05C','1970-01-01','2024-04-17 06:37:40.506909','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0047,481,27,'2024-03-30 09:30:40.844114','01A','1970-01-01','2024-04-14 10:11:49.92089','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0059,487,27,'2024-03-05 06:17:13.844114','01B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0106,485,27,'2024-02-29 07:45:59.844114','02A','2024-03-29 23:58:39.028928','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0189,549,27,'2024-03-15 03:12:25.844114','02B','2024-03-31 22:12:24.258197','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0302,271,27,'2024-03-16 17:49:05.844114','02C','2024-04-02 15:14:20.906612','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0304,809,27,'2024-02-25 16:52:23.844114','02D','2024-02-29 07:49:32.23076','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0322,730,27,'2024-03-14 16:05:31.844114','02E','2024-04-09 05:50:09.47295','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0524,461,27,'2024-04-03 12:38:41.844114','02F','1970-01-01','2024-04-16 20:01:43.245823','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0526,796,27,'2024-02-11 04:53:49.844114','03A','1970-01-01','2024-04-16 18:30:16.257488','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0543,41,27,'2024-04-11 06:47:55.844114','03B','1970-01-01','2024-04-16 18:37:59.408264','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0575,32,27,'2024-04-14 16:55:22.844114','03C','2024-04-14 22:07:58.707422','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0626,710,27,'2024-03-05 11:12:29.844114','03D','1970-01-01','2024-04-15 18:03:10.803982','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0647,732,27,'2024-03-15 22:57:20.844114','03E','1970-01-01','2024-04-15 16:14:52.482434','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0693,783,27,'2024-03-14 08:03:18.844114','03F','2024-03-25 01:55:35.465328','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0705,103,27,'2024-02-16 03:58:13.844114','04A','1970-01-01','2024-04-15 13:03:03.260776','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0707,219,27,'2024-03-04 05:55:43.844114','04B','1970-01-01','2024-04-15 19:37:33.733005','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0708,535,27,'2024-02-04 20:47:13.844114','04C','2024-03-15 22:03:53.538834','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0826,114,27,'2024-02-23 12:51:31.844114','04D','2024-03-15 17:38:22.633321','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0840,403,27,'2024-01-23 15:04:37.844114','04E','2024-04-12 05:22:10.061008','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0866,655,27,'2024-03-04 13:15:51.844114','04F','2024-03-30 03:09:49.415304','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0876,235,27,'2024-03-08 15:59:10.844114','05A','1970-01-01','2024-04-13 20:32:24.070989','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0900,503,27,'2024-02-22 14:42:46.844114','05B','2024-03-22 12:26:03.023625','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0909,618,27,'2024-02-23 04:16:37.844114','05C','1970-01-01','2024-04-14 06:46:16.301602','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0935,296,27,'2024-02-19 20:38:32.844114','05D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0086,349,28,'2024-03-17 18:19:51.844114','01A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0103,699,28,'2024-01-24 02:57:40.844114','01B','2024-03-28 00:32:11.282906','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0129,850,28,'2024-01-18 12:53:01.844114','02A','1970-01-01','2024-04-14 02:06:24.207584','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0132,923,28,'2024-01-30 00:02:46.844114','02B','2024-03-22 00:10:46.547564','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0176,42,28,'2024-02-17 03:59:19.844114','02C','2024-04-13 11:53:18.705915','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0182,147,28,'2024-01-21 21:36:07.844114','02D','1970-01-01','2024-04-13 20:36:06.75764','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0387,255,28,'2024-02-22 22:58:05.844114','02E','1970-01-01','2024-04-16 13:59:32.185035','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0420,635,28,'2024-02-14 05:49:10.844114','02F','2024-04-07 08:14:24.060802','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0507,481,28,'2024-04-09 23:20:11.844114','03A','1970-01-01','2024-04-14 06:45:41.443518','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0514,309,28,'2024-04-07 13:29:41.844114','03B','1970-01-01','2024-04-14 09:55:04.955261','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0518,37,28,'2024-03-27 20:26:40.844114','03C','2024-03-29 22:37:27.605951','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0527,230,28,'2024-01-22 19:56:19.844114','03D','2024-03-08 03:45:53.827704','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0818,964,28,'2024-02-25 14:28:31.844114','03E','1970-01-01','2024-04-14 06:36:21.134166','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0820,797,28,'2024-02-28 12:22:28.844114','03F','2024-04-04 01:04:26.726662','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0920,678,28,'2024-02-19 12:59:29.844114','04A','1970-01-01','2024-04-16 12:28:09.863711','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0947,710,28,'2024-03-07 16:25:01.844114','04B','1970-01-01','2024-04-16 20:25:32.434636','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0958,614,28,'2024-03-14 08:32:13.844114','04C','2024-04-09 17:59:37.892634','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0971,840,28,'2024-03-09 10:11:53.844114','04D','1970-01-01','2024-04-17 15:03:53.688548','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0006,145,29,'2024-02-24 04:03:41.844114','01A','2024-04-14 13:16:49.405035','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0064,443,29,'2024-01-27 17:05:05.844114','01B','2024-03-28 15:56:22.787699','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0120,742,29,'2024-03-31 09:31:01.844114','02A','1970-01-01','2024-04-13 22:54:23.136415','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0145,166,29,'2024-03-29 00:57:16.844114','02B','2024-04-14 12:25:51.903039','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0167,381,29,'2024-03-17 22:29:42.844114','02C','1970-01-01','2024-04-14 05:46:55.160034','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0310,86,29,'2024-02-02 02:26:28.844114','02D','2024-04-05 01:14:27.957946','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0317,552,29,'2024-03-29 17:00:03.844114','02E','2024-04-10 22:02:55.870348','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0349,286,29,'2024-01-28 22:48:37.844114','02F','2024-03-15 16:57:22.158769','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0374,636,29,'2024-02-16 23:06:26.844114','03A','1970-01-01','2024-04-16 12:46:40.152979','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0397,416,29,'2024-02-29 06:59:36.844114','03B','2024-03-03 14:26:05.895404','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0404,275,29,'2024-03-23 00:29:49.844114','03C','2024-04-03 03:57:29.696794','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0488,886,29,'2024-03-29 13:57:22.844114','03D','1970-01-01','2024-04-14 07:22:07.179195','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0528,676,29,'2024-03-23 02:12:24.844114','03E','1970-01-01','2024-04-17 00:53:02.176404','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0569,836,29,'2024-03-13 05:55:03.844114','03F','2024-03-18 07:09:18.501507','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0657,500,29,'2024-04-07 13:28:44.844114','04A','1970-01-01','2024-04-15 17:09:57.919328','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0709,798,29,'2024-02-15 19:37:05.844114','04B','1970-01-01','2024-04-15 16:24:22.552954','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0732,5,29,'2024-02-17 06:15:47.844114','04C','2024-04-02 23:39:37.095537','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0745,43,29,'2024-04-14 11:46:11.844114','04D','2024-04-15 09:42:04.132542','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0829,909,29,'2024-03-14 00:13:53.844114','04E','1970-01-01','2024-04-14 20:09:33.190916','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0860,860,29,'2024-04-15 08:56:16.844114','04F','2024-04-15 14:06:44.875494','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0892,384,29,'2024-01-31 17:42:57.844114','05A','2024-02-18 04:57:56.555448','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0919,31,29,'2024-04-05 13:28:09.844114','05B','2024-04-16 00:43:48.256019','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0933,855,29,'2024-02-24 08:16:56.844114','05C','2024-03-06 23:36:37.433446','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0960,353,29,'2024-02-15 10:10:48.844114','05D','1970-01-01','2024-04-18 07:28:53.239317','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0973,230,29,'2024-01-21 19:42:28.844114','05E','2024-03-14 08:55:39.172681','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0982,674,29,'2024-03-17 19:47:01.844114','05F','2024-03-31 23:41:35.720513','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0997,713,29,'2024-04-06 00:35:56.844114','06A','1970-01-01','2024-04-15 01:36:59.453976','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0076,384,30,'2024-02-25 12:25:21.844114','01A','1970-01-01','2024-04-16 00:15:13.788725','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0203,673,30,'2024-04-10 10:21:51.844114','01B','2024-04-11 01:38:54.841607','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0239,814,30,'2024-02-27 01:34:09.844114','02A','1970-01-01','2024-04-15 02:39:44.518975','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0240,959,30,'2024-02-20 05:33:07.844114','02B','2024-02-23 22:38:12.535177','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0321,120,30,'2024-04-02 21:42:51.844114','02C','2024-04-11 09:53:04.292324','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0403,129,30,'2024-03-07 04:50:17.844114','02D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0425,487,30,'2024-04-08 11:53:10.844114','02E','2024-04-15 18:21:49.874699','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0463,156,30,'2024-03-19 14:13:40.844114','02F','1970-01-01','2024-04-16 11:39:09.60369','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0580,230,30,'2024-04-13 08:48:11.844114','03A','2024-04-14 19:51:09.060274','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0613,483,30,'2024-02-27 18:09:59.844114','03B','2024-03-16 09:21:10.005743','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0623,338,30,'2024-02-06 15:23:56.844114','03C','1970-01-01','2024-04-15 16:59:56.80721','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0917,1000,30,'2024-03-03 01:20:14.844114','03D','1970-01-01','2024-04-16 14:52:36.507449','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0048,812,31,'2024-03-20 22:15:35.844114','01A','2024-04-13 07:37:36.80825','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0158,511,31,'2024-04-05 09:18:45.844114','01B','1970-01-01','2024-04-13 11:14:10.97564','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0201,244,31,'2024-03-17 10:15:50.844114','02A','1970-01-01','2024-04-15 13:18:34.663657','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0218,67,31,'2024-02-07 01:33:13.844114','02B','2024-02-23 06:42:44.579878','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0244,198,31,'2024-02-22 09:58:43.844114','02C','1970-01-01','2024-04-15 11:19:40.66393','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0264,57,31,'2024-02-01 05:09:05.844114','02D','2024-03-20 20:51:41.026358','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0319,16,31,'2024-04-09 09:30:31.844114','02E','2024-04-11 00:26:39.119674','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0468,614,31,'2024-02-24 17:38:58.844114','02F','2024-03-20 11:46:03.723058','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0510,327,31,'2024-03-07 08:22:26.844114','03A','2024-03-21 04:21:27.758873','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0529,643,31,'2024-02-27 18:12:20.844114','03B','2024-03-20 19:25:25.272305','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0533,904,31,'2024-02-17 15:20:29.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0770,221,31,'2024-04-01 12:04:13.844114','03D','2024-04-02 19:39:45.796964','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0772,751,31,'2024-02-07 15:51:01.844114','03E','2024-02-09 01:48:31.632524','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0793,115,31,'2024-04-05 05:54:37.844114','03F','1970-01-01','2024-04-16 09:07:36.751686','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0851,276,31,'2024-04-04 06:03:44.844114','04A','2024-04-07 17:46:23.368175','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0854,373,31,'2024-01-24 06:56:02.844114','04B','2024-02-12 01:02:55.963501','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0940,432,31,'2024-03-29 18:42:24.844114','04C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0003,237,32,'2024-03-01 21:54:44.844114','01A','2024-03-24 17:43:08.763124','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0020,301,32,'2024-03-03 05:58:06.844114','01B','2024-04-04 03:52:58.918728','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0024,499,32,'2024-02-03 09:31:44.844114','02A','1970-01-01','2024-04-17 03:58:34.305569','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0079,113,32,'2024-04-04 00:34:30.844114','02B','1970-01-01','2024-04-15 20:41:09.183165','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0153,883,32,'2024-01-26 19:07:39.844114','02C','2024-04-03 13:08:18.72387','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0224,831,32,'2024-01-29 18:16:01.844114','02D','1970-01-01','2024-04-15 15:39:01.266358','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0265,695,32,'2024-03-18 10:42:27.844114','02E','1970-01-01','2024-04-14 23:45:19.794037','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0320,850,32,'2024-03-30 02:12:24.844114','02F','2024-04-12 02:20:57.700656','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0362,914,32,'2024-01-27 10:03:15.844114','03A','1970-01-01','2024-04-17 04:50:35.592031','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0392,793,32,'2024-01-25 12:43:47.844114','03B','1970-01-01','2024-04-17 04:16:01.418718','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0449,335,32,'2024-02-13 10:06:12.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0477,523,32,'2024-03-23 22:48:08.844114','03D','1970-01-01','2024-04-15 03:31:33.512912','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0490,85,32,'2024-03-15 15:24:30.844114','03E','2024-04-16 02:18:52.659255','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0501,611,32,'2024-01-20 11:47:02.844114','03F','1970-01-01','2024-04-14 13:25:26.191256','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0618,850,32,'2024-02-18 12:10:37.844114','04A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0717,173,32,'2024-03-01 13:39:51.844114','04B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0794,297,32,'2024-02-22 04:07:36.844114','04C','2024-03-15 17:47:58.952324','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0948,698,32,'2024-02-11 23:00:24.844114','04D','1970-01-01','2024-04-17 06:57:07.012756','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0123,150,33,'2024-01-22 02:17:59.844114','01A','1970-01-01','2024-04-14 07:19:19.126037','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0205,358,33,'2024-03-11 20:55:11.844114','01B','2024-03-12 07:21:24.559401','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0223,228,33,'2024-02-10 07:16:44.844114','02A','1970-01-01','2024-04-14 23:26:13.285238','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0225,368,33,'2024-04-14 00:54:02.844114','02B','1970-01-01','2024-04-15 14:02:28.956751','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0272,568,33,'2024-03-17 13:55:46.844114','02C','2024-04-09 19:36:25.476344','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0366,264,33,'2024-01-19 22:44:58.844114','02D','1970-01-01','2024-04-16 20:28:53.917817','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0409,371,33,'2024-04-05 01:59:13.844114','02E','2024-04-14 14:05:51.008078','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0421,34,33,'2024-01-30 06:56:25.844114','02F','2024-03-10 11:39:05.336939','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0466,655,33,'2024-04-10 16:35:18.844114','03A','2024-04-15 10:55:37.78873','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0517,466,33,'2024-01-19 10:43:47.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0588,603,33,'2024-02-26 15:46:57.844114','03C','1970-01-01','2024-04-14 04:47:46.138813','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0634,548,33,'2024-03-22 13:01:51.844114','03D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0642,268,33,'2024-03-06 15:44:15.844114','03E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0669,392,33,'2024-02-02 15:50:18.844114','03F','2024-03-12 00:39:48.531549','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0698,548,33,'2024-03-28 06:17:32.844114','04A','2024-03-31 01:33:58.48395','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0716,156,33,'2024-03-08 05:29:37.844114','04B','2024-03-31 16:36:13.381156','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0748,223,33,'2024-02-20 12:53:51.844114','04C','2024-03-06 23:50:27.615552','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0798,614,33,'2024-02-08 17:52:09.844114','04D','2024-03-27 00:11:52.936124','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0890,298,33,'2024-03-06 23:29:01.844114','04E','2024-03-15 05:03:43.414325','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0903,846,33,'2024-01-28 13:42:55.844114','04F','1970-01-01','2024-04-14 02:47:02.111677','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0942,893,33,'2024-04-16 01:30:44.844114','05A','2024-04-16 05:30:52.902047','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0021,164,34,'2024-03-13 14:19:14.844114','01A','1970-01-01','2024-04-17 05:14:07.373552','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0101,99,34,'2024-01-29 21:31:22.844114','01B','2024-03-02 23:13:38.595371','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0118,852,34,'2024-02-21 12:13:29.844114','02A','1970-01-01','2024-04-14 07:43:56.960677','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0267,353,34,'2024-03-29 10:01:48.844114','02B','2024-04-06 04:51:56.475796','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0294,68,34,'2024-02-09 00:43:59.844114','02C','2024-03-17 16:01:10.362594','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0305,521,34,'2024-02-25 09:51:23.844114','02D','1970-01-01','2024-04-15 07:28:02.280236','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0452,198,34,'2024-02-12 20:23:27.844114','02E','2024-02-15 02:52:40.508424','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0497,673,34,'2024-02-06 19:02:17.844114','02F','1970-01-01','2024-04-14 12:22:13.519237','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0544,880,34,'2024-02-06 20:29:09.844114','03A','2024-02-20 12:28:50.957337','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0571,773,34,'2024-02-16 23:38:55.844114','03B','1970-01-01','2024-04-17 02:28:40.061742','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0583,947,34,'2024-04-01 09:22:26.844114','03C','2024-04-04 01:40:20.867922','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0604,664,34,'2024-01-29 08:49:45.844114','03D','2024-02-02 17:47:27.437234','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0654,423,34,'2024-01-31 23:08:51.844114','03E','1970-01-01','2024-04-15 13:33:12.045148','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0719,380,34,'2024-03-22 18:45:01.844114','03F','2024-03-30 13:13:29.27321','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0842,496,34,'2024-03-19 19:40:28.844114','04A','1970-01-01','2024-04-14 08:28:52.446267','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0875,928,34,'2024-03-03 20:23:09.844114','04B','2024-03-27 07:04:26.724483','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0880,615,34,'2024-02-29 18:34:17.844114','04C','2024-03-14 05:24:07.227909','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0955,910,34,'2024-03-02 11:26:26.844114','04D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0990,260,34,'2024-04-15 03:43:06.844114','04E','2024-04-15 06:09:07.573951','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0023,61,35,'2024-01-31 04:21:37.844114','01A','1970-01-01','2024-04-17 05:06:39.142192','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0077,284,35,'2024-03-06 20:27:39.844114','01B','2024-03-11 18:43:05.003737','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0115,41,35,'2024-03-15 05:37:32.844114','02A','2024-03-19 01:08:27.0734','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0169,384,35,'2024-02-09 23:22:48.844114','02B','1970-01-01','2024-04-14 11:28:12.157665','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0269,947,35,'2024-03-06 10:34:45.844114','02C','2024-04-04 12:29:42.136465','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0271,885,35,'2024-04-03 04:29:03.844114','02D','2024-04-03 16:56:02.367631','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0300,701,35,'2024-03-03 15:33:50.844114','02E','1970-01-01','2024-04-15 17:40:27.947767','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0388,608,35,'2024-03-25 18:18:48.844114','02F','2024-04-04 18:05:17.469424','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0447,718,35,'2024-01-24 11:54:21.844114','03A','2024-01-26 19:11:55.26396','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0606,169,35,'2024-01-31 09:16:50.844114','03B','2024-02-18 20:03:04.770896','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0609,211,35,'2024-02-19 13:20:08.844114','03C','2024-04-16 08:38:20.559406','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0615,943,35,'2024-03-25 07:16:25.844114','03D','2024-04-10 12:26:52.319039','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0696,491,35,'2024-02-15 12:31:33.844114','03E','2024-03-22 01:47:21.337339','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0789,560,35,'2024-03-02 01:41:27.844114','03F','2024-04-05 18:36:14.387846','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0859,708,35,'2024-02-24 22:59:52.844114','04A','2024-04-14 20:10:59.109366','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0863,632,35,'2024-02-22 09:55:53.844114','04B','2024-03-19 21:54:28.14729','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0996,601,35,'2024-04-10 22:16:44.844114','04C','2024-04-12 11:59:02.005722','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0069,668,36,'2024-01-22 04:20:53.844114','01A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0183,593,36,'2024-02-12 18:59:48.844114','01B','2024-03-22 18:48:40.755627','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0186,321,36,'2024-01-21 04:25:23.844114','02A','2024-01-30 05:44:57.813037','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0187,54,36,'2024-03-01 13:59:47.844114','02B','1970-01-01','2024-04-13 19:22:34.630856','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0238,964,36,'2024-02-27 01:44:08.844114','02C','2024-04-13 22:37:55.35319','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0291,599,36,'2024-01-28 19:51:00.844114','02D','1970-01-01','2024-04-15 11:21:10.488675','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0314,605,36,'2024-03-03 15:11:36.844114','02E','2024-04-13 13:38:25.252791','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0327,606,36,'2024-03-02 20:29:18.844114','02F','1970-01-01','2024-04-17 11:24:27.321752','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0396,805,36,'2024-02-22 12:04:35.844114','03A','2024-03-18 08:22:28.810746','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0541,648,36,'2024-01-23 19:14:18.844114','03B','2024-01-30 10:06:06.616431','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0562,905,36,'2024-03-28 07:02:14.844114','03C','1970-01-01','2024-04-17 09:51:01.076512','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0563,933,36,'2024-03-04 07:12:24.844114','03D','1970-01-01','2024-04-17 12:01:06.400567','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0682,244,36,'2024-02-22 20:35:02.844114','03E','1970-01-01','2024-04-15 16:13:28.43379','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0687,843,36,'2024-03-10 14:35:47.844114','03F','1970-01-01','2024-04-15 18:44:35.259434','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0689,620,36,'2024-03-09 03:18:58.844114','04A','2024-03-29 22:06:06.523572','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0694,852,36,'2024-01-23 20:08:21.844114','04B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0740,741,36,'2024-03-03 03:17:16.844114','04C','2024-04-16 06:53:33.371277','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0750,19,36,'2024-03-27 17:10:57.844114','04D','1970-01-01','2024-04-15 14:32:28.52501','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0767,548,36,'2024-04-15 22:52:40.844114','04E','1970-01-01','2024-04-16 07:41:14.900025','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0787,252,36,'2024-01-19 13:05:35.844114','04F','2024-01-21 09:16:17.279538','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0921,469,36,'2024-01-31 15:44:29.844114','05A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0998,543,36,'2024-01-18 17:38:00.844114','05B','2024-01-31 22:38:28.316588','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0093,509,37,'2024-02-25 15:53:23.844114','01A','2024-04-07 17:21:31.154519','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0105,999,37,'2024-02-10 07:29:19.844114','01B','1970-01-01','2024-04-16 02:59:36.022267','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0232,613,37,'2024-02-21 13:54:10.844114','02A','2024-04-10 17:40:15.291795','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0254,723,37,'2024-03-02 04:06:51.844114','02B','2024-03-24 03:24:10.439129','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0270,377,37,'2024-03-22 15:13:45.844114','02C','2024-04-01 01:45:01.785554','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0276,834,37,'2024-02-18 06:29:17.844114','02D','2024-03-01 14:28:27.492158','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0371,233,37,'2024-02-27 20:48:34.844114','02E','1970-01-01','2024-04-17 03:11:32.158341','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0379,726,37,'2024-03-28 23:48:05.844114','02F','2024-04-14 13:25:25.640906','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0408,21,37,'2024-04-12 10:46:48.844114','03A','2024-04-14 20:27:28.848621','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0417,66,37,'2024-04-16 07:21:27.844114','03B','2024-04-16 09:35:30.415002','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0478,519,37,'2024-03-27 12:11:24.844114','03C','2024-04-10 17:43:10.439984','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0486,68,37,'2024-01-25 19:50:55.844114','03D','2024-04-15 16:36:02.642252','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0659,337,37,'2024-01-27 19:09:22.844114','03E','2024-04-16 09:34:38.940892','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0667,504,37,'2024-03-03 07:46:44.844114','03F','2024-04-08 22:31:52.810837','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0722,849,37,'2024-04-14 14:54:47.844114','04A','1970-01-01','2024-04-15 12:24:56.361427','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0725,625,37,'2024-02-03 01:13:36.844114','04B','1970-01-01','2024-04-15 10:37:42.110682','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0773,970,37,'2024-03-03 15:52:46.844114','04C','2024-03-13 02:13:46.831921','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0785,280,37,'2024-01-24 12:10:58.844114','04D','1970-01-01','2024-04-15 19:47:45.287797','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0807,873,37,'2024-04-08 02:17:20.844114','04E','1970-01-01','2024-04-14 02:26:56.055646','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0868,769,37,'2024-02-21 15:24:35.844114','04F','2024-03-19 16:59:44.347182','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0074,740,38,'2024-02-16 12:27:46.844114','01A','1970-01-01','2024-04-14 06:41:31.081521','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0193,712,38,'2024-04-10 14:00:50.844114','01B','2024-04-16 07:59:02.964796','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0198,587,38,'2024-02-08 02:34:29.844114','02A','2024-03-11 04:06:53.174078','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0213,952,38,'2024-01-31 12:08:34.844114','02B','1970-01-01','2024-04-15 04:51:06.108146','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0241,530,38,'2024-04-01 17:48:50.844114','02C','1970-01-01','2024-04-15 07:13:40.455182','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0268,668,38,'2024-02-09 16:57:40.844114','02D','2024-02-18 11:10:34.507995','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0309,187,38,'2024-03-08 14:18:27.844114','02E','2024-04-05 11:47:54.693154','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0344,861,38,'2024-02-15 03:35:09.844114','02F','2024-02-25 18:03:15.824167','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0346,451,38,'2024-02-05 01:47:39.844114','03A','1970-01-01','2024-04-17 09:11:33.557692','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0429,787,38,'2024-02-01 01:44:35.844114','03B','2024-03-25 11:25:39.067442','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0483,243,38,'2024-04-14 04:18:30.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0485,26,38,'2024-02-19 17:36:55.844114','03D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0578,134,38,'2024-03-05 07:49:10.844114','03E','2024-04-09 16:28:19.543193','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0636,197,38,'2024-01-21 06:47:09.844114','03F','1970-01-01','2024-04-15 05:55:49.743649','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0671,264,38,'2024-01-26 09:40:36.844114','04A','2024-03-10 14:56:14.94917','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0702,787,38,'2024-04-08 07:21:43.844114','04B','2024-04-14 03:12:39.158601','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0741,148,38,'2024-02-02 22:37:04.844114','04C','1970-01-01','2024-04-15 12:35:14.892506','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0742,255,38,'2024-03-03 01:24:23.844114','04D','1970-01-01','2024-04-15 09:31:05.852615','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0799,642,38,'2024-03-30 21:20:18.844114','04E','1970-01-01','2024-04-14 07:03:52.724503','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0845,310,38,'2024-02-12 19:38:48.844114','04F','2024-03-02 06:36:05.867721','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0850,235,38,'2024-03-07 18:08:46.844114','05A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0914,240,38,'2024-01-19 06:24:11.844114','05B','2024-04-11 07:58:02.771328','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0044,781,39,'2024-03-22 14:34:05.844114','01A','2024-04-02 06:12:08.676955','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0058,42,39,'2024-02-10 13:30:47.844114','01B','2024-04-10 09:57:23.367484','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0172,875,39,'2024-04-04 05:29:27.844114','02A','2024-04-09 08:50:00.746717','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0175,497,39,'2024-04-03 15:29:57.844114','02B','2024-04-08 13:32:26.066838','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0211,789,39,'2024-02-07 21:46:57.844114','02C','2024-03-11 20:37:15.198992','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0216,257,39,'2024-02-19 12:21:06.844114','02D','2024-03-15 14:35:30.040606','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0226,879,39,'2024-04-04 05:15:27.844114','02E','1970-01-01','2024-04-15 13:59:46.572879','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0236,749,39,'2024-03-14 08:22:34.844114','02F','2024-04-05 01:26:38.429316','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0246,128,39,'2024-02-21 10:06:29.844114','03A','2024-04-13 05:33:58.511801','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0303,358,39,'2024-02-01 05:31:00.844114','03B','1970-01-01','2024-04-15 13:36:28.072754','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0422,802,39,'2024-04-03 22:27:33.844114','03C','1970-01-01','2024-04-17 08:05:23.188489','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0426,838,39,'2024-01-29 15:31:42.844114','03D','2024-03-09 11:37:36.149315','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0471,485,39,'2024-01-25 09:50:54.844114','03E','1970-01-01','2024-04-15 23:33:12.713284','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0482,714,39,'2024-03-30 15:57:56.844114','03F','2024-04-08 07:54:59.36183','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0493,419,39,'2024-02-10 16:33:59.844114','04A','2024-02-26 16:30:47.009148','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0521,118,39,'2024-02-09 09:18:43.844114','04B','2024-02-17 14:24:41.75311','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0565,65,39,'2024-03-22 00:31:50.844114','04C','2024-03-29 00:02:24.398279','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0590,147,39,'2024-04-05 16:44:58.844114','04D','2024-04-12 23:30:35.421911','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0617,608,39,'2024-04-15 18:49:22.844114','04E','1970-01-01','2024-04-14 21:10:48.876185','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0703,363,39,'2024-01-26 21:46:12.844114','04F','2024-04-03 04:03:37.229768','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0739,513,39,'2024-02-28 12:36:41.844114','05A','1970-01-01','2024-04-15 21:39:52.680871','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0754,971,39,'2024-02-23 05:12:11.844114','05B','1970-01-01','2024-04-15 05:52:39.811087','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0802,717,39,'2024-03-02 14:15:39.844114','05C','2024-03-29 07:58:13.907072','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0806,615,39,'2024-02-16 17:53:07.844114','05D','2024-03-06 11:44:34.032349','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0001,420,40,'2024-01-19 12:48:04.844114','01A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0015,409,40,'2024-04-15 17:32:21.844114','01B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0160,87,40,'2024-02-24 17:04:38.844114','02A','1970-01-01','2024-04-14 05:33:58.130635','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0227,532,40,'2024-02-14 16:12:02.844114','02B','2024-03-27 17:41:22.67984','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0250,714,40,'2024-01-20 09:23:37.844114','02C','1970-01-01','2024-04-14 18:08:36.37914','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0282,615,40,'2024-04-10 15:20:21.844114','02D','1970-01-01','2024-04-15 19:12:59.803266','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0368,927,40,'2024-03-23 12:02:05.844114','02E','2024-04-04 01:57:04.811247','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0496,171,40,'2024-03-25 09:39:02.844114','02F','1970-01-01','2024-04-14 11:15:37.165317','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0512,636,40,'2024-01-22 23:53:53.844114','03A','2024-03-24 11:44:29.763932','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0535,644,40,'2024-04-08 17:00:47.844114','03B','2024-04-12 07:11:02.732859','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0581,673,40,'2024-03-13 09:12:09.844114','03C','2024-03-13 20:00:38.927876','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0629,399,40,'2024-02-21 11:02:34.844114','03D','2024-03-28 00:43:56.477456','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0643,861,40,'2024-03-25 20:46:59.844114','03E','2024-04-06 17:54:38.651958','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0734,596,40,'2024-04-09 11:42:06.844114','03F','2024-04-15 05:52:57.79269','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0796,191,40,'2024-01-31 05:21:55.844114','04A','2024-04-04 09:15:21.856538','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0865,777,40,'2024-03-02 10:40:04.844114','04B','2024-03-04 14:10:37.832371','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0923,821,40,'2024-02-27 15:40:24.844114','04C','2024-03-23 14:27:01.319954','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0062,235,41,'2024-03-12 18:02:58.844114','01A','2024-03-17 03:57:42.793012','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0124,472,41,'2024-03-14 15:44:08.844114','01B','2024-04-01 18:25:43.555882','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0340,57,41,'2024-02-08 13:20:37.844114','02A','2024-03-06 03:13:32.234615','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0342,99,41,'2024-01-24 15:49:58.844114','02B','2024-02-04 21:16:38.237215','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0348,221,41,'2024-02-04 18:00:44.844114','02C','2024-03-31 22:13:10.718383','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0378,481,41,'2024-04-10 09:09:19.844114','02D','1970-01-01','2024-04-16 18:56:04.99374','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0439,612,41,'2024-01-24 13:15:34.844114','02E','2024-03-22 23:07:21.83848','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0469,823,41,'2024-03-06 23:26:43.844114','02F','1970-01-01','2024-04-16 07:47:58.245417','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0481,348,41,'2024-04-02 04:45:48.844114','03A','2024-04-15 13:57:10.532961','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0557,866,41,'2024-03-17 13:40:35.844114','03B','2024-03-21 20:26:03.878451','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0674,212,41,'2024-03-04 16:33:44.844114','03C','1970-01-01','2024-04-15 21:16:50.084532','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0678,506,41,'2024-03-30 05:10:29.844114','03D','1970-01-01','2024-04-15 16:45:27.441636','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0804,245,41,'2024-04-15 12:22:48.844114','03E','2024-04-15 21:40:22.91276','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0879,942,41,'2024-02-13 05:20:22.844114','03F','2024-02-23 03:29:06.650801','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0889,136,41,'2024-02-05 05:04:56.844114','04A','1970-01-01','2024-04-14 00:35:18.593657','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0913,123,41,'2024-02-06 16:11:45.844114','04B','1970-01-01','2024-04-16 14:09:25.85331','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0051,515,42,'2024-03-29 15:28:26.844114','01A','1970-01-01','2024-04-14 02:27:31.633203','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0084,331,42,'2024-02-12 01:29:18.844114','01B','2024-03-13 23:00:50.089962','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0111,431,42,'2024-02-16 16:33:31.844114','02A','2024-02-17 16:25:52.598403','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0143,364,42,'2024-04-08 23:21:36.844114','02B','1970-01-01','2024-04-13 13:49:42.326324','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0174,107,42,'2024-04-02 04:55:12.844114','02C','1970-01-01','2024-04-14 14:41:25.470175','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0230,867,42,'2024-04-04 01:25:55.844114','02D','2024-04-04 20:53:09.297626','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0277,840,42,'2024-04-14 10:55:26.844114','02E','2024-04-16 02:26:41.943516','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0278,13,42,'2024-01-25 03:51:08.844114','02F','1970-01-01','2024-04-15 07:10:04.467429','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0334,84,42,'2024-04-07 10:50:20.844114','03A','2024-04-13 00:02:11.724245','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0359,851,42,'2024-04-02 14:46:55.844114','03B','1970-01-01','2024-04-16 12:30:59.336304','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0373,987,42,'2024-02-03 01:07:39.844114','03C','2024-02-05 16:54:13.609309','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0375,57,42,'2024-04-03 09:20:18.844114','03D','1970-01-01','2024-04-16 06:57:24.24952','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0413,690,42,'2024-02-02 21:06:04.844114','03E','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0893,75,42,'2024-04-06 05:10:34.844114','03F','2024-04-15 17:40:55.768888','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0939,781,42,'2024-02-22 18:45:18.844114','04A','1970-01-01','2024-04-17 05:32:12.128277','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0944,151,42,'2024-03-03 19:16:54.844114','04B','2024-03-14 16:58:44.35289','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0993,996,42,'2024-04-16 04:11:15.844114','04C','2024-04-16 06:42:27.667091','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0054,103,43,'2024-01-22 07:27:25.844114','01A','1970-01-01','2024-04-14 12:29:58.597962','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0065,631,43,'2024-04-14 00:19:23.844114','01B','1970-01-01','2024-04-14 05:17:28.362014','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0127,471,43,'2024-04-11 10:04:32.844114','02A','2024-04-14 05:31:19.639429','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0137,863,43,'2024-01-24 03:28:13.844114','02B','2024-03-22 14:18:02.014088','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0170,608,43,'2024-02-17 07:01:47.844114','02C','1970-01-01','2024-04-14 07:34:03.065236','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0199,722,43,'2024-04-01 23:45:32.844114','02D','2024-04-06 03:00:21.434219','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0242,624,43,'2024-03-02 10:13:29.844114','02E','2024-03-04 10:53:39.85783','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0288,353,43,'2024-04-07 14:01:51.844114','02F','1970-01-01','2024-04-15 08:44:55.694942','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0306,973,43,'2024-02-17 12:15:13.844114','03A','2024-03-11 23:16:05.615443','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0311,643,43,'2024-03-23 09:04:07.844114','03B','1970-01-01','2024-04-15 10:34:20.975285','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0336,602,43,'2024-01-19 20:09:48.844114','03C','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0376,374,43,'2024-03-11 11:47:22.844114','03D','2024-03-29 04:11:13.817324','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0385,37,43,'2024-02-08 08:08:00.844114','03E','1970-01-01','2024-04-16 13:02:04.03121','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0441,297,43,'2024-01-30 03:40:16.844114','03F','2024-03-10 09:50:53.856595','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0641,294,43,'2024-02-25 01:38:29.844114','04A','1970-01-01','2024-04-15 19:34:53.762067','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0649,866,43,'2024-02-11 08:58:36.844114','04B','1970-01-01','2024-04-15 11:48:28.909468','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0670,869,43,'2024-03-22 01:21:05.844114','04C','2024-04-06 05:55:57.212701','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0690,676,43,'2024-03-14 17:10:00.844114','04D','2024-03-30 09:34:59.528723','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0737,374,43,'2024-03-03 08:46:52.844114','04E','2024-03-10 00:02:35.745373','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0782,546,43,'2024-03-12 09:19:20.844114','04F','1970-01-01','2024-04-16 11:57:13.67988','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0867,823,43,'2024-02-27 15:41:04.844114','05A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0881,680,43,'2024-03-26 12:59:46.844114','05B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0891,811,43,'2024-02-02 03:58:58.844114','05C','1970-01-01','2024-04-14 18:56:37.468211','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0963,609,43,'2024-01-20 16:52:37.844114','05D','1970-01-01','2024-04-18 06:33:20.525963','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0013,170,44,'2024-03-25 17:28:48.844114','01A','2024-04-09 02:20:49.026956','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0098,583,44,'2024-02-28 09:53:11.844114','01B','2024-03-30 08:50:56.783661','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0128,60,44,'2024-03-07 11:29:04.844114','02A','2024-03-14 09:12:25.350051','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0156,420,44,'2024-02-10 17:09:59.844114','02B','1970-01-01','2024-04-14 05:23:47.875158','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0157,979,44,'2024-01-31 06:25:43.844114','02C','1970-01-01','2024-04-13 11:52:40.896484','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0208,643,44,'2024-02-14 19:39:25.844114','02D','2024-03-12 00:38:15.573248','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0298,434,44,'2024-02-17 11:32:10.844114','02E','1970-01-01','2024-04-15 20:13:45.155294','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0357,69,44,'2024-02-23 21:42:09.844114','02F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0391,991,44,'2024-02-18 03:51:34.844114','03A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0431,54,44,'2024-02-24 10:50:34.844114','03B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0492,733,44,'2024-03-24 15:36:32.844114','03C','2024-04-15 05:57:13.79959','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0495,959,44,'2024-02-19 21:39:56.844114','03D','1970-01-01','2024-04-14 16:11:12.140128','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0547,531,44,'2024-03-06 09:31:59.844114','03E','2024-04-02 23:38:36.926459','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0570,596,44,'2024-03-17 22:45:17.844114','03F','1970-01-01','2024-04-16 19:00:49.353137','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0676,15,44,'2024-02-29 19:20:32.844114','04A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0956,912,44,'2024-02-04 13:27:00.844114','04B','2024-04-06 19:52:43.437222','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0992,93,44,'2024-03-04 15:31:57.844114','04C','2024-04-10 02:27:09.407577','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0029,151,45,'2024-04-01 18:33:28.844114','01A','1970-01-01','2024-04-16 22:52:57.937254','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0034,149,45,'2024-04-04 17:35:20.844114','01B','2024-04-08 16:08:31.658416','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0147,468,45,'2024-03-01 01:07:50.844114','02A','1970-01-01','2024-04-14 09:16:27.835397','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0148,924,45,'2024-02-22 07:07:44.844114','02B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0372,843,45,'2024-03-04 22:03:06.844114','02C','2024-04-06 19:40:31.47922','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0390,246,45,'2024-03-10 01:05:18.844114','02D','2024-03-23 19:25:26.854664','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0414,92,45,'2024-04-01 14:35:36.844114','02E','2024-04-01 17:24:58.767861','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0427,33,45,'2024-01-26 16:08:46.844114','02F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0438,640,45,'2024-04-15 02:06:05.844114','03A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0460,321,45,'2024-03-04 19:25:48.844114','03B','2024-04-10 05:00:54.10725','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0480,559,45,'2024-03-03 03:49:11.844114','03C','2024-04-03 08:30:59.617675','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0531,724,45,'2024-02-25 02:45:48.844114','03D','1970-01-01','2024-04-17 05:05:44.676146','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0538,976,45,'2024-04-08 15:49:51.844114','03E','2024-04-08 21:06:31.999835','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0600,327,45,'2024-02-08 05:02:44.844114','03F','1970-01-01','2024-04-13 23:52:26.28396','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0662,773,45,'2024-01-18 23:17:52.844114','04A','2024-02-08 02:39:12.470041','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0684,968,45,'2024-03-05 14:07:34.844114','04B','1970-01-01','2024-04-15 20:00:46.329739','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0695,391,45,'2024-01-24 06:07:07.844114','04C','2024-02-07 01:34:46.607973','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0768,803,45,'2024-02-22 21:12:10.844114','04D','2024-04-01 11:24:05.108639','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0813,343,45,'2024-01-26 14:04:11.844114','04E','2024-02-26 20:50:28.395586','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0835,744,45,'2024-01-25 00:57:24.844114','04F','1970-01-01','2024-04-14 13:29:54.99157','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0846,752,45,'2024-03-06 08:57:04.844114','05A','1970-01-01','2024-04-14 03:32:00.16748','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0894,986,45,'2024-02-23 20:30:19.844114','05B','1970-01-01','2024-04-14 01:27:13.864045','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0896,557,45,'2024-02-16 11:24:59.844114','05C','1970-01-01','2024-04-14 07:16:01.651725','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0976,144,45,'2024-03-13 23:20:22.844114','05D','1970-01-01','2024-04-18 06:11:22.465544','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0004,243,46,'2024-04-14 02:08:51.844114','01A','2024-04-15 11:24:21.192183','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0036,140,46,'2024-03-10 03:29:00.844114','01B','1970-01-01','2024-04-14 12:31:15.457076','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0136,212,46,'2024-02-18 16:48:53.844114','02A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0251,362,46,'2024-02-08 00:07:29.844114','02B','1970-01-01','2024-04-14 19:37:57.247843','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0262,806,46,'2024-02-29 20:49:43.844114','02C','2024-03-21 18:21:58.059698','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0341,71,46,'2024-04-03 22:10:56.844114','02D','2024-04-08 08:08:49.383802','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0383,675,46,'2024-01-19 07:35:19.844114','02E','2024-04-15 17:26:48.910601','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0395,382,46,'2024-03-21 09:38:11.844114','02F','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0416,549,46,'2024-03-05 08:45:30.844114','03A','1970-01-01','2024-04-16 21:52:10.211587','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0542,540,46,'2024-04-05 12:56:09.844114','03B','1970-01-01','2024-04-16 18:29:13.975749','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0594,844,46,'2024-02-20 00:55:18.844114','03C','1970-01-01','2024-04-13 20:23:51.413423','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0631,863,46,'2024-04-08 00:33:32.844114','03D','2024-04-13 12:01:31.865895','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0664,250,46,'2024-02-13 23:40:10.844114','03E','2024-04-06 22:40:46.813291','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0666,302,46,'2024-03-27 17:05:57.844114','03F','1970-01-01','2024-04-16 04:06:18.590703','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0764,127,46,'2024-03-20 06:16:59.844114','04A','2024-04-08 07:57:12.105014','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0790,424,46,'2024-02-12 21:11:06.844114','04B','2024-02-22 22:48:21.515377','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0814,173,46,'2024-02-04 08:53:41.844114','04C','1970-01-01','2024-04-14 19:46:26.298134','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0848,637,46,'2024-02-07 21:51:59.844114','04D','1970-01-01','2024-04-14 05:58:53.98336','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0911,242,46,'2024-04-04 07:03:47.844114','04E','2024-04-09 07:38:20.40154','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0946,227,46,'2024-04-05 14:27:40.844114','04F','1970-01-01','2024-04-17 02:56:42.398761','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0975,914,46,'2024-01-24 00:16:32.844114','05A','2024-01-27 20:14:02.128476','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0999,684,46,'2024-03-18 12:13:11.844114','05B','2024-04-08 20:01:48.197648','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0245,7,47,'2024-03-29 13:18:29.844114','01A','2024-04-02 09:09:31.713186','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0307,855,47,'2024-02-10 15:08:44.844114','01B','2024-03-16 17:07:38.414673','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0338,38,47,'2024-04-10 19:34:07.844114','02A','2024-04-13 16:20:06.165822','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0386,774,47,'2024-03-26 18:23:25.844114','02B','2024-04-04 12:41:43.854846','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0473,481,47,'2024-02-05 18:12:16.844114','02C','1970-01-01','2024-04-16 16:22:23.018854','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0491,237,47,'2024-02-22 14:50:55.844114','02D','2024-03-04 06:39:39.035363','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0494,666,47,'2024-03-04 05:47:31.844114','02E','1970-01-01','2024-04-14 10:07:38.828715','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0577,636,47,'2024-03-19 22:18:16.844114','02F','1970-01-01','2024-04-17 06:49:54.721492','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0602,901,47,'2024-03-22 18:32:51.844114','03A','1970-01-01','2024-04-14 05:17:39.289919','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0608,280,47,'2024-03-30 18:04:15.844114','03B','2024-04-10 09:42:10.630527','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0639,293,47,'2024-02-11 02:06:00.844114','03C','2024-02-15 06:04:22.127793','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0681,431,47,'2024-04-02 23:05:44.844114','03D','2024-04-15 20:47:25.251762','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0766,239,47,'2024-03-05 17:20:03.844114','03E','1970-01-01','2024-04-16 11:52:54.455343','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0828,516,47,'2024-03-11 19:10:53.844114','03F','1970-01-01','2024-04-14 11:31:45.544024','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0830,123,47,'2024-03-30 18:49:25.844114','04A','2024-04-08 09:01:39.163045','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0838,126,47,'2024-02-22 07:41:43.844114','04B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0856,700,47,'2024-02-20 09:31:37.844114','04C','1970-01-01','2024-04-14 12:41:24.521599','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0887,632,47,'2024-03-26 17:36:19.844114','04D','1970-01-01','2024-04-14 00:10:14.024806','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0929,252,47,'2024-01-31 02:47:30.844114','04E','2024-02-14 15:31:52.039179','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0165,791,48,'2024-02-07 23:43:41.844114','01A','2024-03-24 16:25:55.359162','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0168,904,48,'2024-03-27 02:17:40.844114','01B','2024-04-05 08:45:20.558478','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0197,429,48,'2024-02-18 10:18:14.844114','02A','2024-04-12 21:48:25.216442','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0214,504,48,'2024-01-30 20:26:20.844114','02B','2024-02-29 16:12:42.989038','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0279,813,48,'2024-02-10 17:01:12.844114','02C','2024-03-11 10:08:27.13412','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0293,425,48,'2024-01-20 00:31:03.844114','02D','2024-01-21 19:37:27.067514','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0400,423,48,'2024-02-22 08:13:05.844114','02E','2024-04-10 18:07:15.742474','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0437,867,48,'2024-01-19 07:54:52.844114','02F','2024-03-11 02:15:51.939742','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0445,526,48,'2024-02-19 02:37:09.844114','03A','1970-01-01','2024-04-16 16:29:03.477327','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0607,703,48,'2024-03-06 17:10:47.844114','03B','1970-01-01','2024-04-13 18:34:55.713399','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0728,996,48,'2024-03-30 05:09:10.844114','03C','1970-01-01','2024-04-15 20:25:12.440764','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0778,750,48,'2024-02-19 02:24:30.844114','03D','2024-03-29 03:59:32.157071','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0841,766,48,'2024-02-17 16:38:37.844114','03E','1970-01-01','2024-04-14 12:36:15.344615','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0847,73,48,'2024-04-04 19:00:14.844114','03F','2024-04-12 11:12:12.652446','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0991,710,48,'2024-02-16 07:00:50.844114','04A','1970-01-01','2024-04-17 23:42:22.858479','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0032,104,49,'2024-03-17 16:29:09.844114','01A','1970-01-01','2024-04-17 05:06:38.793779','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0329,286,49,'2024-03-21 13:40:47.844114','01B','1970-01-01','2024-04-17 07:03:45.557397','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0332,408,49,'2024-04-01 11:27:13.844114','02A','2024-04-09 01:39:06.110109','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0382,539,49,'2024-02-17 14:00:20.844114','02B','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0651,98,49,'2024-02-27 04:44:09.844114','02C','1970-01-01','2024-04-14 22:02:59.951751','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0679,406,49,'2024-03-03 03:04:54.844114','02D','2024-03-22 07:07:10.701883','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0762,529,49,'2024-01-29 05:34:31.844114','02E','2024-03-16 11:23:41.602397','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0786,956,49,'2024-03-09 05:06:12.844114','02F','2024-03-30 09:02:12.335328','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0885,364,49,'2024-01-20 07:32:07.844114','03A','1970-01-01','2024-04-14 06:42:09.099194','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0888,556,49,'2024-04-01 03:21:47.844114','03B','2024-04-13 03:55:32.092205','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0904,742,49,'2024-03-08 09:09:31.844114','03C','2024-03-08 21:01:26.336353','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0926,404,49,'2024-04-06 21:22:26.844114','03D','2024-04-08 12:49:32.312605','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0930,228,49,'2024-02-26 13:20:00.844114','03E','2024-04-04 18:42:15.068273','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0936,349,49,'2024-03-25 18:50:33.844114','03F','1970-01-01','2024-04-16 20:30:28.237247','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0952,533,49,'2024-02-28 03:09:39.844114','04A','2024-03-23 20:41:12.534698','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0039,627,50,'2024-02-24 21:16:21.844114','01A','2024-03-18 03:44:09.661882','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0050,435,50,'2024-03-31 21:08:06.844114','01B','2024-04-14 02:50:37.121599','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0085,714,50,'2024-03-03 15:33:36.844114','02A','2024-04-08 15:05:27.551448','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0195,331,50,'2024-04-14 12:06:46.844114','02B','1970-01-01','2024-04-15 11:18:25.087255','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0196,817,50,'2024-02-16 20:23:17.844114','02C','1970-01-01','2024-04-15 13:33:00.524052','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0217,592,50,'2024-03-21 04:47:36.844114','02D','2024-04-04 17:42:45.789074','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0222,569,50,'2024-01-19 23:29:53.844114','02E','1970-01-01','2024-04-15 08:27:30.270616','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0274,958,50,'2024-03-26 03:50:52.844114','02F','2024-04-07 03:34:09.542153','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0308,16,50,'2024-02-19 11:57:16.844114','03A','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0358,319,50,'2024-02-17 11:56:43.844114','03B','1970-01-01','2024-04-17 04:13:05.57145','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0451,340,50,'2024-04-09 19:56:28.844114','03C','2024-04-12 17:25:41.91971','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0487,606,50,'2024-02-12 12:24:44.844114','03D','2024-04-07 00:31:17.392129','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0500,561,50,'2024-03-13 11:34:44.844114','03E','1970-01-01','2024-04-14 15:35:57.526779','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0546,271,50,'2024-02-13 06:53:26.844114','03F','1970-01-01','2024-04-16 20:24:32.358452','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0655,366,50,'2024-02-17 16:36:57.844114','04A','2024-02-28 11:00:41.526201','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0701,103,50,'2024-03-01 14:02:17.844114','04B','2024-04-08 20:57:35.987188','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0775,91,50,'2024-03-01 17:38:58.844114','04C','2024-03-08 03:04:04.775913','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0788,33,50,'2024-04-12 08:35:00.844114','04D','1970-01-01','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0795,789,50,'2024-03-31 18:04:12.844114','04E','1970-01-01','2024-04-16 08:32:03.875756','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0932,647,50,'2024-02-15 13:12:18.844114','04F','2024-03-07 00:21:52.199838','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0943,595,50,'2024-02-26 02:57:54.844114','05A','2024-03-04 15:59:53.251189','1970-01-01','No');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0951,148,50,'2024-02-14 12:37:39.844114','05B','1970-01-01','2024-04-16 14:19:56.575548','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0989,699,50,'2024-04-09 19:33:34.844114','05C','1970-01-01','2024-04-18 05:30:20.61068','Yes');
INSERT INTO ticket(TicketID,PID,FlightID,BookTime,SeatNum,CancelTime,CheckInTime,CheckInStatus) VALUES (0995,770,50,'2024-03-29 19:22:43.844114','05D','2024-04-09 08:48:46.598799','1970-01-01','No');