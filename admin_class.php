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
        $check = $this->db->query(
            "SELECT * FROM Flight where FlightID = $FlightID")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }
        // Construct the SQL query string
        $sql = "INSERT INTO Airplane SET $data";

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
        $delete = $this->db->query("DELETE FROM Airplane WHERE AirplaneID = '" . $flightid . "'");
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
            if (!is_numeric($k) && $k != 'SSN' && $k != 'EmpType' && $k != 'NewSSN') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k='$v' ";
                } else {
                    $data .= ", $k='$v' ";
                }
            }
        }
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
            "SELECT * FROM Traffic_Controller where SSN = '" . $SSN . "'")->num_rows;
        if ($check > 0) {
            return 2;
            exit();
        }

        $save = $this->db->query("INSERT INTO Traffic_Controller set $data");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function update_traffic_controller() {
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

        if (empty($data)) return 1;

        // Execute the SQL update query
        $save = $this->db->query("UPDATE Traffic_Controller SET $data WHERE SSN = '" . $SSN . "'");
        if ($save) {
            return 1;
        } else {
            return 0;
        }
    }

    function save_flight_employee() {
        extract($_POST);

        $sql="INSERT INTO Flight_Employee set FESSN = '" .$SSN . "'";
        $save = $this->db->query($sql);
        if (!$save) {
            return 0;
        } 

        if ($FType == 'Pilot') {
            $sql="INSERT INTO Pilot set SSN = '" .$SSN . "'" . ", License = '" . $Lisence . "'";
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