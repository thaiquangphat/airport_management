<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Airline where AirlineID = '".$_GET['airlineid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_airline2.php';
?>