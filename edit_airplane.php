<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Airplane where AirplaneID = '".$_GET['airplaneid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_airplane.php';
?>