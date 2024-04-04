<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Employee where SSN = '".$_GET['ssn']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_employee2.php';
?>