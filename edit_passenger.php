<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Passenger where PID = '".$_GET['pid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_passenger.php';
?>