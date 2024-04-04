<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['pid'])){
	$qry = $conn->query("SELECT * FROM Passenger where PID = ".$_GET['pid'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

hihihihihihi nothing here

<style>
</style>