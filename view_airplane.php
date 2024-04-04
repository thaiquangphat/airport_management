<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['airlineid'])){
	$qry = $conn->query("SELECT * FROM Airplane where AirplaneID = ". $_GET['airplaneid'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

hihihihihihi nothing here

<style>
</style>