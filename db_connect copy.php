<!--
// de nguyen hai cai user nay day
// dung xoa
// $conn= new mysqli('localhost','sManager','123456','test_new')or die("Could not connect to mysql".mysqli_error($con));
// $conn= new mysqli('localhost','rUser','123456','test_new')or die("Could not connect to mysql".mysqli_error($con)); -->
<?php
    $user = 'root';
    $pass = '';

    if (isset($_SESSION['user-db']) && isset($_SESSION['pass-db'])) {
        $user = $_SESSION['user-db'];
        $pass = $_SESSION['pass-db'];
    }

    $conn= new mysqli('localhost',$user,$pass,'test_new')or die("Could not connect to mysql".mysqli_error($con));