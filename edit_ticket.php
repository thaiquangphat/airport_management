<?php
include 'db_connect.php';
$qry = $conn->query("SELECT * FROM Ticket where TicketID = '".$_GET['tid']."'")->fetch_array();
foreach($qry as $k => $v){
	$$k = $v;
}
include 'new_ticket.php';
?>