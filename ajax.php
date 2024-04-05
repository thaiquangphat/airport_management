<?php
ob_start();
date_default_timezone_set("Asia/Manila");

$action = $_GET['action'];
include 'admin_class.php';
$crud = new Action();
if($action == 'login'){
	$login = $crud->login();
	if($login)
		echo $login;
}
if($action == 'logout'){
	// $logout = $crud->logout();
	// if($logout)
	// 	echo $logout;
	$crud->logout();
}
if($action == 'signup'){
	$save = $crud->signup();
	if($save)
		echo $save;
}
if($action == 'save_user'){
	$save = $crud->save_user();
	if($save)
		echo $save;
}
if($action == 'update_user'){
	$save = $crud->update_user();
	if($save)
		echo $save;
}
if($action == 'delete_user'){
	$save = $crud->delete_user();
	if($save)
		echo $save;
}
if($action == 'save_airport'){
	$save = $crud->save_airport();
	if($save)
		echo $save;
}
if($action == 'update_airport'){
	$save = $crud->update_airport();
	if($save)
		echo $save;
}
if($action == 'delete_airport'){
	$save = $crud->delete_airport();
	if($save)
		echo $save;
}
if($action == 'save_airline'){
	$save = $crud->save_airline();
	if($save)
		echo $save;
}
if($action == 'update_airline'){
	$save = $crud->update_airline();
	if($save)
		echo $save;
}
if($action == 'delete_airline'){
	$save = $crud->delete_airline();
	if($save)
		echo $save;
}
if($action == 'delete_owner'){
	$save = $crud->delete_owner();
	if($save)
		echo $save;
}
if($action == 'delete_person'){
	$save = $crud->delete_person();
	if($save)
		echo $save;
}
if($action == 'delete_cooperation'){
	$save = $crud->delete_cooperation();
	if($save)
		echo $save;
}
if($action == 'save_airplane'){
	$save = $crud->save_airplane();
	if($save)
		echo $save;
}
if($action == 'update_airplane'){
	$save = $crud->update_airplane();
	if($save)
		echo $save;
}
if($action == 'delete_airplane'){
	$save = $crud->delete_airplane();
	if($save)
		echo $save;
}
if($action == 'delete_route'){
	$save = $crud->delete_route();
	if($save)
		echo $save;
}
if($action == 'save_flight'){
	$save = $crud->save_flight();
	if($save)
		echo $save;
}
if($action == 'update_flight'){
	$save = $crud->update_flight();
	if($save)
		echo $save;
}
if($action == 'delete_flight'){
	$save = $crud->delete_flight();
	if($save)
		echo $save;
}
if($action == 'save_employee'){
	$save = $crud->save_employee();
	if($save)
		echo $save;
}
if($action == 'update_employee'){
	$save = $crud->update_employee();
	if($save)
		echo $save;
}
if($action == 'delete_employee'){
	$save = $crud->delete_employee();
	if($save)
		echo $save;
}
if($action == 'save_administrative_support'){
	$save = $crud->save_administrative_support();
	if($save)
		echo $save;
}
if($action == 'update_administrative_support'){
	$save = $crud->update_administrative_support();
	if($save)
		echo $save;
}
if($action == 'save_traffic_controller'){
	$save = $crud->save_traffic_controller();
	if($save)
		echo $save;
}
if($action == 'update_traffic_controller'){
	$save = $crud->update_traffic_controller();
	if($save)
		echo $save;
}
if($action == 'save_engineer'){
	$save = $crud->save_engineer();
	if($save)
		echo $save;
}
if($action == 'update_engineer'){
	$save = $crud->update_engineer();
	if($save)
		echo $save;
}
if($action == 'save_flight_employee'){
	$save = $crud->save_flight_employee();
	if($save)
		echo $save;
}
if($action == 'update_flight_employee'){
	$save = $crud->update_flight_employee();
	if($save)
		echo $save;
}
if($action == 'save_passenger'){
	$save = $crud->save_passenger();
	if($save)
		echo $save;
}
if($action == 'update_passenger'){
	$save = $crud->update_passenger();
	if($save)
		echo $save;
}
if($action == 'delete_passenger'){
	$save = $crud->delete_passenger();
	if($save)
		echo $save;
}
ob_end_flush();
?>