<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['ssn'])){
	$qry = $conn->query("SELECT *, concat(Fname,' ',Minit, ' ', Lname) as name FROM Employee where SSN = ".$_GET['ssn'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
    // Determine role of the employee
    $role = "";
    $role_qry = $conn->query("SELECT * FROM Traffic_Controller WHERE SSN = ".$_GET['ssn']);
    if($role_qry->num_rows > 0){
        $role = "Traffic Controller";
    } else {
        $role_qry = $conn->query("SELECT * FROM Engineer WHERE SSN = ".$_GET['ssn']);
        if($role_qry->num_rows > 0){
            $role = "Engineer";
        } else {
            $role_qry = $conn->query("SELECT * FROM Pilot WHERE SSN = ".$_GET['ssn']);
            if($role_qry->num_rows > 0){
                $role = "Pilot";
            } else {
                $role_qry = $conn->query("SELECT * FROM Flight_Attendant WHERE SSN = ".$_GET['ssn']);
                if($role_qry->num_rows > 0){
                    $role = "Flight Attendant";
                } else {
                    $role_qry = $conn->query("SELECT * FROM Administrative_Support WHERE SSN = ".$_GET['ssn']);
                    if($role_qry->num_rows > 0){
                        $role = "Administrative Support";
                    }
                }
            }
        }
    }
    
    // Display additional details based on role
    // if($role == "Traffic_Controller" || $role == "Flight_Attendant" || $role == "Pilot"){
    //     $flights_qry = $conn->query("SELECT FlightID FROM Operates WHERE FSSN = ".$_GET['ssn']);
    //     if($flights_qry->num_rows > 0){
    //         while($flight = $flights_qry->fetch_assoc()){
    //             echo "<p>Flight ID: " . $flight['FlightID'] . "</p>";
    //         }
    //     } else {
    //         echo "<p>No flights assigned</p>";
    //     }
    // }

    // if($role == "Engineer"){
    //     echo "<h4>Expertise:</h4>";
    //     $expertise_qry = $conn->query("SELECT MName FROM Model JOIN Expertise ON Model.ID = Expertise.ModelID WHERE ESSN = ".$_GET['ssn']);
    //     if($expertise_qry->num_rows > 0){
    //         while($expertise = $expertise_qry->fetch_assoc()){
    //             echo "<p>Expertise in: " . $expertise['MName'] . "</p>";
    //         }
    //     } else {
    //         echo "<p>No expertise listed</p>";
    //     }
    // }
} else {
    echo "<p>Employee not found</p>";
}
?>

<!-- 
ID int(11) AI PK 
RName char(7) 
Distance float 
APCode char(3) 
-->

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">SSN</b></dt>
                                <dd><?php echo ucwords($SSN) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Name</b></dt>
                                <dd><?php echo ucwords($name) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Salary</b></dt>
                                <dd><?php echo ucwords($Salary) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Supervisor</b></dt>
                                <?php
                                    $supname = '';

                                    $check = $conn->query("SELECT *, concat(Employee.fname, ' ', Employee.minit, ' ', Employee.lname) AS SuperName FROM Supervision JOIN Employee ON Supervision.SuperSSN = Employee.SSN WHERE Supervision.SSN = '" . $SSN . "'")->num_rows;
                                    if ($check == 0) $supname = 'NULL';
                                    else {
                                        $sup = $conn->query("SELECT *, concat(Employee.fname, ' ', Employee.minit, ' ', Employee.lname) AS SuperName FROM Supervision JOIN Employee ON Supervision.SuperSSN = Employee.SSN WHERE Supervision.SSN = '" . $SSN . "'");
                                        $row = $sup->fetch_assoc();
                                        $supname = $row['SuperName'];
                                    }
                                ?>
                                <dd><?php echo ucwords($supname) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Phone</b></dt>
                                <dd><?php echo ucwords($Phone) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Date of Birth</b></dt>
                                <dd><?php echo ucwords($DOB) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Sex</b></dt>
                                <dd><?php echo ucwords($Sex) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Role</b></dt>
                                <dd><?php echo ucwords($role) ?></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card card-outline card-primary">
        <div class="card-header">
            <span><b>Supervising list:</b></span>
            <div><small>Employees that this employee supervise</small></div>
            <?php if($_SESSION['login_type'] != 3): ?>
            <!-- <div class="card-tools">
                <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                        class="fa fa-plus"></i> New Task</button>
            </div> -->
            <?php endif; ?>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-condensed m-0 table-hover">
                    <!-- <colgroup>
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                        <col width="10%">
                    </colgroup> -->
                    <thead>
                    <th>SSN</th>
                        <th>Name</th>
                        <th>Sex</th>
                        <th>Salary</th>
                        <th>Phone</th>
                        <th>Date of Birth</th>
                        <th>Role</th>
                        <th>Action</th>
                    </thead>
                    <tbody>
                        <?php
                        $i = 1;
                        $qry = $conn->query("WITH SUB AS (SELECT E.SSN AS emp_SSN, Sex, Salary, Phone, DOB, concat(Fname,' ',Minit, ' ', Lname) as name,
                                                CASE
                                                    WHEN Engineer.SSN IS NOT NULL THEN 'Engineer'
                                                    WHEN FA.SSN IS NOT NULL THEN 'Flight Attendant'
                                                    WHEN P.SSN IS NOT NULL THEN 'Pilot'
                                                    WHEN TC.SSN IS NOT NULL THEN 'Traffic Controller'
                                                    WHEN ASup.SSN IS NOT NULL THEN 'Administrative Support'
                                                    ELSE 'Unknown'
                                                END as role
                                                FROM Employee E
                                                LEFT JOIN Engineer ON E.SSN = Engineer.SSN
                                                LEFT JOIN Flight_Attendant FA ON E.SSN = FA.SSN
                                                LEFT JOIN Pilot P ON E.SSN = P.SSN
                                                LEFT JOIN Traffic_Controller TC ON E.SSN = TC.SSN
                                                LEFT JOIN Administrative_Support ASup ON E.SSN = ASup.SSN
                                                ORDER BY E.SSN ASC)
                                            SELECT *
                                            FROM SUB, Supervision
                                            WHERE Supervision.SSN = SUB.emp_SSN AND Supervision.SuperSSN = $SSN"
                                            );
                        $i++;
                        while($row= $qry->fetch_assoc()):
                        ?>
                        <tr>
                            <td class=""><?php echo $row['emp_SSN'] ?></td>
                            <td class=""><?php echo $row['name'] ?></td>
                            <td class=""><?php echo $row['Sex'] ?></td>
                            <td class=""><?php echo $row['Salary'] ?></td>
                            <td class=""><?php echo $row['Phone'] ?></td>
                            <td class=""><?php echo $row['DOB'] ?></td>
                            <td class=""><?php echo $row['role'] ?></td>
                            <td class="">
                                <button type="button"
                                    class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                    data-toggle="dropdown" aria-expanded="true">
                                    Action
                                </button>
                                <div class="dropdown-menu" style="">
                                    <a class="dropdown-item view_employee"
                                        href="./index.php?page=view_employee&id=<?php echo $row['emp_SSN'] ?>"
                                        data-id="<?php echo $row['emp_SSN'] ?>">View</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item"
                                        href="./index.php?page=edit_employee&id=<?php echo $row["emp_SSN"]; ?>">Edit</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item delete_super" href="javascript:void(0)"
                                        data-id="<?php echo $row['emp_SSN']. '-' .$SSN ?>">Delete</a>
                                </div>
                            </td>
                        </tr>
                        <?php 
                        endwhile;
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <?php if($role == "Flight Attendant" || $role == "Pilot"): ?>
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Flight List:</b></span>
                    <div><small>Flights that this Employee Working on</small></div>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <!-- <colgroup>
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup> -->
                            <thead>
                                <th>Flight ID</th>
                                <th>Route ID</th>
                                <th>Status</th>
                                <th>Traffic Controller SSN</th>
                                <th>AAT</th>
                                <th>ADT</th>
                                <th>Base Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Flight 
                                    JOIN Operates ON Flight.FlightID = Operates.FlightID
                                    JOIN Route ON Flight.RID = Route.ID
                                    WHERE FSSN = '".$_GET['ssn']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightID'] ?></td>
                                    <td class=""><?php echo $row['RID'] ?></td>
                                    <td class=""><?php echo $row['RName'] ?></td>
                                    <td class=""><?php echo $row['Status'] ?></td>
                                    <td class=""><?php echo $row['TCSSN'] ?></td>
                                    <td class=""><?php echo $row['AAT'] ?></td>
                                    <td class=""><?php echo $row['ADT'] ?></td>
                                    <td class=""><?php echo $row['BasePrice'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_flight"
                                                href="./index.php?page=view_flight&id=<?php echo $row['FlightID'] ?>"
                                                data-id="<?php echo $row['FlightID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_flight&id=<?php echo $row["FlightID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_flight" href="javascript:void(0)"
                                                data-id="<?php echo $row['FlightID'] ?>">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php elseif($role == "Engineer"): ?>
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Model List:</b></span>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <colgroup>
                                <col width="15%">
                                <col width="30%">
                                <col width="20%">
                                <col width="20%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <th>Model ID</th>
                                <th>Model Name</th>
                                <th>Capacity</th>
                                <th>Max Speed</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Model JOIN Expertise ON Model.ID = Expertise.ModelID
                                    WHERE ESSN = '".$_GET['ssn']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ModelID'] ?></td>
                                    <td class=""><?php echo $row['MName'] ?></td>
                                    <td class=""><?php echo $row['Capacity'] ?></td>
                                    <td class=""><?php echo $row['MaxSpeed'] ?></td>
                                    <td class="text-center">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_model&id=<?php echo $row['ID'] ?>"
                                                data-id="<?php echo $row['ID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_model&modelid=<?php echo $row["ID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_model" href="javascript:void(0)"
                                                data-id="<?php echo $row['ID'] ?>">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php elseif($role == "Traffic Controller"): ?>
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Flight Controlled List:</b></span>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <colgroup>
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <th>Flight ID</th>
                                <th>Route ID</th>
                                <th>Status</th>
                                <th>Traffic Controller SSN</th>
                                <th>AAT</th>
                                <th>EAT</th>
                                <th>ADT</th>
                                <th>EDT</th>
                                <th>Base Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Flight
                                    WHERE TCSSN = '".$_GET['ssn']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightID'] ?></td>
                                    <td class=""><?php echo $row['RID'] ?></td>
                                    <td class=""><?php echo $row['Status'] ?></td>
                                    <td class=""><?php echo $row['TCSSN'] ?></td>
                                    <td class=""><?php echo $row['AAT'] ?></td>
                                    <td class=""><?php echo $row['EAT'] ?></td>
                                    <td class=""><?php echo $row['ADT'] ?></td>
                                    <td class=""><?php echo $row['EDT'] ?></td>
                                    <td class=""><?php echo $row['BasePrice'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_flight"
                                                href="./index.php?page=view_flight&id=<?php echo $row['FlightID'] ?>"
                                                data-id="<?php echo $row['FlightID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_flight&id=<?php echo $row["FlightID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_flight" href="javascript:void(0)"
                                                data-id="<?php echo $row['FlightID'] ?>">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php elseif($role == "Administrative Support"): ?>
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b></b></span>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>Administrative Support Type:</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Administrative_Support
                                    WHERE SSN = '".$_GET['ssn']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ASType'] ?></td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php endif; ?>
        </div>
    </div>
