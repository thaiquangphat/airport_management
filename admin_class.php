<?php
session_start();
ini_set("display_errors", 1);
class Action
{
    private $db;

	// initialize the class by including a file
	// which has the database connection code.
	// Starts output buffering 
    public function __construct()
    {
        ob_start();
        include "db_connect.php";

        $this->db = $conn;
    }

	// Close the database connection and ends output buffering
    function __destruct()
    {
        $this->db->close();
        ob_end_flush();
    }

	// authenticate a user by querying tha DB for a matching email and password
	// combination. It successful, stores user info in session and return 1
	// otherwise return 2
    function login()
    {
        extract($_POST);
        $qry = $this->db->query(
            "SELECT *,concat(firstname,' ',lastname) as name FROM users where email = '" .
                $email .
                "' and password = '" .
                md5($password) .
                "'  "
        );
        if ($qry->num_rows > 0) {
            foreach ($qry->fetch_array() as $key => $value) {
                if ($key != "password" && !is_numeric($key)) {
                    $_SESSION["login_" . $key] = $value;
                }
            }
            return 1;
        } else {
            return 2;
        }
    }

    function register() {
        extract($_POST);

        if ($password != $confirmpassword) return 3;

        $qry = $this->db->query("SELECT * FROM users WHERE email = '" . $email . "'");
        if ($qry->num_rows > 0) {
            return 2;
        }

        $save = $this->db->query("INSERT INTO users SET firstname = '" . $fname . "', lastname = '" . $lname . "', email = '" . $email . "', password = '" . md5($password) . "', type = 3");
        if (!$save) return 2;

        $qry = $this->db->query("SELECT *, concat(firstname,' ',lastname) as name FROM users where email = '" . $email . "' and password = '" . md5($password) ."'  ");
        
        if ($qry->num_rows > 0) {
            foreach ($qry->fetch_array() as $key => $value) {
                if ($key != "password" && !is_numeric($key)) {
                    $_SESSION["login_" . $key] = $value;
                }
            }
            if ($save)
                return 1;
        } else {
            return 2;
        }
    }	
	// logout meethod destroys the session and redirects user to login page.
    function logout()
    {
        session_destroy();
        foreach ($_SESSION as $key => $value) {
            unset($_SESSION[$key]);
        }
        header("location:login.php");
    }

	// Start the User Management Functions
	// Handle CRUD operations
    function save_user()
    {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!in_array($k, ["id", "cpass", "password"]) && !is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        if (!empty($password)) {
            $data .= ", password=md5('$password') ";
        }
        $check = $this->db->query(
            "SELECT * FROM users where email ='$email' " .
                (!empty($id) ? " and id != {$id} " : "")
        )->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        if (isset($_FILES["img"]) && $_FILES["img"]["tmp_name"] != "") {
            $fname =
                strtotime(date("y-m-d H:i")) . "_" . $_FILES["img"]["name"];
            $move = move_uploaded_file(
                $_FILES["img"]["tmp_name"],
                "assets/uploads/" . $fname
            );
            $data .= ", avatar = '$fname' ";
        }
        if (empty($id)) {
            $save = $this->db->query("INSERT INTO users set $data");
        } else {
            $save = $this->db->query("UPDATE users set $data where id = $id");
        }

        if ($save) {
            return 1;
        }
    }
    function signup()
    {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!in_array($k, ["id", "cpass"]) && !is_numeric($k)) {
                if ($k == "password") {
                    if (empty($v)) {
                        continue;
                    }
                    $v = md5($v);
                }
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }

        $check = $this->db->query(
            "SELECT * FROM users where email ='$email' " .
                (!empty($id) ? " and id != {$id} " : "")
        )->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        if (isset($_FILES["img"]) && $_FILES["img"]["tmp_name"] != "") {
            $fname =
                strtotime(date("y-m-d H:i")) . "_" . $_FILES["img"]["name"];
            $move = move_uploaded_file(
                $_FILES["img"]["tmp_name"],
                "assets/uploads/" . $fname
            );
            $data .= ", avatar = '$fname' ";
        }
        if (empty($id)) {
            $save = $this->db->query("INSERT INTO users set $data");
        } else {
            $save = $this->db->query("UPDATE users set $data where id = $id");
        }

