<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['modelid'])){
	$qry = $conn->query("SELECT * FROM Model where ID = ". $_GET['modelid'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

hihihihihihi nothing here

<style>
</style>