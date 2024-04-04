<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM airport where APCode = '".$_GET['apcode']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_airport2.php';
?>