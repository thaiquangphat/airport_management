<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['apcode'])){
	$qry = $conn->query("SELECT * FROM airport where APCode = '".$_GET['apcode']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

hihihihihihi nothing here

<style>
</style>