        if ($save) {
            if (empty($id)) {
                $id = $this->db->insert_id;
            }
            foreach ($_POST as $key => $value) {
                if (
                    !in_array($key, ["id", "cpass", "password"]) &&
                    !is_numeric($key)
                ) {
                    $_SESSION["login_" . $key] = $value;
                }
            }
            $_SESSION["login_id"] = $id;
            if (isset($_FILES["img"]) && !empty($_FILES["img"]["tmp_name"])) {
                $_SESSION["login_avatar"] = $fname;
            }
            return 1;
        }
    }

    function update_user()
    {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (
                !in_array($k, ["id", "cpass", "table", "password"]) &&
                !is_numeric($k)
            ) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM users where email ='$email' " .
                (!empty($id) ? " and id != {$id} " : "")
        )->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        if (isset($_FILES["img"]) && $_FILES["img"]["tmp_name"] != "") {
            $fname =
                strtotime(date("y-m-d H:i")) . "_" . $_FILES["img"]["name"];
            $move = move_uploaded_file(
                $_FILES["img"]["tmp_name"],
                "assets/uploads/" . $fname
            );
            $data .= ", avatar = '$fname' ";
        }
        if (!empty($password)) {
            $data .= " ,password=md5('$password') ";
        }
        if (empty($id)) {
            $save = $this->db->query("INSERT INTO users set $data");
        } else {
            $save = $this->db->query("UPDATE users set $data where id = $id");
        }

        if ($save) {
            foreach ($_POST as $key => $value) {
                if ($key != "password" && !is_numeric($key)) {
                    $_SESSION["login_" . $key] = $value;
                }
            }
            if (isset($_FILES["img"]) && !empty($_FILES["img"]["tmp_name"])) {
                $_SESSION["login_avatar"] = $fname;
            }
            return 1;
        }
    }
    function delete_user()
    {
        extract($_POST);
        $delete = $this->db->query("DELETE FROM users where id = " . $id);
        if ($delete) {
            return 1;
        }
    }
    function save_system_settings()
    {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        if ($_FILES["cover"]["tmp_name"] != "") {
            $fname =
                strtotime(date("y-m-d H:i")) . "_" . $_FILES["cover"]["name"];
            $move = move_uploaded_file(
                $_FILES["cover"]["tmp_name"],
                "../assets/uploads/" . $fname
            );
            $data .= ", cover_img = '$fname' ";
        }
        $chk = $this->db->query("SELECT * FROM system_settings");
        if ($chk->num_rows > 0) {
            $save = $this->db->query(
                "UPDATE system_settings set $data where id =" .
                    $chk->fetch_array()["id"]
            );
        } else {
            $save = $this->db->query("INSERT INTO system_settings set $data");
        }
        if ($save) {
            foreach ($_POST as $k => $v) {
                if (!is_numeric($k)) {
                    $_SESSION["system"][$k] = $v;
                }
            }
            if ($_FILES["cover"]["tmp_name"] != "") {
                $_SESSION["system"]["cover_img"] = $fname;
            }
            return 1;
        }
    }
    function save_image()
    {
        extract($_FILES["file"]);
        if (!empty($tmp_name)) {
            $fname =
                strtotime(date("Y-m-d H:i")) .
                "_" .
                str_replace(" ", "-", $name);
            $move = move_uploaded_file($tmp_name, "assets/uploads/" . $fname);
            $protocol =
                strtolower(substr($_SERVER["SERVER_PROTOCOL"], 0, 5)) == "https"
                    ? "https"
                    : "http";
            $hostName = $_SERVER["HTTP_HOST"];
            $path = explode("/", $_SERVER["PHP_SELF"]);
            $currentPath = "/" . $path[1];
            if ($move) {
                return $protocol .
                    "://" .
                    $hostName .
                    $currentPath .
                    "/assets/uploads/" .
                    $fname;
            }
        }
    }

    function save_airport() {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Airport where APCode = '" . $APCode . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        $save = $this->db->query("INSERT INTO airport set $data");
        if ($save) {
            return 1;
        }
    }

    function update_airport() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'APCode') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Airport SET $data WHERE APCode = '" . $APCode . "'");
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_airport() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Airport WHERE APCode = '" . $apcode . "'");
        if ($delete) {
            return 1;
        }
    }

    function save_airline() {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Airline where AirlineID = '" . $AirlineID . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        $check = $this->db->query(
            "SELECT * FROM Airline where IATADesignator = '" . $IATADesignator . "'")->num_rows;
        if ($check > 0) {
            return 3;
            exit();
        }
        $save = $this->db->query("INSERT INTO Airline set $data");
        if ($save) {
            return 1;
        }
    }

    function update_airline() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'AirlineID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Airline SET $data WHERE AirlineID = '" . $AirlineID . "'");
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_airline() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Airline WHERE AirlineID = '" . $airlineid . "'");
        if ($delete) {
            return 1;
        }
    }

    function delete_owner() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = '" . $ownerid . "'");
        if ($delete) {
            return 1;
        }
    }

    function delete_person() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = " . $ownerid);
        if ($delete) {
            return 1;
        }
    }

    function delete_cooperation() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = " . $ownerid);
        if ($delete) {
            return 1;
        }
    }

    function save_model() {
        extract($_POST);
    
        // Check if all required fields are received
        if (!isset($ID) || !isset($MName) || !isset($Capacity) || !isset($MaxSpeed)) {
            return 0; // Return 0 if any required field is missing
        }
    
        // Check for existing AirplaneID
        if (empty($ID)) {
            $checkModelID = $this->db->query("SELECT * FROM Model WHERE ID = '$ID'");
            if ($checkModelID->num_rows > 0) {
                return 2; // Airplane ID already exists
            }
        }
    
        if (empty($ID)) {
            // Construct the SQL query for insertion
            $sql = "INSERT INTO Model (ID, MName, Capacity, MaxSpeed) VALUES ('$ID', '$MName', '$Capacity', '$MaxSpeed')";
        } else {
            // Construct the SQL query for update
            $sql = "UPDATE Model SET MName = '$MName', Capacity = '$Capacity', MaxSpeed = '$MaxSpeed' WHERE ID = '$ID'";
        }
    
        // Execute the SQL query
        if ($this->db->query($sql)) {
            return 1; // Data successfully saved
        } else {
            return 4; // Data failed to save
        }
    }

    function update_model() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'ID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Model SET $data WHERE ID = '" . $ID . "'");
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_model() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Model WHERE ID = '" . $id . "'");
        if ($delete) {
            return 1;
        }
        else {
            return 0;
        }
    }

    function save_airplane() {
        extract($_POST);
    
        // Check if all required fields are received
        if (!isset($AirplaneID) || !isset($License_plate_num) || !isset($AirlineID) || !isset($ModelID) || !isset($LeasedDate)) {
            return 0; // Return 0 if any required field is missing
        }
    
        // Check for existing AirplaneID
        if (empty($AirplaneID)) {
            $checkAirplaneID = $this->db->query("SELECT * FROM Airplane WHERE AirplaneID = '$AirplaneID'");
            if ($checkAirplaneID->num_rows > 0) {
                return 2; // Airplane ID already exists
            }
        }
    
        // Check for existing License_plate_num
        if (empty($AirplaneID)) {
            $checkLicensePlate = $this->db->query("SELECT * FROM Airplane WHERE License_plate_num = '$License_plate_num'");
            if ($checkLicensePlate->num_rows > 0) {
                return 3; // License Plate Number already exists
            }
        }
    
        if (empty($AirplaneID)) {
            // Construct the SQL query for insertion
            $sql = "INSERT INTO Airplane (AirplaneID, License_plate_num, AirlineID, OwnerID, ModelID, LeasedDate) VALUES ('$AirplaneID', '$License_plate_num', '$AirlineID', '$OwnerID', '$ModelID', '$LeasedDate')";
        } else {
            // Construct the SQL query for update
            $sql = "UPDATE Airplane SET License_plate_num = '$License_plate_num', AirlineID = '$AirlineID', OwnerID = '$OwnerID', ModelID = '$ModelID', LeasedDate = '$LeasedDate' WHERE AirplaneID = '$AirplaneID'";
        }
    
        // Execute the SQL query
        if ($this->db->query($sql)) {
            return 1; // Data successfully saved
        } else {
            return 4; // Data failed to save
        }
    }

    function update_airplane() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'AirplaneID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Airplane SET $data WHERE AirplaneID = '" . $AirplaneID . "'");
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_airplane() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Airplane WHERE AirplaneID = '" . $airplaneid . "'");
        if ($delete) {
            return 1;
        }
    }
    
    function save_flight() {
        extract($_POST);
        $_SESSION['fid'] = '1';

        $data = "";
        foreach ($_POST as $k => $v) {
            if (!in_array($k, ["FlightID"]) && !is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }

        $updatecheck = $this->db->query("SELECT * FROM Flight where FlightID = '" .$FlightID . "' AND FlightCode = '" . $FlightCode . "'")->num_rows;
        if ($updatecheck == 1 && !empty($FlightID)) {
            $save = $this->db->query("UPDATE Flight SET $data WHERE FlightID = " . $FlightID);
            if ($save) {
                // Return 1 indicating success
                $_SESSION['fid'] = $FlightID;
                return 1;
            } else {
                // Return 0 or error message indicating failure
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        }

        $newcheck = $this->db->query("SELECT * FROM Flight where FlightID = '" .$FlightID . "'")->num_rows;
        if ($newcheck > 0) {
            return 2;
            exit();
        }
        // Construct the SQL query string
        $sql = "INSERT INTO Flight SET $data";

        // Print the SQL query string to the console
        // Print the SQL query string

        // Execute the SQL query
        $save = $this->db->query($sql);
            if ($save) {
                $qry = $this->db->query("SELECT * FROM Flight WHERE FlightCode = '" . $FlightCode . "'");
                $row = $qry->fetch_assoc();
                $_SESSION['fid'] = $row['FlightID'];
                return 1; // Return 1 if data is successfully saved
            } else {
                return 4; // Return 4 if data failed to save
            }
    }

    // copy
    function update_flight() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'FlightID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Flight SET $data WHERE FlightID = " . $FlightID);
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_flight() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Flight WHERE FlightID = '" . $flightid . "'");
        if ($delete) {
            return 1;
        }
    }

    function save_operate() {
        extract($_POST);
        $fid = $_SESSION['fid'];
        // Wrap the APCode value in single quotes
        $check = $this->db->query("SELECT * FROM Pilot WHERE SSN = '" . $ssn . "'")->num_rows;

        if ($check > 0) {
            $save = $this->db->query("INSERT INTO Operates SET FlightID = '" . $fid . "', FSSN = '" . $ssn . "', Role = 'Pilot'");
            if ($save) {
                return 1;
            }
        }
        else {
            $save = $this->db->query("INSERT INTO Operates SET FlightID = '" . $fid . "', FSSN = '" . $ssn . "', Role = 'FA'");
            if ($save) {
                return 1;
            }
        }
    }

    function delete_operate() {
        extract($_POST);
        $fid = $_SESSION['fid'];
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Operates WHERE FlightID = '" . $fid . "' AND FSSN = '" . $fssn . "'");
        if ($delete) {
            return 1;
        }
    }

    function delete_route() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Route WHERE ID = ". $id);
        if ($delete) {
            return 1;
        }
    }

    function save_employee() {
        extract($_POST);
        $data = "";
        $_SESSION['saveSSN'] = $SSN;

        foreach ($_POST as $k => $v) {
            if (!is_numeric($k) && $k != 'EmpType') {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Employee where SSN = '" . $SSN . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        $save = $this->db->query("INSERT INTO Employee set $data");
        if ($save) {
            if ($EmpType == 'ADSupport') return 3;
            else if ($EmpType == 'FlightEmployee') return 4;
            else if ($EmpType == 'Engineer') return 5;
            else if ($EmpType == 'TrafficController') return 6;
            return 1;
        } else {
            return 0;
        }
    }

    function save_owner() {
        extract($_POST);
        $_SESSION['ID'] = '1';
        
        $save = $this->db->query("INSERT INTO Owner SET Phone = '" . $Phone ."'");
        if ($save) {
            $qry = $this->db->query("SELECT * FROM Owner WHERE Phone = '" . $Phone . "'");
            $row = $qry->fetch_assoc();
            $_SESSION['ID'] = $row['OwnerID'];

            if ($Type == 'Person') return 2;
            else if ($Type == 'Cooperation') return 3;
            return 1;
        }
        return 0;
    }

    function update_owner() {
        extract($_POST);
        $_SESSION['ownerid'] = $OwnerID;
        //update
        $update = $this->db->query("UPDATE Owner SET Phone = '" . $Phone . "' WHERE OwnerID = '" . $OwnerID . "'");

        $personcheck = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
        // edit person
        if ($personcheck > 0 && $Type == 'Person') return 4;
        else if ($personcheck > 0 && $Type == 'Cooperation') {
            $delete = $this->db->query("DELETE FROM Person WHERE OwnerID = '" . $OwnerID . "'");

            $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . "'");
            // new cooperation
            return 3;
        }

        $coopcheck = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
        // edit cooperation
        if ($coopcheck > 0 && $Type == 'Cooperation') return 5;
        else if ($coopcheck > 0 && $Type == 'Person') {
            $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");

            $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "'");
            // new person
            return 2;
        }

        return 1;
    }

    function save_owner_person() {
        extract($_POST);

        $check = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;

        // update
        if ($check > 0) {
            $holdID = $OwnerID;
            $qry = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'");
            $row = $qry->fetch_assoc();
            $holdSSN = $row['SSN'];
            
            // only update name and address
            if ($SSN == $row['SSN']) {
                $save = $this->db->query("UPDATE Person SET Name = '" . $Name . "', Address = '" . $Address . "' WHERE SSN = '" . $holdSSN . "'");
                if ($save) return 1;
            }
            else {
                // first check for duplicate SSN
                $check = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
                if ($check > 0) return 3;

                // else delete then reinsert 
                else {
                    $delete = $this->db->query("DELETE FROM Person WHERE SSN = '" . $holdSSN . "'");
                    $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $holdID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                    if ($save) return 1;
                }
            }
        }
        else {
            // insert
            $check = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
            if ($check > 0) return 4;

            $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
            if ($save)
                return 1;
        }

        return 0;
    }

    function save_owner_cooperation() {
        extract($_POST);

        $check = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;

        // update
        if ($check > 0) {
            $holdID = $OwnerID;
            $qry = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
            $row = $qry->fetch_assoc();
            $holdName = $row['Name'];
            
            // only update address
            if ($Name == $row['Name']) {
                $save = $this->db->query("UPDATE Cooperation SET Address = '" . $Address . "' WHERE OwnerID = '" . $OwnerID . "'");
                if ($save) return 1;
            }
            else {
                // first check for duplicate SSN
                $check = $this->db->query("SELECT * FROM Cooperation WHERE Name = '" . $Name . "'")->num_rows;
                if ($check > 0) return 3;

                // else delete then reinsert 
                else {
                    $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
                    $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $holdID . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                    if ($save) return 1;
                }
            }
        }
        else {
            // insert
            $check = $this->db->query("SELECT * FROM Cooperation WHERE SSN = '" . $SSN . "'")->num_rows;
            if ($check > 0) return 4;

            $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . ", Name = '" . $Name . "', Address = '" . $Address . "'");
            if ($save)
                return 1;
        }
        
        return 0;
    }

    function update_employee() {
        extract($_POST);
        $data = "";
        $_SESSION['saveSSN'] = $SSN;
        // Iterate through each POST parameter
        if (isset($NewSSN) && !empty($NewSSN)) {
            if (empty($data)) {
                $data .= " SSN='$NewSSN' ";
            } else {
                $data .= ", SSN='$NewSSN' ";
            }
        }

        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'SSN' && $k != 'EmpType' && $k != 'NewSSN' && $k != 'NewEmpType') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }

        if ($EmpType == $NewEmpType || $NewEmpType == 'No change') {
            // Execute the SQL update query
            $save = $this->db->query("UPDATE Employee SET $data WHERE SSN = '" . $SSN . "'");
            if ($save) {
                if ($EmpType == 'ADSupport') return 3;
                else if ($EmpType == 'FlightEmployee') return 4;
                else if ($EmpType == 'Engineer') return 5;
                else if ($EmpType == 'TrafficController') return 6;
                return 1;
            } else {
                // Return 0 or error message indicating failure
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        }
        else {
            $save = $this->db->query("UPDATE Employee SET $data WHERE SSN = '" . $SSN . "'");
            if ($save) {
                $delete="";
                if ($EmpType == 'ADSupport') {
                    $delete = $this->db->query("DELETE FROM Administrative_Support WHERE SSN = '" . $SSN . "'");
                }
                else if ($EmpType == 'FlightEmployee') {
                    $delete = $this->db->query("DELETE FROM Flight_Employee WHERE SSN = '" . $SSN . "'");
                }
                else if ($EmpType == 'Engineer') {
                    $delete = $this->db->query("DELETE FROM Engineer WHERE SSN = '" . $SSN . "'");
                }
                else if ($EmpType == 'TrafficController') {
                    $delete = $this->db->query("DELETE FROM Traffic_Controller WHERE SSN = '" . $SSN . "'");
                }
                if ($delete && $NewEmpType == 'ADSupport') return 7;
                if ($delete && $NewEmpType == 'FlightEmployee') return 8;
                if ($delete && $NewEmpType == 'Engineer') return 9;
                if ($delete && $NewEmpType == 'FlightEmployee') return 10;

                return 0;
            }
        }
    }    

    function delete_employee() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Employee WHERE SSN = '" . $ssn . "'");
        if ($delete) {
            return 1;
        }
    }

    function save_administrative_support() {
        extract($_POST);
        $data = "";

        foreach ($_POST as $k => $v) {
            if (!is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Administrative_Support where SSN = '" . $SSN . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }

        $save = $this->db->query("INSERT INTO Administrative_Support set $data");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function update_administrative_support() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            if (!is_numeric($k) && $k != 'SSN') {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Administrative_Support SET $data WHERE SSN = '" . $SSN . "'");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }  

    function save_engineer() {
        extract($_POST);
        $data = "";

        foreach ($_POST as $k => $v) {
            if (!is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Engineer where SSN = '" . $SSN . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }

        $save = $this->db->query("INSERT INTO Engineer set $data");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function update_engineer() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            if (!is_numeric($k) && $k != 'SSN') {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Engineer SET $data WHERE SSN = '" . $SSN . "'");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function save_traffic_controller() {
        extract($_POST);
        $data = "";

        $check = $this->db->query("SELECT * FROM Traffic_Controller where SSN = '" . $SSN . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }

        $save = $this->db->query("INSERT INTO Traffic_Controller set SSN= '" . $SSN . "'");
        if (!$save) return 0;

        if ($Morning == 'Pick') {
            $morning = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Morning'");
            if (!$morning) return 0;
        }

        if ($Afternoon == 'Pick') {
            $afternoon = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
            if (!$afternoon) return 0;
        }

        if ($Evening == 'Pick') {
            $evening = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Evening'");
            if (!$evening) return 0;
        }

        if ($Night == 'Pick') {
            $night = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Nights'");
            if (!$night) return 0;
        }

        return 1;
    }

    function update_traffic_controller() {
        extract($_POST);

        $morning=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'")->num_rows;
        $afternoon=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'")->num_rows;
        $evening=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'")->num_rows;
        $night=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'")->num_rows;

        // Handle for changes in Morning
        if ($morning > 0 && $Morning == 'Unpick') {
            $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'");
            if (!$save) return 0;
        }
        else if ($morning == 0 && $Morning == 'Pick') {
            $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Morning'");
            if (!$save) return 0;
        }

        // Handle for changes in Afternoon
        if ($afternoon > 0 && $Afternoon == 'Unpick') {
            $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'");
            if (!$save) return 0;
        }
        else if ($afternoon == 0 && $Afternoon == 'Pick') {
            $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
            if (!$save) return 0;
        }


        // Handle for changes in Evening
        if ($evening > 0 && $Evening == 'Unpick') {
            $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'");
            if (!$save) return 0;
        }
        else if ($evening == 0 && $Evening == 'Pick') {
            $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Evening'");
            if (!$save) return 0;
        }


        // Handle for changes in Night
        if ($night > 0 && $Night == 'Unpick') {
            $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'");
            if (!$save) return 0;
        }
        else if ($night == 0 && $Night == 'Pick') {
            $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Night'");
            if (!$save) return 0;
        }

        return 1;
    }

    function save_flight_employee() {
        extract($_POST);

        $sql="INSERT INTO Flight_Employee set FESSN = '" .$SSN . "'";
        $save = $this->db->query($sql);
        if (!$save) {
            return 0;
        } 

        if ($FType == 'Pilot') {
            $sql="INSERT INTO Pilot set SSN = '" .$SSN . "'" . ", License = '" . $License . "'";
            $check = $this->db->query("SELECT * FROM Pilot where SSN = '" . $SSN . "'")->num_rows;
            if ($check > 0) {
                return 2;
                exit();
            }

            $save = $this->db->query($sql);
            if ($save) {
                return 1;
            } else {
                return 0;
            }
        }
        else {
            $sql="INSERT INTO Flight_Attendant set SSN = '" .$SSN . "'" . ", Year_Experience = '" . $Year_Experience . "'";
            $check = $this->db->query("SELECT * FROM Flight_Attendant where SSN = '" . $SSN . "'")->num_rows;
            if ($check > 0) {
                return 2;
                exit();
            }

            $save = $this->db->query($sql);
            if ($save) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    function update_flight_employee() {
        extract($_POST);

        if ($FType == 'Pilot') {
            $sql="UPDATE Pilot set License = '" .$License . "' WHERE SSN = '" . $SSN . "'";
            $save = $this->db->query($sql);
            if ($save) {
                return 1;
            } else {
                return 0;
            }
        }

        $sql="UPDATE Flight_Attendant set Year_Experience = '" .$Year_Experience . "' WHERE SSN = '" . $SSN . "'";
        $save = $this->db->query($sql);
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function save_passenger() {
        extract($_POST);
        $data = "";
        foreach ($_POST as $k => $v) {
            if (!in_array($k, ["PID"]) && !is_numeric($k)) {
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        $check = $this->db->query(
            "SELECT * FROM Passenger where PID = $PID")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        $check = $this->db->query(
            "SELECT * FROM Passenger where PassportNo = '" . $PassportNo . "'")->num_rows;
        if ($check > 0) {
            return 3;
            exit();
        }
        // Construct the SQL query string
        $sql = "INSERT INTO Passenger SET $data";

        // Print the SQL query string to the console
        // Print the SQL query string
        
        // Execute the SQL query
        $save = $this->db->query($sql);
        if ($save) {
            return 1; // Return 1 if data is successfully saved
        } else {
            return 4; // Return 4 if data failed to save
        }
    }

    function update_passenger() {
        extract($_POST);
        $data = "";
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'PID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
        // Execute the SQL update query
        $save = $this->db->query("UPDATE Passenger SET $data WHERE PID = ". $PID);
        if ($save) {
            // Return 1 indicating success
            return 1;
        } else {
            // Return 0 or error message indicating failure
            return 0; // Or return an error message, depending on your error handling mechanism
        }
    }    

    function delete_passenger() {
        extract($_POST);
        // Wrap the APCode value in single quotes
        $delete = $this->db->query("DELETE FROM Passenger WHERE PID = " . $pid);
        if ($delete) {
            return 1;
        }
    }
}