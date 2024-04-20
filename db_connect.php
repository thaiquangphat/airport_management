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
    error_log("Database connection error: " . $e->getMessage());

    // Redirect or display an error message to the user
    die("Database connection error: " . $e->getMessage());
}

// You can continue using $conn for database operations
    $user = 'sManager';
    $pass = '123456';

    $conn= new mysqli('localhost',$user,$pass,'test_new')or die("Could not connect to mysql".mysqli_error($con));
?>
