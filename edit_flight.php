<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Flight where FlightID = '".$_GET['flightid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_flight.php';
?>