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
    // function login()
    // {
    //     extract($_POST);
    //     $qry = $this->db->query(
    //         "SELECT *,concat(firstname,' ',lastname) as name FROM users where email = '" .
    //             $email .
    //             "' and password = '" .
    //             md5($password) .
    //             "'  "
    //     );
    //     if ($qry->num_rows > 0) {
    //         foreach ($qry->fetch_array() as $key => $value) {
    //             if ($key != "password" && !is_numeric($key)) {
    //                 $_SESSION["login_" . $key] = $value;
    //             }
    //         }
    //         return 1;
    //     } else {
    //         return 2;
    //     }
    // }
    // function login()
    // {
    //     extract($_POST);
    //     $_SESSION['user-db'] = $user;
    //     $_SESSION['pass-db'] = $password;

    //     include("db_connect.php");

    //     $qry = $this->db->query("SELECT *,concat(firstname,' ',lastname) as name FROM users where email = 'admin@admin.com' and password = '0192023a7bbd73250516f069df18b500'");

    //     if ($qry->num_rows > 0) {
    //         foreach ($qry->fetch_array() as $key => $value) {
    //             if ($key != "password" && !is_numeric($key)) {
    //                 $_SESSION["login_" . $key] = $value;
    //             }
    //         }
    //         return 1;
    //     } else {
    //         return 2;
    //     }
    // }
    // function login(&$test_err)
    // {
    //     extract($_POST);
    //     $_SESSION['user-db'] = $user;
    //     $_SESSION['pass-db'] = $password;

    //     try {
    //         include("db_connect.php");

    //         // Prepare the SQL query
    //         $stmt = $this->db->prepare("SELECT *,concat(firstname,' ',lastname) as name FROM users where email = 'admin@admin.com' and password = '0192023a7bbd73250516f069df18b500'");
    //         // $stmt->bind_param("ss", $email, $password); // Assuming $email and $password are the POSTed values
    //         $stmt->execute();
    //         $result = $stmt->get_result();

    //         if ($result->num_rows > 0) {
    //             $row = $result->fetch_assoc();
    //             foreach ($row as $key => $value) {
    //                 if ($key != "password" && !is_numeric($key)) {
    //                     $_SESSION["login_" . $key] = $value;
    //                 }
    //             }
    //             $test_err = "DM loi gi z";
    //             return 1; // Return 1 indicating success
    //         } else {
    //             $test_err = "User not found";
    //             return 2; // Return 2 indicating user not found
    //         }
    //     } catch (mysqli_sql_exception $e) {
    //         if (strpos($e->getMessage(), 'Error: ') !== false) {
    //             $error_message = "Query error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
    //         } else {
    //             $error_message = $e->getMessage();
    //         }
            
    //         // Store error message in $test_err
    //         $test_err = $error_message;

    //         // Log or handle the error appropriately
    //         error_log($error_message);

    //         return 0; // Return 0 or another value to indicate failure
    //     }
    // }
    function login(&$test_err)
    {
        extract($_POST);
        $_SESSION['user-db'] = $user;
        $_SESSION['pass-db'] = $password;

        try {
            include("db_connect.php");

            // Check if the connection is successful
            if ($conn) {
                $test_err = "Database connection successful";
                $_SESSION["login_id"] = 1; // added
                $_SESSION["login_type"] = 1; // added
                $_SESSION["login_name"] = $user;
                return 1; // Return 1 indicating success
            } else {
                $test_err = "Database connection failed";
                return 0; // Return 0 or another value to indicate failure
            }
        } catch (mysqli_sql_exception $e) {
            // Store error message in $test_err
            $test_err = "Database connection error: " . $e->getMessage();

            // Log or handle the error appropriately
            error_log($test_err);

            return 0; // Return 0 or another value to indicate failure
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

    // function save_airport() {
    //     extract($_POST);
    //     $data = "";
    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k)) {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Airport where APCode = '" . $APCode . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }
    //     $save = $this->db->query("INSERT INTO airport set $data");
    //     if ($save) {
    //         return 1;
    //     }
    // }
    function save_airport(&$save_err) { // Note the use of &$save_err to pass by reference
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
        
        try {
            // Check if the airport with the given APCode already exists
            $check = $this->db->query("SELECT * FROM Airport WHERE APCode = '" . $APCode . "'")->num_rows;
            if ($check > 0) {
                $save_err = "APCode already exists";
                return $save_err;
            }
    
            // Insert new airport data
            $save = $this->db->query("INSERT INTO Airport SET $data");
            
            if ($save) {
                return 1;
            } else {
                $save_err = "Error saving airport";
                return $save_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $save_err
            $save_err = $error_message;
            return $save_err; // Return the error message
        }
    }
    

    // function update_airport() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'APCode') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Airport SET $data WHERE APCode = '" . $APCode . "'");
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // }    
    function update_airport(&$update_err) { // Note the use of &$update_err to pass by reference
        extract($_POST);
        $data = "";
        
        try {
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
            $update = $this->db->query("UPDATE Airport SET $data WHERE APCode = '" . $APCode . "'");
            
            if ($update) {
                // Return 1 indicating success
                return 1;
            } else {
                $update_err = "Error updating airport";
                return $update_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $update_err
            $update_err = $error_message;
            return $update_err; // Return the error message
        }
    }
    

    // function delete_airport() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Airport WHERE APCode = '" . $apcode . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_airport(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute SQL statement to delete airport
            $delete = $this->db->query("DELETE FROM Airport WHERE APCode = '" . $apcode . "'");
            
            if ($delete) {
                return 1;
            } else {
                $test_err = "Error deleting airport";
                return $test_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_airline() {
    //     extract($_POST);
    //     $data = "";
    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k)) {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Airline where AirlineID = '" . $AirlineID . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Airline where IATADesignator = '" . $IATADesignator . "'")->num_rows;
    //     if ($check > 0) {
    //         return 3;
    //         exit();
    //     }
    //     $save = $this->db->query("INSERT INTO Airline set $data");
    //     if ($save) {
    //         return 1;
    //     }
    // }
    function save_airline(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
        
        try {
            foreach ($_POST as $k => $v) {
                if (!is_numeric($k)) {
                    if (empty($data)) {
                        $data .= " $k='$v' ";
                    } else {
                        $data .= ", $k='$v' ";
                    }
                }
            }
    
            // Check if AirlineID already exists
            $check = $this->db->query("SELECT * FROM Airline WHERE AirlineID = '" . $AirlineID . "'")->num_rows;
            if ($check > 0) {
                $test_err = "AirlineID already exists";
                return 2;
            }
    
            // Check if IATADesignator already exists
            $check = $this->db->query("SELECT * FROM Airline WHERE IATADesignator = '" . $IATADesignator . "'")->num_rows;
            if ($check > 0) {
                $test_err = "IATADesignator already exists";
                return 3;
            }
    
            // Insert new airline
            $save = $this->db->query("INSERT INTO Airline SET $data");
            if ($save) {
                return 1;
            } else {
                $test_err = "Error saving airline";
                return $test_err;
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_airline() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'AirlineID') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Airline SET $data WHERE AirlineID = '" . $AirlineID . "'");
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // }    
    function update_airline(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
        
        try {
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
                // Set error message and return
                $test_err = "Error updating airline";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_airline() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Airline WHERE AirlineID = '" . $airlineid . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_airline(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Airline WHERE AirlineID = '" . $airlineid . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting airline";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }    
    

    // function delete_owner() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = '" . $ownerid . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_owner(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = '" . $ownerid . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting owner";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_person() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = " . $ownerid);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_person(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = " . $ownerid);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting person";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_cooperation() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Owner WHERE OwnerID = " . $ownerid);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_cooperation(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Cooperation WHERE CooperationID = " . $cooperationid);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting cooperation";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_model() {
    //     extract($_POST);
    
    //     // Check if all required fields are received
    //     if (!isset($ID) || !isset($MName) || !isset($Capacity) || !isset($MaxSpeed)) {
    //         return 0; // Return 0 if any required field is missing
    //     }
    
    //     // Check for existing AirplaneID
    //     if (empty($ID)) {
    //         $checkModelID = $this->db->query("SELECT * FROM Model WHERE ID = '$ID'");
    //         if ($checkModelID->num_rows > 0) {
    //             return 2; // Airplane ID already exists
    //         }
    //     }
    
    //     if (empty($ID)) {
    //         // Construct the SQL query for insertion
    //         $sql = "INSERT INTO Model (ID, MName, Capacity, MaxSpeed) VALUES ('$ID', '$MName', '$Capacity', '$MaxSpeed')";
    //     } else {
    //         // Construct the SQL query for update
    //         $sql = "UPDATE Model SET MName = '$MName', Capacity = '$Capacity', MaxSpeed = '$MaxSpeed' WHERE ID = '$ID'";
    //     }
    
    //     // Execute the SQL query
    //     if ($this->db->query($sql)) {
    //         return 1; // Data successfully saved
    //     } else {
    //         return 4; // Data failed to save
    //     }
    // }
    function save_model(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Check if all required fields are received
            if (!isset($ID) || !isset($MName) || !isset($Capacity) || !isset($MaxSpeed)) {
                return 0; // Return 0 if any required field is missing
            }
    
            // Check for existing Model ID
            $checkModelID = $this->db->query("SELECT * FROM Model WHERE ID = '$ID'");
            if ($checkModelID->num_rows > 0 && empty($ID)) {
                return 2; // Model ID already exists
            }
    
            // Construct the SQL query
            if (empty($ID)) {
                $sql = "INSERT INTO Model (ID, MName, Capacity, MaxSpeed) VALUES ('$ID', '$MName', '$Capacity', '$MaxSpeed')";
            } else {
                $sql = "UPDATE Model SET MName = '$MName', Capacity = '$Capacity', MaxSpeed = '$MaxSpeed' WHERE ID = '$ID'";
            }
    
            // Execute the SQL query
            if ($this->db->query($sql)) {
                return 1; // Data successfully saved
            } else {
                $test_err = "Error saving model";
                return 4; // Data failed to save
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_model() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'ID') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Model SET $data WHERE ID = '" . $ID . "'");
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // }   
    function update_model(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
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
                // Set error message and return
                $test_err = "Error updating model";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
     

    // function delete_model() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Model WHERE ID = '" . $id . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    //     else {
    //         return 0;
    //     }
    // }
    function delete_model(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Model WHERE ID = '" . $id . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting model";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_airplane() {
    //     extract($_POST);
    
    //     // Check if all required fields are received
    //     if (!isset($AirplaneID) || !isset($License_plate_num) || !isset($AirlineID) || !isset($ModelID) || !isset($LeasedDate)) {
    //         return 0; // Return 0 if any required field is missing
    //     }
    
    //     // Check for existing AirplaneID
    //     if (empty($AirplaneID)) {
    //         $checkAirplaneID = $this->db->query("SELECT * FROM Airplane WHERE AirplaneID = '$AirplaneID'");
    //         if ($checkAirplaneID->num_rows > 0) {
    //             return 2; // Airplane ID already exists
    //         }
    //     }
    
    //     // Check for existing License_plate_num
    //     if (empty($AirplaneID)) {
    //         $checkLicensePlate = $this->db->query("SELECT * FROM Airplane WHERE License_plate_num = '$License_plate_num'");
    //         if ($checkLicensePlate->num_rows > 0) {
    //             return 3; // License Plate Number already exists
    //         }
    //     }
    
    //     if (empty($AirplaneID)) {
    //         // Construct the SQL query for insertion
    //         $sql = "INSERT INTO Airplane (AirplaneID, License_plate_num, AirlineID, OwnerID, ModelID, LeasedDate) VALUES ('$AirplaneID', '$License_plate_num', '$AirlineID', '$OwnerID', '$ModelID', '$LeasedDate')";
    //     } else {
    //         // Construct the SQL query for update
    //         $sql = "UPDATE Airplane SET License_plate_num = '$License_plate_num', AirlineID = '$AirlineID', OwnerID = '$OwnerID', ModelID = '$ModelID', LeasedDate = '$LeasedDate' WHERE AirplaneID = '$AirplaneID'";
    //     }
    
    //     // Execute the SQL query
    //     if ($this->db->query($sql)) {
    //         return 1; // Data successfully saved
    //     } else {
    //         return 4; // Data failed to save
    //     }
    // }
    function save_airplane(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Check if all required fields are received
            if (!isset($AirplaneID) || !isset($License_plate_num) || !isset($AirlineID) || !isset($ModelID) || !isset($LeasedDate)) {
                return 0; // Return 0 if any required field is missing
            }
    
            // Check for existing AirplaneID
            $checkAirplaneID = $this->db->query("SELECT * FROM Airplane WHERE AirplaneID = '$AirplaneID'");
            if ($checkAirplaneID->num_rows > 0 && empty($AirplaneID)) {
                return 2; // Airplane ID already exists
            }
    
            // Check for existing License_plate_num
            $checkLicensePlate = $this->db->query("SELECT * FROM Airplane WHERE License_plate_num = '$License_plate_num'");
            if ($checkLicensePlate->num_rows > 0 && empty($AirplaneID)) {
                return 3; // License Plate Number already exists
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
                $test_err = "Error saving airplane: " . $this->db->error;
                return $test_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
    
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_airplane() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'AirplaneID') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Airplane SET $data WHERE AirplaneID = '" . $AirplaneID . "'");
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // }    
    function update_airplane(&$test_err) {
        extract($_POST);
        $data = "";
        
        // Iterate through each POST parameter
        foreach ($_POST as $k => $v) {
            // Exclude numeric indices and certain parameters
            if (!is_numeric($k) && $k != 'AirplaneID') {
                // Append each key-value pair to the $data string
                if (empty($data)) {
                    $data .= " $k=? ";
                } else {
                    $data .= ", $k=? ";
                }
            }
        }
        
        try {
            // Prepare the SQL update query
            $stmt = $this->db->prepare("UPDATE Airplane SET $data WHERE AirplaneID = '" . $AirplaneID . "'");
            
            // Bind parameters dynamically
            // $types = str_repeat('s', count($_POST) - 1); // Assuming all values are strings
            // $values = array_values($_POST);
            // array_shift($values); // Remove AirplaneID from values
            // $values[] = $AirplaneID; // Add AirplaneID as the last value
            
            // $stmt->bind_param($types . 's', ...$values);
            
            // Execute the prepared statement
            if ($stmt->execute()) {
                return 1; // Return 1 indicating success
            } else {
                $test_err = "Error updating airplane";
                return $test_err; // Return the error message
            }
        } catch (mysqli_sql_exception $e) {
            $error_message = $e->getMessage();
            
            // Check if the error message contains "Error: "
            if (strpos($error_message, 'Error: ') !== false) {
                // Extract the trigger error message
                $trigger_error_message = substr($error_message, strpos($error_message, 'Error: ') + strlen('Error: '));
                $test_err = "Trigger error: " . $trigger_error_message;
            } else {
                $test_err = $error_message;
            }
            
            return $test_err; // Return the error message
        }
    }    
    

    function delete_airplane(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        
        try {
            // Execute SQL statement to delete airplane
            $delete = $this->db->query("DELETE FROM Airplane WHERE AirplaneID = '" . $airplaneid . "'");
            
            if ($delete) {
                return 1;
            } else {
                $test_err = "Error deleting airplane";
                return $test_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }    
    
    
    // function save_flight() {
    //     extract($_POST);
    //     $_SESSION['fid'] = '1';

    //     $data = "";
    //     foreach ($_POST as $k => $v) {
    //         if (!in_array($k, ["FlightID"]) && !is_numeric($k)) {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }

    //     $updatecheck = $this->db->query("SELECT * FROM Flight where FlightID = '" .$FlightID . "' AND FlightCode = '" . $FlightCode . "'")->num_rows;
    //     if ($updatecheck == 1 && !empty($FlightID)) {
    //         $save = $this->db->query("UPDATE Flight SET $data WHERE FlightID = " . $FlightID);
    //         if ($save) {
    //             // Return 1 indicating success
    //             $_SESSION['fid'] = $FlightID;
    //             return 1;
    //         } else {
    //             // Return 0 or error message indicating failure
    //             return 0; // Or return an error message, depending on your error handling mechanism
    //         }
    //     }

    //     $newcheck = $this->db->query("SELECT * FROM Flight where FlightID = '" .$FlightID . "'")->num_rows;
    //     if ($newcheck > 0) {
    //         return 2;
    //         exit();
    //     }
    //     // Construct the SQL query string
    //     $sql = "INSERT INTO Flight SET $data";

    //     // Print the SQL query string to the console
    //     // Print the SQL query string

    //     // Execute the SQL query
    //     $save = $this->db->query($sql);
    //     if ($save) {
    //         $qry = $this->db->query("SELECT * FROM Flight WHERE FlightCode = '" . $FlightCode . "'");
    //         $row = $qry->fetch_assoc();
    //         $_SESSION['fid'] = $row['FlightID'];
    //         return 1; // Return 1 if data is successfully saved
    //     } else {
    //         return 4; // Return 4 if data failed to save
    //     }
    // }
    function save_flight(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Check if all required fields are received
            if (!isset($FlightID) || !isset($FlightCode)) { // Add other required fields as needed
                return "MissingFields"; // Return a string to identify the missing fields
            }
    
            // Check for existing FlightID and FlightCode
            $checkFlight = $this->db->query("SELECT * FROM Flight WHERE FlightID = '$FlightID' AND FlightCode = '$FlightCode'");
            if ($checkFlight->num_rows > 0 && !empty($FlightID)) {
                $test_err = "Flight ID and Flight Code combination already exists";
                return 2; // Flight ID and Flight Code combination already exists
            }
    
            // Check for existing FlightID
            $checkFlightID = $this->db->query("SELECT * FROM Flight WHERE FlightID = '$FlightID'");
            if ($checkFlightID->num_rows > 0) {
                $test_err = "Flight ID already exists";
                return 3; // Flight ID already exists
            }
    
            // Construct the data string for insertion or update
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
    
            // Check if FlightID is empty for INSERT or not for UPDATE
            if (empty($FlightID)) {
                // Construct the SQL query for insertion
                $sql = "INSERT INTO Flight SET $data";
            } else {
                // Construct the SQL query for update
                $sql = "UPDATE Flight SET $data WHERE FlightID = '$FlightID'";
            }
    
            // Execute the SQL query
            if ($this->db->query($sql)) {
                if (empty($FlightID)) {
                    $qry = $this->db->query("SELECT * FROM Flight WHERE FlightCode = '$FlightCode'");
                    $row = $qry->fetch_assoc();
                    $_SESSION['fid'] = $row['FlightID'];
                } else {
                    $_SESSION['fid'] = $FlightID;
                }
                return 1; // Data successfully saved
            } else {
                $test_err = "Error saving flight: " . $this->db->error;
                return $test_err; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
            // $error_message = $e->getMessage();
            // $error_message = "Loi cmnr";
    
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // copy
    // function update_flight() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'FlightID') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Flight SET $data WHERE FlightID = " . $FlightID);
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // }    
    function update_flight(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
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
                // Set error message and return
                $test_err = "Error updating flight";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_flight() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Flight WHERE FlightID = '" . $flightid . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_flight(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Flight WHERE FlightID = '" . $flightid . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting flight";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_operate() {
    //     extract($_POST);
    //     $fid = $_SESSION['fid'];
    //     // Wrap the APCode value in single quotes
    //     $check = $this->db->query("SELECT * FROM Pilot WHERE SSN = '" . $ssn . "'")->num_rows;

    //     if ($check > 0) {
    //         $save = $this->db->query("INSERT INTO Operates SET FlightID = '" . $fid . "', FSSN = '" . $ssn . "', Role = 'Pilot'");
    //         if ($save) {
    //             return 1;
    //         }
    //     }
    //     else {
    //         $save = $this->db->query("INSERT INTO Operates SET FlightID = '" . $fid . "', FSSN = '" . $ssn . "', Role = 'FA'");
    //         if ($save) {
    //             return 1;
    //         }
    //     }
    // }
    function save_operate(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $fid = $_SESSION['fid'];
    
        try {
            // Check if Pilot with given SSN exists
            $check = $this->db->query("SELECT * FROM Pilot WHERE SSN = '" . $ssn . "'")->num_rows;
    
            if ($check > 0) {
                $role = 'Pilot';
            } else {
                $role = 'FA';
            }
    
            // Execute the SQL insert query
            $save = $this->db->query("INSERT INTO Operates SET FlightID = '" . $fid . "', FSSN = '" . $ssn . "', Role = '" . $role . "'");
            
            if ($save) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error saving operate";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_operate() {
    //     extract($_POST);
    //     $fid = $_SESSION['fid'];
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Operates WHERE FlightID = '" . $fid . "' AND FSSN = '" . $fssn . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_operate(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $fid = $_SESSION['fid'];
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Operates WHERE FlightID = '" . $fid . "' AND FSSN = '" . $fssn . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting operate";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function delete_route() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Route WHERE ID = ". $id);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_route(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Route WHERE ID = ". $id);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting route";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function save_employee() {
    //     extract($_POST);
    //     $data = "";
    //     $_SESSION['saveSSN'] = $SSN;

    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k) && $k != 'EmpType') {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Employee where SSN = '" . $SSN . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }
    //     $save = $this->db->query("INSERT INTO Employee set $data");
    //     if ($save) {
    //         if ($EmpType == 'ADSupport') return 3;
    //         else if ($EmpType == 'FlightEmployee') return 4;
    //         else if ($EmpType == 'Engineer') return 5;
    //         else if ($EmpType == 'TrafficController') return 6;
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function save_employee(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
        $_SESSION['saveSSN'] = $SSN;
    
        try {
            // Construct the data string for SQL query
            foreach ($_POST as $k => $v) {
                if (!is_numeric($k) && $k != 'EmpType'  && $k != 'EmpType' && $k != 'super') {
                    if (empty($data)) {
                        $data .= " $k='$v' ";
                    } else {
                        $data .= ", $k='$v' ";
                    }
                }
            }
    
            // Check if an employee with the given SSN exists
            $check = $this->db->query("SELECT * FROM Employee WHERE SSN = '" . $SSN . "'")->num_rows;
    
            if ($check > 0) {
                $test_err = "Error saving employee here, SSN already exists";
                return 2; // Employee already exists
            }
    
            // Execute the SQL insert query
            $save = $this->db->query("INSERT INTO Employee SET $data");
            
            if ($save) {
                if (isset($super) && !empty($super)) {
                    $qry = $this->db->query("SELECT * FROM Employee WHERE SSN = '" . $super . "'");
                    if ($qry) {
                        $row = $qry->fetch_assoc();

                        // PHP trigger for price
                        if ($Salary > $row['Salary']) {
                            $test_err = "Employee must have salary less than its supervisor";
                            $delete = $this->db->query("DELETE FROM Employee WHERE SSN = '" . $SSN ."'");
                            if (!$delete) {
                                $test_err = "Failed to delete";
                                return 0;
                            }

                            return 0;
                        }

                        $sup = $this->db->query("INSERT INTO Supervision SET SSN = '" .$SSN. "', SuperSSN = '" . $super . "'");
                        if (!$sup) {
                            $test_err = "Error saving employee here, sup false";
                            return 0;
                        }
                    }
                }
                
                // Determine the return value based on EmpType
                switch ($EmpType) {
                    case 'ADSupport':
                        return 3;
                    case 'FlightEmployee':
                        return 4;
                    case 'Engineer':
                        return 5;
                    case 'TrafficController':
                        return 6;
                    default:
                        return 1;
                }
            } else {
                // Set error message and return
                $test_err = "Error saving employee";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_owner() {
    //     extract($_POST);
    //     $_SESSION['ID'] = '1';
        
    //     $save = $this->db->query("INSERT INTO Owner SET Phone = '" . $Phone ."'");
    //     if ($save) {
    //         $qry = $this->db->query("SELECT * FROM Owner WHERE Phone = '" . $Phone . "'");
    //         $row = $qry->fetch_assoc();
    //         $_SESSION['ID'] = $row['OwnerID'];

    //         if ($Type == 'Person') return 2;
    //         else if ($Type == 'Cooperation') return 3;
    //         return 1;
    //     }
    //     return 0;
    // }
    function save_owner(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $_SESSION['ID'] = '1';
    
        try {
            // Execute the SQL insert query
            $save = $this->db->query("INSERT INTO Owner SET Phone = '" . $Phone ."'");
            
            if ($save) {
                // Get the OwnerID of the newly inserted record
                $qry = $this->db->query("SELECT * FROM Owner WHERE Phone = '" . $Phone . "'");
                $row = $qry->fetch_assoc();
                $_SESSION['ID'] = $row['OwnerID'];
    
                // Determine the return value based on Type
                switch ($Type) {
                    case 'Person':
                        return 2;
                    case 'Cooperation':
                        return 3;
                    default:
                        return 1;
                }
            } else {
                // Set error message and return
                $test_err = "Error saving owner";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function update_owner() {
    //     extract($_POST);
    //     $_SESSION['ownerid'] = $OwnerID;
    //     //update
    //     $update = $this->db->query("UPDATE Owner SET Phone = '" . $Phone . "' WHERE OwnerID = '" . $OwnerID . "'");

    //     $personcheck = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    //     // edit person
    //     if ($personcheck > 0 && $Type == 'Person') return 4;
    //     else if ($personcheck > 0 && $Type == 'Cooperation') {
    //         $delete = $this->db->query("DELETE FROM Person WHERE OwnerID = '" . $OwnerID . "'");

    //         $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . "'");
    //         // new cooperation
    //         return 3;
    //     }

    //     $coopcheck = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    //     // edit cooperation
    //     if ($coopcheck > 0 && $Type == 'Cooperation') return 5;
    //     else if ($coopcheck > 0 && $Type == 'Person') {
    //         $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");

    //         $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "'");
    //         // new person
    //         return 2;
    //     }

    //     return 1;
    // }
    function update_owner(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $_SESSION['ownerid'] = $OwnerID;
    
        try {
            // Update Owner's Phone
            $update = $this->db->query("UPDATE Owner SET Phone = '" . $Phone . "' WHERE OwnerID = '" . $OwnerID . "'");
            
            if (!$update) {
                // Set error message and return
                $test_err = "Error updating owner";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
    
            // Check if there's a Person associated with the Owner
            $personcheck = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    
            if ($personcheck > 0 && $Type == 'Person') {
                return 4; // Person already exists
            } elseif ($personcheck > 0 && $Type == 'Cooperation') {
                // Delete existing Person and insert new Cooperation
                $delete = $this->db->query("DELETE FROM Person WHERE OwnerID = '" . $OwnerID . "'");
                $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . "'");
                return 3; // New Cooperation
            }
    
            // Check if there's a Cooperation associated with the Owner
            $coopcheck = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    
            if ($coopcheck > 0 && $Type == 'Cooperation') {
                return 5; // Cooperation already exists
            } elseif ($coopcheck > 0 && $Type == 'Person') {
                // Delete existing Cooperation and insert new Person
                $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
                $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "'");
                return 2; // New Person
            }
    
            return 1; // Default return value
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_owner_person() {
    //     extract($_POST);

    //     $check = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;

    //     // update
    //     if ($check > 0) {
    //         $holdID = $OwnerID;
    //         $qry = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'");
    //         $row = $qry->fetch_assoc();
    //         $holdSSN = $row['SSN'];
            
    //         // only update name and address
    //         if ($SSN == $row['SSN']) {
    //             $save = $this->db->query("UPDATE Person SET Name = '" . $Name . "', Address = '" . $Address . "' WHERE SSN = '" . $holdSSN . "'");
    //             if ($save) return 1;
    //         }
    //         else {
    //             // first check for duplicate SSN
    //             $check = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
    //             if ($check > 0) return 3;

    //             // else delete then reinsert 
    //             else {
    //                 $delete = $this->db->query("DELETE FROM Person WHERE SSN = '" . $holdSSN . "'");
    //                 $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $holdID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
    //                 if ($save) return 1;
    //             }
    //         }
    //     }
    //     else {
    //         // insert
    //         $check = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
    //         if ($check > 0) return 4;

    //         $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
    //         if ($save)
    //             return 1;
    //     }

    //     return 0;
    // }
    function save_owner_person(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            $check = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    
            // Update
            if ($check > 0) {
                $holdID = $OwnerID;
                $qry = $this->db->query("SELECT * FROM Person WHERE OwnerID = '" . $OwnerID . "'");
                $row = $qry->fetch_assoc();
                $holdSSN = $row['SSN'];
    
                // Only update name and address
                if ($SSN == $row['SSN']) {
                    $save = $this->db->query("UPDATE Person SET Name = '" . $Name . "', Address = '" . $Address . "' WHERE SSN = '" . $holdSSN . "'");
                    if ($save) return 1;
                } else {
                    // Check for duplicate SSN
                    $checkDuplicate = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
                    
                    if ($checkDuplicate > 0) {
                        return 3; // Duplicate SSN
                    } else {
                        // Delete then reinsert
                        $delete = $this->db->query("DELETE FROM Person WHERE SSN = '" . $holdSSN . "'");
                        $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $holdID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                        if ($save) return 1;
                    }
                }
            } else {
                // Insert
                $checkDuplicate = $this->db->query("SELECT * FROM Person WHERE SSN = '" . $SSN . "'")->num_rows;
                
                if ($checkDuplicate > 0) {
                    return 4; // Duplicate SSN
                }
    
                $save = $this->db->query("INSERT INTO Person SET OwnerID = '" . $OwnerID . "', SSN = '" . $SSN . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                
                if ($save) {
                    return 1;
                }
            }
    
            return 0; // Default return value
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function save_owner_cooperation() {
    //     extract($_POST);

    //     $check = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;

    //     // update
    //     if ($check > 0) {
    //         $holdID = $OwnerID;
    //         $qry = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
    //         $row = $qry->fetch_assoc();
    //         $holdName = $row['Name'];
            
    //         // only update address
    //         if ($Name == $row['Name']) {
    //             $save = $this->db->query("UPDATE Cooperation SET Address = '" . $Address . "' WHERE OwnerID = '" . $OwnerID . "'");
    //             if ($save) return 1;
    //         }
    //         else {
    //             // first check for duplicate SSN
    //             $check = $this->db->query("SELECT * FROM Cooperation WHERE Name = '" . $Name . "'")->num_rows;
    //             if ($check > 0) return 3;

    //             // else delete then reinsert 
    //             else {
    //                 $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
    //                 $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $holdID . "', Name = '" . $Name . "', Address = '" . $Address . "'");
    //                 if ($save) return 1;
    //             }
    //         }
    //     }
    //     else {
    //         // insert
    //         $check = $this->db->query("SELECT * FROM Cooperation WHERE SSN = '" . $SSN . "'")->num_rows;
    //         if ($check > 0) return 4;

    //         $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . ", Name = '" . $Name . "', Address = '" . $Address . "'");
    //         if ($save)
    //             return 1;
    //     }
        
    //     return 0;
    // }
    function save_owner_cooperation(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            $check = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'")->num_rows;
    
            // Update
            if ($check > 0) {
                $holdID = $OwnerID;
                $qry = $this->db->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
                $row = $qry->fetch_assoc();
                $holdName = $row['Name'];
    
                // Only update address
                if ($Name == $row['Name']) {
                    $save = $this->db->query("UPDATE Cooperation SET Address = '" . $Address . "' WHERE OwnerID = '" . $OwnerID . "'");
                    if ($save) return 1;
                } else {
                    // Check for duplicate Name
                    $checkDuplicate = $this->db->query("SELECT * FROM Cooperation WHERE Name = '" . $Name . "'")->num_rows;
                    
                    if ($checkDuplicate > 0) {
                        return 3; // Duplicate Name
                    } else {
                        // Delete then reinsert
                        $delete = $this->db->query("DELETE FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
                        $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $holdID . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                        if ($save) return 1;
                    }
                }
            } else {
                // Insert
                $checkDuplicate = $this->db->query("SELECT * FROM Cooperation WHERE Name = '" . $Name . "'")->num_rows;
                
                if ($checkDuplicate > 0) {
                    return 4; // Duplicate Name
                }
    
                $save = $this->db->query("INSERT INTO Cooperation SET OwnerID = '" . $OwnerID . "', Name = '" . $Name . "', Address = '" . $Address . "'");
                
                if ($save) {
                    return 1;
                }
            }
    
            return 0; // Default return value
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_employee() {
    //     extract($_POST);
    //     $data = "";
    //     $_SESSION['saveSSN'] = $SSN;
    //     // Iterate through each POST parameter
    //     if (isset($NewSSN) && !empty($NewSSN)) {
    //         if (empty($data)) {
    //             $data .= " SSN='$NewSSN' ";
    //         } else {
    //             $data .= ", SSN='$NewSSN' ";
    //         }
    //     }

    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'SSN' && $k != 'EmpType' && $k != 'NewSSN' && $k != 'NewEmpType') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }

    //     if ($EmpType == $NewEmpType || $NewEmpType == 'No change') {
    //         // Execute the SQL update query
    //         $save = $this->db->query("UPDATE Employee SET $data WHERE SSN = '" . $SSN . "'");
    //         if ($save) {
    //             if ($EmpType == 'ADSupport') return 3;
    //             else if ($EmpType == 'FlightEmployee') return 4;
    //             else if ($EmpType == 'Engineer') return 5;
    //             else if ($EmpType == 'TrafficController') return 6;
    //             return 1;
    //         } else {
    //             // Return 0 or error message indicating failure
    //             return 0; // Or return an error message, depending on your error handling mechanism
    //         }
    //     }
    //     else {
    //         $save = $this->db->query("UPDATE Employee SET $data WHERE SSN = '" . $SSN . "'");
    //         if ($save) {
    //             $delete="";
    //             if ($EmpType == 'ADSupport') {
    //                 $delete = $this->db->query("DELETE FROM Administrative_Support WHERE SSN = '" . $SSN . "'");
    //             }
    //             else if ($EmpType == 'FlightEmployee') {
    //                 $delete = $this->db->query("DELETE FROM Flight_Employee WHERE SSN = '" . $SSN . "'");
    //             }
    //             else if ($EmpType == 'Engineer') {
    //                 $delete = $this->db->query("DELETE FROM Engineer WHERE SSN = '" . $SSN . "'");
    //             }
    //             else if ($EmpType == 'TrafficController') {
    //                 $delete = $this->db->query("DELETE FROM Traffic_Controller WHERE SSN = '" . $SSN . "'");
    //             }
    //             if ($delete && $NewEmpType == 'ADSupport') return 7;
    //             if ($delete && $NewEmpType == 'FlightEmployee') return 8;
    //             if ($delete && $NewEmpType == 'Engineer') return 9;
    //             if ($delete && $NewEmpType == 'FlightEmployee') return 10;

    //             return 0;
    //         }
    //     }
    // }    
    function update_employee(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
        $_SESSION['saveSSN'] = $SSN;
    
        try {
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
                if (!is_numeric($k) && $k != 'SSN' && $k != 'EmpType' && $k != 'NewSSN' && $k != 'NewEmpType' && $k != 'super') {
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
                    if (isset($super)) {
                        $update_super = $this->db->query("UPDATE Supervision SET SuperSSN = '" .$super."' WHERE SSN = '" .$SSN."'");
                        if (!$update_super) {
                            return 0;
                        }
                    }

                    switch ($EmpType) {
                        case 'ADSupport':
                            return 3;
                        case 'FlightEmployee':
                            return 4;
                        case 'Engineer':
                            return 5;
                        case 'TrafficController':
                            return 6;
                        default:
                            return 1;
                    }
                } else {
                    return 0; // Return an error message or code indicating failure
                }
            } else {
                $save = $this->db->query("UPDATE Employee SET $data WHERE SSN = '" . $SSN . "'");
                
                if ($save) {
                    if (isset($super)) {
                        $update_super = $this->db->query("UPDATE Supervision SET SuperSSN = '" .$super."' WHERE SSN = '" .$SSN."'");
                        if (!$update_super) return 0;
                    }
                    
                    $delete = false;
                    
                    switch ($EmpType) {
                        case 'ADSupport':
                            $delete = $this->db->query("DELETE FROM Administrative_Support WHERE SSN = '" . $SSN . "'");
                            break;
                        case 'FlightEmployee':
                            $delete = $this->db->query("DELETE FROM Flight_Employee WHERE SSN = '" . $SSN . "'");
                            break;
                        case 'Engineer':
                            $delete = $this->db->query("DELETE FROM Engineer WHERE SSN = '" . $SSN . "'");
                            break;
                        case 'TrafficController':
                            $delete = $this->db->query("DELETE FROM Traffic_Controller WHERE SSN = '" . $SSN . "'");
                            break;
                    }
    
                    if ($delete) {
                        switch ($NewEmpType) {
                            case 'ADSupport':
                                return 7;
                            case 'FlightEmployee':
                                return 8;
                            case 'Engineer':
                                return 9;
                            case 'TrafficController':
                                return 10;
                            default:
                                return 0;
                        }
                    }
                }
            }
    
            return 0; // Default return value
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function delete_employee() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Employee WHERE SSN = '" . $ssn . "'");
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_employee(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Employee WHERE SSN = '" . $ssn . "'");
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting employee";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function save_administrative_support() {
    //     extract($_POST);
    //     $data = "";

    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k)) {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Administrative_Support where SSN = '" . $SSN . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }

    //     $save = $this->db->query("INSERT INTO Administrative_Support set $data");
    //     if ($save) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function save_administrative_support(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
            foreach ($_POST as $k => $v) {
                if (!is_numeric($k)) {
                    if (empty($data)) {
                        $data .= " $k='$v' ";
                    } else {
                        $data .= ", $k='$v' ";
                    }
                }
            }
    
            $check = $this->db->query("SELECT * FROM Administrative_Support WHERE SSN = '" . $SSN . "'")->num_rows;
            
            if ($check > 0) {
                return 2; // Return 2 if SSN already exists
            }
    
            $save = $this->db->query("INSERT INTO Administrative_Support SET $data");
    
            if ($save) {
                return 1; // Return 1 indicating success
            } else {
                $test_err = "Fail to insert";
                return 0; // Return 0 indicating failure
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_administrative_support() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k) && $k != 'SSN') {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Administrative_Support SET $data WHERE SSN = '" . $SSN . "'");
    //     if ($save) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function update_administrative_support(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
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
                return 1; // Return 1 indicating success
            } else {
                // Set error message and return
                $test_err = "Error updating administrative support";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }  

    // function save_engineer() {
    //     extract($_POST);
    //     $data = "";

    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k)) {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     $check = $this->db->query(
    //         "SELECT * FROM Engineer where SSN = '" . $SSN . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }

    //     $save = $this->db->query("INSERT INTO Engineer set $data");
    //     if ($save) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function save_engineer(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
            foreach ($_POST as $k => $v) {
                if (!is_numeric($k)) {
                    if (empty($data)) {
                        $data .= " $k='$v' ";
                    } else {
                        $data .= ", $k='$v' ";
                    }
                }
            }
    
            $check = $this->db->query("SELECT * FROM Engineer WHERE SSN = '" . $SSN . "'")->num_rows;
            
            if ($check > 0) {
                return 2; // Return 2 if SSN already exists
            }
    
            $save = $this->db->query("INSERT INTO Engineer SET $data");
    
            if ($save) {
                return 1; // Return 1 indicating success
            } else {
                $test_err = "Error updating Engineer";
                return 0; // Return 0 indicating failure
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_engineer() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         if (!is_numeric($k) && $k != 'SSN') {
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Engineer SET $data WHERE SSN = '" . $SSN . "'");
    //     if ($save) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function update_engineer(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
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
                return 1; // Return 1 indicating success
            } else {
                // Set error message and return
                $test_err = "Error updating engineer";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function save_traffic_controller() {
    //     extract($_POST);
    //     $data = "";

    //     $check = $this->db->query("SELECT * FROM Traffic_Controller where SSN = '" . $SSN . "'")->num_rows;
    //     if ($check > 0) {
    //         return 2;
    //         exit();
    //     }

    //     $save = $this->db->query("INSERT INTO Traffic_Controller set SSN= '" . $SSN . "'");
    //     if (!$save) return 0;

    //     if ($Morning == 'Pick') {
    //         $morning = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Morning'");
    //         if (!$morning) return 0;
    //     }

    //     if ($Afternoon == 'Pick') {
    //         $afternoon = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
    //         if (!$afternoon) return 0;
    //     }

    //     if ($Evening == 'Pick') {
    //         $evening = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Evening'");
    //         if (!$evening) return 0;
    //     }

    //     if ($Night == 'Pick') {
    //         $night = $this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Nights'");
    //         if (!$night) return 0;
    //     }

    //     return 1;
    // }
    function save_traffic_controller(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // $check = $this->db->query("SELECT * FROM Traffic_Controller WHERE SSN = '" . $SSN . "'")->num_rows;
            // if ($check > 0) {
            //     $delete = $this->db->query("DELETE FROM Traffic_Controller WHERE SSN = '" . $SSN . "'");
            //     $test_err = "SSN already exists";
            //     return 2; // Return 2 if SSN already exists
            // }
            
            // $save = $this->db->query("INSERT INTO Traffic_Controller SET SSN = '" . $SSN . "'");
            // if (!$save) {
            //     $test_err = "Fail 1";
            //     return 0; // Return 0 indicating failure
            // }

            $check = $this->db->query("SELECT * FROM Traffic_Controller WHERE SSN = '" . $SSN . "'")->num_rows;
            if ($check == 0) {
                $save = $this->db->query("INSERT INTO Traffic_Controller SET SSN = '" . $SSN . "'");
                if (!$save) {
                    $test_err = "Fail 1";
                    return 0; // Return 0 indicating failure
                }
            }

            if (($Afternoon == 'Pick' && $Morning == 'Pick') || ($Afternoon == 'Pick' && $Evening == 'Pick') || ($Night == 'Pick' && $Evening == 'Pick')) {
                $test_err = "Can't have two consecutive shifts";
                return 0;
            }
    

            if ($Morning == 'Pick') {
                $morning = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Morning'");
                if (!$morning) {
                    $test_err = "Fail 2";
                    return 0; // Return 0 indicating failure
                }
            }

            if ($Afternoon == 'Pick') {
                $afternoon = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
                if (!$afternoon) {
                    $test_err = "Fail 3";
                    return 0; // Return 0 indicating failure
                }
            }
    
            if ($Evening == 'Pick') {
                $evening = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Evening'");
                if (!$evening) {
                    $test_err = "Fail 4";
                    return 0; // Return 0 indicating failure
                }
            }
    
            if ($Night == 'Pick') {
                $night = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Nights'");
                if (!$night) {
                    $test_err = "Fail 5";
                    return 0; // Return 0 indicating failure
                }
            }
    
            return 1; // Return 1 indicating success
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
    

    // function update_traffic_controller() {
    //     extract($_POST);

    //     $morning=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'")->num_rows;
    //     $afternoon=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'")->num_rows;
    //     $evening=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'")->num_rows;
    //     $night=$this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'")->num_rows;

    //     // Handle for changes in Morning
    //     if ($morning > 0 && $Morning == 'Unpick') {
    //         $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'");
    //         if (!$save) return 0;
    //     }
    //     else if ($morning == 0 && $Morning == 'Pick') {
    //         $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Morning'");
    //         if (!$save) return 0;
    //     }

    //     // Handle for changes in Afternoon
    //     if ($afternoon > 0 && $Afternoon == 'Unpick') {
    //         $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'");
    //         if (!$save) return 0;
    //     }
    //     else if ($afternoon == 0 && $Afternoon == 'Pick') {
    //         $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
    //         if (!$save) return 0;
    //     }


    //     // Handle for changes in Evening
    //     if ($evening > 0 && $Evening == 'Unpick') {
    //         $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'");
    //         if (!$save) return 0;
    //     }
    //     else if ($evening == 0 && $Evening == 'Pick') {
    //         $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Evening'");
    //         if (!$save) return 0;
    //     }


    //     // Handle for changes in Night
    //     if ($night > 0 && $Night == 'Unpick') {
    //         $save=$this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'");
    //         if (!$save) return 0;
    //     }
    //     else if ($night == 0 && $Night == 'Pick') {
    //         $save=$this->db->query("INSERT INTO TCShift set TCSSN = '" . $SSN . "', Shift = 'Night'");
    //         if (!$save) return 0;
    //     }

    //     return 1;
    // }
    function update_traffic_controller(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            $morning = $this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'")->num_rows;
            $afternoon = $this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'")->num_rows;
            $evening = $this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'")->num_rows;
            $night = $this->db->query("SELECT * FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'")->num_rows;
    
            // Handle for changes in Morning
            if ($morning > 0 && $Morning == 'Unpick') {
                $save = $this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Morning'");
                if (!$save) {
                    $test_err = "Error deleting Morning shift";
                    return 0;
                }
            } else if ($morning == 0 && $Morning == 'Pick') {
                $save = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Morning'");
                if (!$save) {
                    $test_err = "Error inserting Morning shift";
                    return 0;
                }
            }
    
            // Handle for changes in Afternoon
            if ($afternoon > 0 && $Afternoon == 'Unpick') {
                $save = $this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Afternoon'");
                if (!$save) {
                    $test_err = "Error deleting Afternoon shift";
                    return 0;
                }
            } else if ($afternoon == 0 && $Afternoon == 'Pick') {
                $save = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Afternoon'");
                if (!$save) {
                    $test_err = "Error inserting Afternoon shift";
                    return 0;
                }
            }
    
            // Handle for changes in Evening
            if ($evening > 0 && $Evening == 'Unpick') {
                $save = $this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Evening'");
                if (!$save) {
                    $test_err = "Error deleting Evening shift";
                    return 0;
                }
            } else if ($evening == 0 && $Evening == 'Pick') {
                $save = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Evening'");
                if (!$save) {
                    $test_err = "Error inserting Evening shift";
                    return 0;
                }
            }
    
            // Handle for changes in Night
            if ($night > 0 && $Night == 'Unpick') {
                $save = $this->db->query("DELETE FROM TCShift WHERE TCSSN = '" . $SSN . "' AND Shift = 'Night'");
                if (!$save) {
                    $test_err = "Error deleting Night shift";
                    return 0;
                }
            } else if ($night == 0 && $Night == 'Pick') {
                $save = $this->db->query("INSERT INTO TCShift SET TCSSN = '" . $SSN . "', Shift = 'Night'");
                if (!$save) {
                    $test_err = "Error inserting Night shift";
                    return 0;
                }
            }
    
            return 1; // Return 1 indicating success
    
        } catch (mysqli_sql_exception $e) {
            if (strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
    
            // Store error message in $test_err
            $test_err = $error_message;
            return 0; // Return 0 indicating failure
        }
    }
    

    // function save_flight_employee() {
    //     extract($_POST);

    //     $sql="INSERT INTO Flight_Employee set FESSN = '" .$SSN . "'";
    //     $save = $this->db->query($sql);
    //     if (!$save) {
    //         return 0;
    //     } 

    //     if ($FType == 'Pilot') {
    //         $sql="INSERT INTO Pilot set SSN = '" .$SSN . "'" . ", License = '" . $License . "'";
    //         $check = $this->db->query("SELECT * FROM Pilot where SSN = '" . $SSN . "'")->num_rows;
    //         if ($check > 0) {
    //             return 2;
    //             exit();
    //         }

    //         $save = $this->db->query($sql);
    //         if ($save) {
    //             return 1;
    //         } else {
    //             return 0;
    //         }
    //     }
    //     else {
    //         $sql="INSERT INTO Flight_Attendant set SSN = '" .$SSN . "'" . ", Year_Experience = '" . $Year_Experience . "'";
    //         $check = $this->db->query("SELECT * FROM Flight_Attendant where SSN = '" . $SSN . "'")->num_rows;
    //         if ($check > 0) {
    //             return 2;
    //             exit();
    //         }

    //         $save = $this->db->query($sql);
    //         if ($save) {
    //             return 1;
    //         } else {
    //             return 0;
    //         }
    //     }
    // }
    function save_flight_employee(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            $sql = "INSERT INTO Flight_Employee SET FESSN = '" . $SSN . "'";
            $save = $this->db->query($sql);
            
            if (!$save) {
                $test_err = "Fail 1";
                return 0; // Return 0 indicating failure
            }
    
            if ($FType == 'Pilot') {
                $sql = "INSERT INTO Pilot SET SSN = '" . $SSN . "', License = '" . $License . "'";
                $check = $this->db->query("SELECT * FROM Pilot WHERE SSN = '" . $SSN . "'")->num_rows;
                
                if ($check > 0) {
                    $test_err = "SSN already exists";
                    return 2; // Return 2 if SSN already exists
                }
    
                $save = $this->db->query($sql);
                
                if ($save) {
                    return 1; // Return 1 indicating success
                } else {
                    $test_err = "Fail 2";
                    return 0; // Return 0 indicating failure
                }
            } else {
                $sql = "INSERT INTO Flight_Attendant SET SSN = '" . $SSN . "', Year_Experience = '" . $Year_Experience . "'";
                $check = $this->db->query("SELECT * FROM Flight_Attendant WHERE SSN = '" . $SSN . "'")->num_rows;
                
                if ($check > 0) {
                    $test_err = "SSN already exists";
                    return 2; // Return 2 if SSN already exists
                }
    
                $save = $this->db->query($sql);
                
                if ($save) {
                    return 1; // Return 1 indicating success
                } else {
                    $test_err = "Fail 3";
                    return 0; // Return 0 indicating failure
                }
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function update_flight_employee() {
    //     extract($_POST);

    //     if ($FType == 'Pilot') {
    //         $sql="UPDATE Pilot set License = '" .$License . "' WHERE SSN = '" . $SSN . "'";
    //         $save = $this->db->query($sql);
    //         if ($save) {
    //             return 1;
    //         } else {
    //             return 0;
    //         }
    //     }

    //     $sql="UPDATE Flight_Attendant set Year_Experience = '" .$Year_Experience . "' WHERE SSN = '" . $SSN . "'";
    //     $save = $this->db->query($sql);
    //     if ($save) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    function update_flight_employee(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            if ($FType == 'Pilot') {
                $sql = "UPDATE Pilot SET License = '" . $License . "' WHERE SSN = '" . $SSN . "'";
            } else {
                $sql = "UPDATE Flight_Attendant SET Year_Experience = '" . $Year_Experience . "' WHERE SSN = '" . $SSN . "'";
            }
    
            $save = $this->db->query($sql);
            
            if ($save) {
                return 1; // Return 1 indicating success
            } else {
                // Set error message and return
                $test_err = "Error updating flight employee";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function save_passenger() {
    //     extract($_POST);
    
    //     // Check if all required fields are received
    //     if (!isset($PID) || !isset($PassportNo) || !isset($Sex) || !isset($DOB) || !isset($Nationality) || !isset($DOB) || !isset($UserID)) {
    //         return 0; // Return 0 if any required field is missing
    //     }
    
    //     // Check for existing AirplaneID
    //     // if (empty($PID)) {
    //     //     $checkPassengerID = $this->db->query("SELECT * FROM Passenger WHERE PID = '$PID'");
    //     //     if ($checkModelID->num_rows > 0) {
    //     //         return 2; // Airplane ID already exists
    //     //     }
    //     // }
    
    //     if (empty($PID)) {
    //         // Construct the SQL query for insertion
    //         $sql = "INSERT INTO Passenger (PID, PassportNo, Sex, DOB, Nationality, Fname, Minit, Lname, UserID) 
    //                 VALUES ('$PID', '$PassportNo', '$Sex', '$DOB', '$Nationality', '$Fname', '$Minit', '$Lname', '$UserID')";
    //     } else {
    //         // Construct the SQL query for update
    //         $sql = 
    //         "UPDATE Passenger 
    //         SET PassportNo = '$PassportNo', Sex = '$Sex', DOB = '$DOB', Nationality = '$Nationality', Fname = '$Fname', Minit = '$Minit', Lname = '$Lname' WHERE PID = '$PID'";
    //     }
    
    //     // Execute the SQL query
    //     if ($this->db->query($sql)) {
    //         return 1; // Data successfully saved
    //     } else {
    //         return 4; // Data failed to save
    //     }
    // }
    function save_passenger(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Check if all required fields are received
            if (!isset($PID) || !isset($PassportNo) || !isset($Sex) || !isset($DOB) || !isset($Nationality)) {
                $test_err = "Missing required fields";
                return 0; // Return 0 if any required field is missing
            }
    
            if (empty($PID)) {
                // Construct the SQL query for insertion
                $sql = "INSERT INTO Passenger (PID, PassportNo, Sex, DOB, Nationality, Fname, Minit, Lname) 
                        VALUES ('$PID', '$PassportNo', '$Sex', '$DOB', '$Nationality', '$Fname', '$Minit', '$Lname')";
            } else {
                // Construct the SQL query for update
                $sql = "UPDATE Passenger 
                        SET PassportNo = '$PassportNo', Sex = '$Sex', DOB = '$DOB', Nationality = '$Nationality', Fname = '$Fname', Minit = '$Minit', Lname = '$Lname' 
                        WHERE PID = '$PID'";
            }
    
            // Execute the SQL query
            $save = $this->db->query($sql);
    
            if ($save) {
                return 1; // Data successfully saved
            } else {
                $test_err = "Error saving passenger data";
                return 4; // Data failed to save
            }
        } catch (mysqli_sql_exception $e) {
            if (strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
    
            // Store error message in $test_err
            $test_err = $error_message;
            return 4; // Return the error code indicating data failed to save
        }
    }
    

    // function update_passenger() {
    //     extract($_POST);
    //     $data = "";
    //     // Iterate through each POST parameter
    //     foreach ($_POST as $k => $v) {
    //         // Exclude numeric indices and certain parameters
    //         if (!is_numeric($k) && $k != 'PID') {
    //             // Append each key-value pair to the $data string
    //             if (empty($data)) {
    //                 $data .= " $k='$v' ";
    //             } else {
    //                 $data .= ", $k='$v' ";
    //             }
    //         }
    //     }
    //     // Execute the SQL update query
    //     $save = $this->db->query("UPDATE Passenger SET $data WHERE PID = ". $PID);
    //     if ($save) {
    //         // Return 1 indicating success
    //         return 1;
    //     } else {
    //         // Return 0 or error message indicating failure
    //         return 0; // Or return an error message, depending on your error handling mechanism
    //     }
    // } 
    function update_passenger(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $data = "";
    
        try {
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
            $save = $this->db->query("UPDATE Passenger SET $data WHERE PID = " . $PID);
            
            if ($save) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error updating passenger";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }   

    // function delete_passenger() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Passenger WHERE PID = " . $pid);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_passenger(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Passenger WHERE PID = " . $pid);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting passenger";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function delete_ticket() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Ticket WHERE TicketID = " . $ticketid);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_ticket(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Ticket WHERE TicketID = " . $ticketid);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting ticket";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function save_consultant() {
    //     extract($_POST);
    
    //     // Check if all required fields are received
    //     if (!isset($Name) || !isset($APCode) || !isset($ModelID)) {
    //         return 0; // Return 0 if any required field is missing
    //     }
    
    //     $sql = '';
    //     if (empty($ID)) {
    //         // Construct the SQL query for insertion
    //         $sql = "INSERT INTO Consultant (Name) VALUES ('$Name')";
    //     } else {
    //         // Construct the SQL query for update
    //         $sql = "UPDATE Consultant SET Name = '$Name' WHERE ID = '$ID'";
    //     }
    
    //     if ($this->db->query($sql)) {
    //         // Get the ID of the newly inserted or updated consultant
    //         $consultantId = $ID ? $ID : mysqli_insert_id($this->db);
    
    //         $sql1 = '';
    //         if (empty($ID)) {
    //             // Construct the SQL query for insertion into Expert_At
    //             $sql1 = "INSERT INTO Expert_At (ConsultID, APCode, ModelID) VALUES ('$consultantId', '$APCode', '$ModelID')";
    //         } else {
    //             // Construct the SQL query for update of Expert_At
    //             $sql1 = "UPDATE Expert_At SET APCode = '$APCode', ModelID = '$ModelID' WHERE ConsultID = '$consultantId'";
    //         }
    
    //         if ($this->db->query($sql1)) {
    //             return 1; // Data successfully saved
    //         } else {
    //             return 4; // Data failed to save
    //         }
    //     } else {
    //         return 4; // Data failed to save
    //     }
    // }   
    function save_consultant(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
        $_SESSION['cid'] = '1';
    
        try {
            // Check if all required fields are received
            if (!isset($Name)) {
                return 0; // Return 0 if any required field is missing
            }
        
            $sql = '';
            if (empty($ID)) {
                // Construct the SQL query for insertion
                $sql = "INSERT INTO Consultant (Name) VALUES ('$Name')";
            } else {
                // Construct the SQL query for update
                $sql = "UPDATE Consultant SET Name = '$Name' WHERE ID = '$ID'";
            }
        
            if ($this->db->query($sql)) {
                // Get the ID of the newly inserted or updated consultant
                $_SESSION['cid'] = $ID ? $ID : mysqli_insert_id($this->db);
        
                // $sql1 = '';
                // if (empty($ID)) {
                //     // Construct the SQL query for insertion into Expert_At
                //     $sql1 = "INSERT INTO Expert_At (ConsultID, APCode, ModelID) VALUES ('$consultantId', '$APCode', '$ModelID')";
                // } else {
                //     // Construct the SQL query for update of Expert_At
                //     $sql1 = "UPDATE Expert_At SET APCode = '$APCode', ModelID = '$ModelID' WHERE ConsultID = '$consultantId'";
                // }
        
                // if ($this->db->query($sql1)) {
                //     return 1; // Data successfully saved
                // } else {
                //     $test_err = "Data failed to save";
                //     return 4; // Data failed to save
                // }
                return 1;
            } else {
                $test_err = "Data failed to save";
                return 4; // Data failed to save
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    } 
    // function new_expert() {
    //     extract($_POST);

    //     if (!isset($APCode) || !isset($ModelID))
    //         return 0;

    //     $check = $this->db->query("SELECT * FROM Expert_At WHERE ConsultID = '" . $ID . "' AND APCode = '" . $APCode . "' AND ModelID = '" . $ModelID . "'")->num_rows;
    //     if ($check > 0) return 2;
        
    //     $qry = "INSERT INTO Expert_At SET ConsultID = '" . $ID . "', APCode = '" . $APCode . "', ModelID = '" . $ModelID . "'";
        
    //     if ($this->db->query($qry)) return 1;

    //     return 3;
    // }
    function new_expert(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            if (!isset($APCode) || !isset($ModelID)) {
                $test_err = "Missing required fields";
                return 0; // Return 0 if any required field is missing
            }
    
            $check = $this->db->query("SELECT * FROM Expert_At WHERE ConsultID = '" . $ID . "' AND APCode = '" . $APCode . "' AND ModelID = '" . $ModelID . "'")->num_rows;
            if ($check > 0) {
                $test_err = "Expert already exists";
                return 2; // Return 2 if expert already exists
            }
            
            $qry = "INSERT INTO Expert_At SET ConsultID = '" . $ID . "', APCode = '" . $APCode . "', ModelID = '" . $ModelID . "'";
            
            if ($this->db->query($qry)) {
                return 1; // Data successfully saved
            }
    
            $test_err = "Data failed to save";
            return 3; // Data failed to save
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function delete_expert() {
    //     extract($_POST);

    //     $array = explode("-", $data);

    //     $id = $array[0];
    //     $apcode = $array[1];
    //     $modelid = $array[2];

    //     $qry = "DELETE FROM Expert_At WHERE ConsultID = '" . $id . "' AND APCode = '" . $apcode . "' AND ModelID = '" . $modelid . "'";

    //     try {
    //         $this->db->query($qry);
    //     }
    //     catch(mysqli_sql_exception) {
    //         return 3;
    //     }

    //     return 1;
    // }
    function delete_expert(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            $array = explode("-", $data);
    
            $id = $array[0];
            $apcode = $array[1];
            $modelid = $array[2];
    
            $qry = "DELETE FROM Expert_At WHERE ConsultID = '" . $id . "' AND APCode = '" . $apcode . "' AND ModelID = '" . $modelid . "'";
    
            try {
                $this->db->query($qry);
                return 1;
            } catch(mysqli_sql_exception $e) {
                if(strpos($e->getMessage(), 'Error: ') !== false) {
                    $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
                } else {
                    $error_message = $e->getMessage();
                }
            
                // Store error message in $test_err
                $test_err = $error_message;
                return 3; // Return the error message
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    // function delete_consultant() {
    //     extract($_POST);
    //     // Wrap the APCode value in single quotes
    //     $delete = $this->db->query("DELETE FROM Consultant WHERE ID = " . $consultantid);
    //     if ($delete) {
    //         return 1;
    //     }
    // }
    function delete_consultant(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $delete = $this->db->query("DELETE FROM Consultant WHERE ID = " . $consultantid);
            
            if ($delete) {
                // Return 1 indicating success
                return 1;
            } else {
                // Set error message and return
                $test_err = "Error deleting consultant";
                return 0; // Or return an error message, depending on your error handling mechanism
            }
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }

    function update_ticket(&$test_err) { // Note the use of &$test_err to pass by reference
        extract($_POST);
    
        try {
            // Execute the SQL delete query
            $update = $this->db->query("UPDATE Ticket SET CheckInStatus = '" . $CheckInStatus . "', CheckInTime = '" . $CheckInTime . "', BookTime = '" . $BookTime . "', CancelTime = '" . $CancelTime . "' WHERE TicketID = '" . $TicketID . "'");
            if (!$update) {
                $test_err = "Cannot update ticket";
                return 0;
            }
            return 1;
            
        } catch(mysqli_sql_exception $e) {
            if(strpos($e->getMessage(), 'Error: ') !== false) {
                $error_message = "Trigger error: " . substr($e->getMessage(), strpos($e->getMessage(), 'Error: '));
            } else {
                $error_message = $e->getMessage();
            }
        
            // Store error message in $test_err
            $test_err = $error_message;
            return $test_err; // Return the error message
        }
    }
}