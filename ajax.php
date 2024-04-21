<?php
ob_start();
date_default_timezone_set("Asia/Manila");

$action = $_GET['action'];
include 'admin_class.php';
$crud = new Action();
// if($action == 'login'){
// 	$login = $crud->login();
// 	if($login)
// 		echo $login;
// }
if($action == 'login'){
	$test_err = ""; // Initialize $test_err
	$login = $crud->login($test_err);
	if($login == 1) {
		echo 1;
	} else {
		echo $test_err; // Return the error message
	}
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
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_airport($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'update_airport'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_airport($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'delete_airport'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_airport($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_airline'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_airline($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'update_airline'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_airline($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'delete_airline'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_airline($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_owner'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_owner($test_err);
	if($save == 1 || $save == 2 || $save == 3 || $save == 4 || $save == 5) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'update_owner'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_owner($test_err);
	if($save == 1 || $save == 2 || $save == 3 || $save == 4 || $save == 5) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'delete_owner'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_owner($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_owner_person'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_owner_person($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_owner_cooperation'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_owner_cooperation($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_model'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_model($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'update_model'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_model($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'delete_model'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_model($test_err);
	if($save == 1) {
		echo $save;
	} else {
		echo $test_err; // Return the error message
	}
}
if($action == 'save_airplane'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_airplane($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_airplane'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_airplane($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_airplane'){
    $test_err = ""; // Initialize $test_err
    $save = $crud->delete_airplane($test_err);
    if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_route'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_route($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_flight'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_flight($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_flight'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_flight($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_flight'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_flight($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_operate'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_operate($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_operate'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_operate($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_employee'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_employee($test_err);
	if($save == 1 || $save == 3 || $save == 4 || $save == 5 || $save == 6) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_employee'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_employee($test_err);
	if($save == 1 || $save == 3 || $save == 4 || $save == 5 || $save == 6) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_employee'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_employee($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_administrative_support'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_administrative_support($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_administrative_support'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_administrative_support($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_traffic_controller'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_traffic_controller($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_traffic_controller'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_traffic_controller($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_engineer'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_engineer($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_engineer'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_engineer($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_flight_employee'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_flight_employee($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_flight_employee'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_flight_employee($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_passenger'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_passenger($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'update_passenger'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->update_passenger($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_passenger'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_passenger($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_ticket'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_ticket($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'save_consultant'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->save_consultant($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'new_expert'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->new_expert($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_expert'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_expert($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
}
if($action == 'delete_consultant'){
	$test_err = ""; // Initialize $test_err
	$save = $crud->delete_consultant($test_err);
	if($save == 1) {
        echo $save;
    } else {
        echo $test_err; // Return the error message
    }
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