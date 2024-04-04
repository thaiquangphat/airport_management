<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['ssn'])){
	$qry = $conn->query("SELECT * FROM Employee where SSN = ".$_GET['ssn'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

hihihihihihi nothing here

<style>
</style>