</div>



<style>
.truncate {
    -webkit-line-clamp: 1 !important;
}
</style>
<script>
$(document).ready(function() {
    $('#list').dataTable()

    // NOTE HONG XOA
    // $('.view_airplane').click(function() {
    //     window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    // })

    // $('.delete_airplane').click(function() {
    //     _conf("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
    //         'data-id')])
    // })
    $(document).on('click', '.view_flight', function() {
        window.location.href = "view_flight.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_flight', function() {
        _conf_str("Are you sure to delete this Flight?", "delete_flight", [$(this).attr(
            'data-id')]);
    });
    $(document).on('click', '.view_model', function() {
        window.location.href = "view_model.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_model', function() {
        _conf_str("Are you sure to delete this Model?", "delete_model", [$(this).attr(
            'data-id')]);
    });

    $(document).on('click', '.delete_super', function() {
        _conf_str("Are you sure to delete this supervisee[" + $(this).attr('data-id') + "] ?" , "delete_super", [$(this).attr(
            'data-id')]);
    });
})

function delete_flight($flightid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_flight',
        method: 'POST',
        data: {
            flightid: $flightid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                alert_toast('Data failed to delete.', "error");
                setTimeout(function() {
                    // location.replace('index.php?page=list_airplane')
                    location.replace('index.php?page=view_flight&id='.$_GET['id'])
                }, 750)
            }
        }
    })
}

function delete_model($id) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_model',
        method: 'POST',
        data: {
            id: $id
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                alert_toast('Data failed to delete.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_model')
                }, 750)
            }
        }
    })
}

function delete_super($data) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_super',
        method: 'POST',
        data: {
            data: $data
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                alert_toast('Data failed to delete.', "fail");
                setTimeout(function() {
                    location.reload()
                }, 750)
            }
        }
    })
}
</script>