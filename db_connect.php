<?php
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

$user = isset($_SESSION['user-db']) ? $_SESSION['user-db'] : 'root';
$pass = isset($_SESSION['pass-db']) ? $_SESSION['pass-db'] : '';

try {
    $conn = new mysqli('localhost', $user, $pass, 'test_new');
    if ($conn->connect_error) {
        throw new Exception("Could not connect to MySQL: " . $conn->connect_error);
    }
} catch (Exception $e) {
    // Log or handle the error appropriately
    error_log("Database connection failed: " . $e->getMessage());

    // Redirect or display an error message to the user
    // die("Database connection paul: " . $e->getMessage());

    session_destroy();
    foreach ($_SESSION as $key => $value) {
        unset($_SESSION[$key]);
    }
    // header("location:login.php");
}
?>