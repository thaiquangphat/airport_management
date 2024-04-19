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
if($action == 'register'){
	$register = $crud->register();
	if($register)
		echo $register;
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
if($action == 'save_owner'){
	$save = $crud->save_owner();
	if($save)
		echo $save;
}
if($action == 'update_owner'){
	$save = $crud->update_owner();
	if($save)
		echo $save;
}
if($action == 'delete_owner'){
	$save = $crud->delete_owner();
	if($save)
		echo $save;
}
if($action == 'save_owner_person'){
	$save = $crud->save_owner_person();
	if($save)
		echo $save;
}
if($action == 'save_owner_cooperation'){
	$save = $crud->save_owner_cooperation();
	if($save)
		echo $save;
}
if($action == 'delete_owner_person'){
	$save = $crud->delete_owner_person();
	if($save)
		echo $save;
}
if($action == 'delete_owner_cooperation'){
	$save = $crud->delete_owner_cooperation();
	if($save)
		echo $save;
}
if($action == 'save_model'){
	$save = $crud->save_model();
	if($save)
		echo $save;
}
if($action == 'update_model'){
	$save = $crud->update_model();
	if($save)
		echo $save;
}
if($action == 'delete_model'){
	$save = $crud->delete_model();
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
if($action == 'save_operate'){
	$save = $crud->save_operate();
	if($save)
		echo $save;
}
if($action == 'update_operate'){
	$save = $crud->update_operate();
	if($save)
		echo $save;
}
if($action == 'delete_operate'){
	$save = $crud->delete_operate();
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
if($action == 'delete_ticket'){
	$save = $crud->delete_ticket();
	if($save)
		echo $save;
}
if($action == 'save_consultant'){
	$save = $crud->save_consultant();
	if($save)
		echo $save;
}
if($action == 'delete_consultant'){
	$save = $crud->delete_consultant();
	if($save)
		echo $save;
}
if ($action == 'new_expert'){
	$save = $crud->new_expert();
	if ($save)
		echo $save;
}
if ($action == 'delete_expert'){
	$save = $crud->delete_expert();
	if ($save)
		echo $save;
}
if ($action == 'delete_super'){
	$save = $crud->delete_super();
	if ($save)
		echo $save;
}
ob_end_flush();
?>