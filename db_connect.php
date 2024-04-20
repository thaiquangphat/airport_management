<?php
    $user = 'pauldb';
    $pass = 'paul123';

    if (isset($_SESSION['user-db']) && isset($_SESSION['pass-db'])) {
        $user = $_SESSION['user-db'];
        $pass = $_SESSION['pass-db'];
    }

    $conn= new mysqli('localhost',$user,$pass,'test_new')or die("Could not connect to mysql".mysqli_error($con));
?>