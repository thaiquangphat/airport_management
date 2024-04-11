<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Owner where OwnerID = '".$_GET['ownerid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_owner2.php';
?>