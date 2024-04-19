<?php
    $user = 'sManager';
    $pass = '123456';

    $conn= new mysqli('localhost',$user,$pass,'test_new')or die("Could not connect to mysql".mysqli_error($con));
?>