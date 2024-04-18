<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Consultant where ID = '".$_GET['consultantid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_consultant.php';
?>