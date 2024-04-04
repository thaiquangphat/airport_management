-- Note:
-- In this version, I have set "ON DELETE CASCADE" to all the referential integrity constraints
-- DROP SCHEMA IF EXISTS BTL_24_03_31;
-- CREATE SCHEMA BTL_24_03_31;

-- SET SQL_SAFE_UPDATES = 0; -- note this for allow to not use the safe mode on update
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION; 
SET time_zone = "+00:00";
-- --------------------------------------------------------------------
CREATE TABLE `system_settings` (
  `id` int(30) NOT NULL,
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
CREATE TABLE `users` (
  `id` int(30) AUTO_INCREMENT,
  `firstname` varchar(200) NOT NULL,
  `lastname` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` text NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 2 COMMENT '1 = admin, 2 = staff',
  `avatar` text NOT NULL DEFAULT 'no-image-available.png',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password`, `type`, `avatar`, `date_created`) VALUES
(1, 'Administrator', '', 'admin@admin.com', '0192023a7bbd73250516f069df18b500', 1, 'no-image-available.png', '2020-11-26 10:57:04'),
(2, 'John', 'Smith', 'jsmith@sample.com', '1254737c076cf867dc53d60a0364f38e', 2, '1606978560_avatar.jpg', '2020-12-03 09:26:03');

--
-- Indexes for table `users`
--
-- ALTER TABLE `users`
--   ADD PRIMARY KEY (`id`);
-- --------------------------------------------------------------------

CREATE TABLE Employee (
	SSN					CHAR(10),
    Fname				VARCHAR(50),
    Minit				CHAR(1),
    Lname				VARCHAR(50),
    Salary				FLOAT,
    Phone				CHAR(10),
    DOB					DATE,
    Sex					ENUM('F', 'M'),
    PRIMARY KEY (SSN)
);

INSERT INTO Employee (SSN, Fname, Minit, Lname, Salary, Phone, DOB, Sex) VALUES
('0000000001', 'John', 'M', 'Doe', 50000, '1234567890', '1990-05-15', 'M'),
('0000000002', 'Jane', 'D', 'Smith', 55000, '2345678901', '1988-09-20', 'F'),
('0000000003', 'Michael', 'A', 'Johnson', 60000, '3456789012', '1993-02-10', 'M'),
('0000000004', 'Emily', 'R', 'Williams', 52000, '4567890123', '1995-11-30', 'F'),
('0000000005', 'Christopher', 'J', 'Brown', 58000, '5678901234', '1987-07-25', 'M'),
('0000000006', 'Jessica', 'L', 'Miller', 53000, '6789012345', '1991-04-18', 'F'),
('0000000007', 'David', 'S', 'Wilson', 62000, '7890123456', '1985-12-05', 'M'),
('0000000008', 'Sarah', 'K', 'Garcia', 54000, '8901234567', '1990-08-12', 'F');

CREATE TABLE Supervision (
	SSN					CHAR(10),
    SuperSSN			CHAR(10),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (SuperSSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Supervision VALUES
('0000000001', '0000000002'),
('0000000003', '0000000004'),
('0000000004', '0000000005');

CREATE TABLE Employee_Address (
	SSN					CHAR(10),
    Street				VARCHAR(50),
    City				VARCHAR(50),
    District			VARCHAR(50),
    PRIMARY KEY (SSN, Street, City, District)
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Employee_Address (SSN, Street, City, District) VALUES
('0000000001', '123 Main St', 'New York', 'Manhattan'),
('0000000002', '456 Elm St', 'Los Angeles', 'Hollywood'),
('0000000003', '789 Oak St', 'Chicago', 'Downtown'),
('0000000004', '101 Pine St', 'San Francisco', 'Financial District'),
('0000000005', '222 Maple St', 'Boston', 'Back Bay'),
('0000000006', '222 Maple St', 'Boston', 'Back Bay'),
('0000000007', '222 Maple St', 'Boston', 'Back Bay');

CREATE TABLE Administrative_Support (
	SSN					CHAR(10),
    ASType				ENUM('Secretary', 'Data Entry', 'Receptionist', 'Comunications', 'PR', 'Security', 'Ground Service', 'HR', 'Emergency Service'),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Administrative_Support (SSN, ASType) VALUES
('0000000001', 'Secretary'),
('0000000002', 'Data Entry');

CREATE TABLE Engineer (
	SSN					CHAR(10),
    EType				ENUM('Avionic Engineer', 'Mechanical Engineer', 'Electrical Engineer'),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Engineer (SSN, EType) VALUES
('0000000003', 'Avionic Engineer');

CREATE TABLE Traffic_Controller (
	SSN					CHAR(10),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Traffic_Controller (SSN) VALUES
('0000000004');

CREATE TABLE TCShift (
	TCSSN				CHAR(10),
    Shift				ENUM('Morning', 'Afternoon', 'Evening', 'Night'),
    PRIMARY KEY (TCSSN, Shift)
    -- FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO TCShift (TCSSN, Shift) VALUES
('0000000004', 'Morning'),
('0000000004', 'Evening');

CREATE TABLE Flight_Employee (
	FESSN				CHAR(10),
    PRIMARY KEY (FESSN)
	-- FOREIGN KEY (FESSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Flight_Employee (FESSN) VALUES
('0000000005'),
('0000000006');

CREATE TABLE Pilot (
	SSN					CHAR(10),
    License				CHAR(12),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Pilot (SSN, License) VALUES
('0000000005', 'ABC123456789');

CREATE TABLE Flight_Attendant (
	SSN					CHAR(10),
    Year_experience		INT,
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (SSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Flight_Attendant (SSN, Year_experience) VALUES
('0000000006', 5);
-- --------------------------------------------------------------------
-- Note: tao nghi nen de route ID = APCode Source + APCode Destination
CREATE TABLE Route (
	ID					CHAR(6),
    PRIMARY KEY (ID)
);

INSERT INTO Route (ID) VALUES
('SGNHAN'),
('SGNDAD'),
('SFOFRA'),
('SINJFK'),
('LAXNRT');
-- --------------------------------------------------------------------
CREATE TABLE Passenger (
	PID 				INT						AUTO_INCREMENT,
    PassportNo			CHAR(12) 				NOT NULL 			UNIQUE,
    Sex					ENUM('M', 'F'),
    DOB					DATE,
    Nationality			VARCHAR(50),
    Fname				VARCHAR(50),
    Minit				CHAR(1),
    Lname				VARCHAR(50),
    PRIMARY KEY (PID)
);

INSERT INTO Passenger (PassportNo, Sex, DOB, Nationality, Fname, Minit, Lname) VALUES
('A123456789', 'M', '1990-01-15', 'American', 'John', 'M', 'Doe'),
('B234567890', 'F', '1988-06-20', 'British', 'Emily', 'R', 'Williams'),
('C345678901', 'M', '1993-12-10', 'Canadian', 'Michael', 'A', 'Johnson'),
('D456789012', 'F', '1995-07-30', 'German', 'Jessica', 'L', 'Miller'),
('E567890123', 'M', '1987-05-25', 'Australian', 'David', 'S', 'Wilson');

CREATE TABLE Passenger_Phone (
	PID					CHAR(10),
    Phone				CHAR(10),
    PRIMARY KEY (PID, Phone)
);
-- --------------------------------------------------------------------
CREATE TABLE Owner (
	OwnerID				CHAR(5),
    PRIMARY KEY (OwnerID)
);

INSERT INTO Owner (OwnerID) VALUES
('OW001'),
('OW002'),
('OW003'),
('OW004'),
('OW005');

CREATE TABLE Cooperation (
	Name				VARCHAR(50),
    Address				VARCHAR(50),
    Phone				CHAR(10),
    OwnerID				CHAR(5),
    PRIMARY KEY (Name)
    -- FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Cooperation (Name, Address, Phone, OwnerID) VALUES
('ABC Corp', '123 Business Ave', '1234567890', 'OW001'),
('XYZ Ltd', '456 Industrial Blvd', '2345678901', 'OW002'),
('LMN Inc', '789 Commercial St', '3456789012', 'OW003');

CREATE TABLE Person (
	SSN					CHAR(10),
    Name				VARCHAR(50),
    Phone				CHAR(10),
    Address				VARCHAR(50),
    OwnerID				CHAR(5),
    PRIMARY KEY (SSN)
    -- FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Person (SSN, Name, Phone, Address, OwnerID) VALUES
('1234567890', 'John Smith', '1234567890', '123 Main St', 'OW003'),
('2345678901', 'Jane Doe', '2345678901', '456 Elm St', 'OW004');
-- --------------------------------------------------------------------
CREATE TABLE Airport (
	APCode				CHAR(3),
    APName				VARCHAR(50),
    PRIMARY KEY (APCode)
);

INSERT INTO Airport VALUES 
('SGN', 'Tan Son Nhat International Airport'),
('HAN', 'Noi Bai International Airport'),
('DAD', 'Danang International Airport'),
('KIX', 'Kansai International Airport'),
('LHR', 'London Heathrow International Airport'),
('SFO', 'San Francisco International Airport'),
('FRA', 'Frankfurt Airport'),
('SIN', 'Changi International Airport'),
('JFK', 'John F. Kennedy International Airport'),
('NRT', 'Narita International Airport'),
('LAX', 'Los Angeles International Airport'),
('CDG', 'Charles de Gaulle Airport'),
('DXB', 'Dubai International Airport'),
('AMS', 'Amsterdam Airport Schiphol');

CREATE TABLE Airline (
	AirlineID 			CHAR(3),
    IATADesignator		CHAR(2)			UNIQUE			NOT NULL,
    Name				VARCHAR(50),
    PRIMARY KEY (AirlineID)
);

INSERT INTO Airline VALUES 
('738','VN', 'Vietnam Airlines'),
('978','VH', 'Vietjet Air'),
('926','QH', 'Bamboo Airways'),
('160','CX', 'Cathay Pacific'),
('157','QR', 'Qatar Airways'),
('297','CI', 'China Airlines'),
('176','EK', 'Emirates'),
('607','EY', 'Etihad Airways'),
('180','KE', 'Korean Air'),
('57','AF', 'Air France'),
('125','BA', 'British Airways'),
('789','QF', 'Qantas Airways'),
('217','UA', 'United Airlines'),
('124','DL', 'Delta Air Lines'),
('234','AC', 'Air Canada');


CREATE TABLE Model (
	ID					INT 			AUTO_INCREMENT,
    MName				VARCHAR(50),
    Weight 				FLOAT,
    Capacity			FLOAT,
    Threshold			FLOAT,
    PRIMARY KEY (ID)
);

CREATE TABLE Airplane (
	AirplaneID				INT 			AUTO_INCREMENT, 
    License_plate_num		CHAR(6)			UNIQUE 			NOT NULL,
    AirlineID				CHAR(3)			NOT NULL,
    OwnerID					CHAR(10)		NOT NULL,	
    ModelID					INT,
    LeasedDate				TIMESTAMP		NULL,
    Name					VARCHAR(50),
    FuncStatus				ENUM('Professionally Modified', 'Operating Normal', 'Malfunctioning'),
    PRIMARY KEY (AirplaneID)
    -- FOREIGN KEY (AirlineID) REFERENCES Airline (AirlineID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (OwnerID) REFERENCES Owner (OwnerID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Airplane (License_plate_num, AirlineID, OwnerID, ModelID, LeasedDate, Name, FuncStatus) VALUES
('ABC123', '738', 'OW001', 1, '2023-01-01', 'Airplane 1', 'Operating Normal'),
('DEF456', '926', 'OW002', 2, NULL, 'Airplane 2', 'Professionally Modified'),
('GHI789', '160', 'OW003', 3, NULL, 'Airplane 3', 'Malfunctioning'),
('JKL012', '176', 'OW004', 1, '2023-02-15', 'Airplane 4', 'Operating Normal'),
('MNO345', '57', 'OW005', 2, NULL, 'Airplane 5', 'Professionally Modified'),
('PQR678', '125', 'OW006', 3, '2023-03-20', 'Airplane 6', 'Operating Normal'),
('STU901', '738', 'OW007', 1, NULL, 'Airplane 7', 'Malfunctioning'),
('VWX234', '926', 'OW008', 2, '2023-04-10', 'Airplane 8', 'Operating Normal'),
('YZA567', '160', 'OW009', 3, NULL, 'Airplane 9', 'Professionally Modified'),
('BCD890', '738', 'OW010', 1, '2023-05-05', 'Airplane 10', 'Operating Normal'),
('EFG789', '738', 'OW011', 4, NULL, 'Boeing 737-800', 'Operating Normal'),
('HIJ012', '160', 'OW012', 5, NULL, 'Airbus A320', 'Operating Normal'),
('KLM345', '926', 'OW013', 6, NULL, 'Boeing 787 Dreamliner', 'Malfunctioning'),
('NOP678', '57', 'OW014', 7, '2023-06-20', 'Airbus A350', 'Operating Normal'),
('QRS901', '125', 'OW015', 8, NULL, 'Boeing 777', 'Professionally Modified'),
('TUV234', '738', 'OW016', 9, '2023-07-10', 'Airbus A380', 'Operating Normal'),
('WXY567', '926', 'OW017', 10, NULL, 'Boeing 747', 'Operating Normal'),
('ZAB890', '160', 'OW018', 11, NULL, 'Airbus A330', 'Malfunctioning'),
('CDE123', '738', 'OW019', 12, '2023-08-05', 'Boeing 737 MAX', 'Operating Normal'),
('FGH456', '57', 'OW020', 13, NULL, 'Airbus A321', 'Professionally Modified');

-- --------------------------------------------------------------------
CREATE TABLE Consultant (
	ID					INT 			AUTO_INCREMENT,
    PRIMARY KEY (ID)
);
-- --------------------------------------------------------------------
CREATE TABLE IS_Destination (
    RouteID             CHAR(6),
    APCode              CHAR(3),
    PRIMARY KEY (RouteID, APCode)
    -- FOREIGN KEY (RouteID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IS_Source (
	RouteID					CHAR(6),
    APCode					CHAR(3),
    PRIMARY KEY (RouteID, APCode)
    -- FOREIGN KEY (RouteID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
CREATE TABLE Flight (	
	FlightID			INT					AUTO_INCREMENT,
    RouteID				CHAR(6),
    Status				ENUM('On Air', 'Landed', 'Unassigned'),
    BasePrice			FLOAT				NOT NULL,
    AirplaneID			INT					NOT NULL,
    TCSSN				CHAR(10)			NOT NULL, -- SSN of Traffic Controller
    FlightCode			CHAR(6)				NOT NULL,
    ActualArrTime       TIMESTAMP			NULL,
    ExpectedArrTime     TIMESTAMP 			DEFAULT CURRENT_TIMESTAMP,
    ActualDepTime       TIMESTAMP			NULL,
    ExpectedDepTime     TIMESTAMP 			DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (FlightID),
    UNIQUE(RouteID, FlightCode)
    -- FOREIGN KEY (RouteID) REFERENCES Route (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (AirplaneID) REFERENCES Airplane (AirplaneID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (TCSSN) REFERENCES Traffic_Controller (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Flight (RouteID, Status, BasePrice, AirplaneID, TCSSN, FlightCode) VALUES
('SGNHAN', 'On Air', 500, 1, '901234567', 'VN123'),
('SFOFRA', 'Landed', 1000, 2, '901234567', 'EK456'),
('LAXNRT', 'Unassigned', 800, 3, '012345678', 'BA789');

CREATE TABLE Ticket (
	TicketID				INT 					AUTO_INCREMENT,
    PID						INT,  
    Price					FLOAT,
    CheckInTime				TIMESTAMP,
    CheckInStatus			ENUM('No', 'Yes'),
    Surcharge				FLOAT,
    BookTime				TIMESTAMP 				DEFAULT CURRENT_TIMESTAMP,
    CancelTime				TIMESTAMP 				NULL,
    Type					ENUM('Book', 'Cancel'),
    PRIMARY KEY (TicketID)
    -- FOREIGN KEY (PID) REFERENCES Passenger (PID) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO Ticket (PID, Price, CheckInTime, CheckInStatus, Surcharge, Type) VALUES
(1, 500, '2023-01-01 08:00:00', 'Yes', 50, 'Book'),
(2, 1000, '2023-02-01 10:00:00', 'No', 0, 'Book'),
(3, 800, '2023-03-01 12:00:00', 'No', 0, 'Book');

CREATE TABLE Seat (
	FlightID				INT,
    RouteID					CHAR(6),
    SeatNum					INT,
    Class					ENUM('Business', 'Economy', 'First Class', 'Other'),
    Status					ENUM('Booked', 'Available'),
    TicketID				INT,
    PRIMARY KEY (FlightID, SeatNum)
    -- FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Seat (FlightID, RouteID, SeatNum, Class, Status, TicketID) VALUES
(1, 'SGNHAN', 1, 'Business', 'Booked', 1),
(1, 'SGNHAN', 2, 'Economy', 'Booked', 1),
(2, 'SFOFRA', 1, 'First Class', 'Available', NULL),
(2, 'SFOFRA', 2, 'Economy', 'Available', NULL),
(3, 'LAXNRT', 1, 'Business', 'Available', NULL),
(3, 'LAXNRT', 2, 'Economy', 'Available', NULL);
-- --------------------------------------------------------------------
CREATE TABLE Expert_At (
	ConsultID				INT,
    APCode					CHAR(3),  -- THIS CAN BE NULL IF 
    ModelID					INT,
    PRIMARY KEY (ConsultID, APCode, ModelID)
    -- FOREIGN KEY (ConsultID) REFERENCES Consultant (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Expert_At (ConsultID, APCode, ModelID) VALUES
(1, 'SGN', 1),
(2, 'SFO', 2),
(3, 'LAX', 3);
-- --------------------------------------------------------------------
CREATE TABLE Expertise (
	ESSN					CHAR(10),
    ModelID					INT,
    PRIMARY KEY (ESSN, ModelID)
    -- FOREIGN KEY (ESSN) REFERENCES Engineer (SSN) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Expertise (ESSN, ModelID) VALUES
('678901234', 1),
('789012345', 2),
('890123456', 3);
-- --------------------------------------------------------------------
CREATE TABLE Airport_Contains_Airplane (
	APCode					CHAR(3),
    AirplaneID				INT,
    PRIMARY KEY (APCode, AirplaneID)
    -- FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (AirplaneID) REFERENCES Airplane (AirplaneID) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Airport_Contains_Airplane (APCode, AirplaneID) VALUES
('SGN', 1),
('HAN', 2),
('DAD', 3),
('SFO', 4),
('SIN', 5);
-- --------------------------------------------------------------------
CREATE TABLE Airport_Includes_Employee (
	APCode					CHAR(3),
    SSN						CHAR(10),
    Date					TIMESTAMP,
    PRIMARY KEY (APCode, SSN)
    -- FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (SSN) REFERENCES Employee (SSN) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Airport_Includes_Employee (APCode, SSN, Date) VALUES
('SGN', '0000000001', '2023-01-01'),
('HAN', '0000000002', '2023-01-15'),
('DAD', '0000000003', '2023-02-01'),
('SFO', '0000000004', '2023-02-15'),
('SIN', '0000000005', '2023-03-01');
-- --------------------------------------------------------------------
-- Note: Role tao de cho giong trong mapping 280324 thoi
-- chu tao nghi role nen lam attribute cua thg pilot
CREATE TABLE Operate (
	FSSN					CHAR(10),
    FlightID				INT,
    Role					VARCHAR(15),
    PRIMARY KEY (FSSN, FlightID)
    -- FOREIGN KEY (FSSN) REFERENCES Flight_Employee (FESSN) ON DELETE CASCADE ON UPDATE CASCADE,
    -- FOREIGN KEY (FlightID) REFERENCES Flight (FlightID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- --------------------------------------------------------------------
COMMIT;