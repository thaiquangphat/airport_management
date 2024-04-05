<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Model where ID = '".$_GET['modelid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_model.php';
?>