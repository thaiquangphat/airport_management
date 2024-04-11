<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Person where OwnerID = '".$_GET['ownerid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_owner_person.php';
?>