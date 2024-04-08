<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Airport where APCode = '".$_GET['id']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<!-- View of airport
MAIN
airport name
airport code
city
latitude
longitude
owner

TEAM MEMBERS
Total employee of Airplane: ...
Member List
SSN Name Role -->

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Airport Name</b></dt>
                                <dd><?php echo ucwords($APName) ?></dd>
                                <dt><b class="border-bottom border-primary">Airport Code</b></dt>
                                <dd><?php echo ucwords($APCode) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">City</b></dt>
                                <dd><?php echo ucwords($City) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Latitude</b></dt>
                                <dd><?php echo ucwords($Latitude) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Longitude</b></dt>
                                <dd><?php echo ucwords($Longitude) ?></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Employee List:</b></span>
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
                                <col width="40%">
                                <col width="40%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $employees_selected = $conn->query("
                                    SELECT *
                                    FROM Airport_Includes_Employee
                                    WHERE APCode = '".$_GET['id']."'
                                ");

                                // Initialize an array to store employee SSNs
                                $employee_ssns = array();

                                // Fetch SSNs from the result of the query
                                while ($row = $employees_selected->fetch_assoc()) {
                                    $employee_ssns[] = $row['SSN'];
                                }

                                // Perform a LEFT JOIN with the Employee table to get employee's name and role
                                $employee_query = $conn->query("
                                    SELECT 
                                        CONCAT(Fname, ' ', Lname) AS Employee_Name,
                                        CASE
                                            WHEN Engineer.SSN IS NOT NULL THEN 'Engineer'
                                            WHEN Pilot.SSN IS NOT NULL THEN 'Pilot'
                                            WHEN Flight_Attendant.SSN IS NOT NULL THEN 'Flight Attendant'
                                            WHEN Administrative_Support.SSN IS NOT NULL THEN 'Administrative Support'
                                            WHEN Traffic_Controller.SSN IS NOT NULL THEN 'Traffic Controller'
                                            ELSE 'Unknown'
                                        END AS Role
                                    FROM 
                                        Employee
                                    LEFT JOIN Engineer ON Employee.SSN = Engineer.SSN
                                    LEFT JOIN Pilot ON Employee.SSN = Pilot.SSN
                                    LEFT JOIN Flight_Attendant ON Employee.SSN = Flight_Attendant.SSN
                                    LEFT JOIN Administrative_Support ON Employee.SSN = Administrative_Support.SSN
                                    LEFT JOIN Traffic_Controller ON Employee.SSN = Traffic_Controller.SSN
                                    WHERE Employee.SSN IN ('" . implode("','", $employee_ssns) . "')"
                                );

                                $i++;
                                while ($row = $employee_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['Employee_Name'] ?></td>
                                    <td class=""><b><?php echo ucwords($row['Role']) ?></b></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_airplane&id=<?php echo $row['AirplaneID'] ?>"
                                                data-id="<?php echo $row['AirplaneID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_airplane&airplaneid=<?php echo $row["AirplaneID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_airplane" href="javascript:void(0)"
                                                data-id="<?php echo $row['AirplaneID'] ?>">Delete</a>
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
        </div>
        <div class="col-md-8">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Airplane List:</b></span>
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
                                <col width="25%">
                                <col width="25%">
                                <col width="15%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <th>ID</th>
                                <th>License Plate Number</th>
                                <th>Owner ID</th>
                                <th>Leased Date</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                // $tasks = $conn->query("SELECT * FROM task_list where project_id = {$id} order by task asc");
                                // Airport_Contains_Airplane 
                                $airplanes = $conn->query("SELECT * FROM Airport_Contains_Airplane JOIN Airplane ON Airport_Contains_Airplane.AirplaneID = Airplane.AirplaneID JOIN Owner ON Airplane.OwnerID = Owner.OwnerID where APCode = '".$_GET['id']."'");

                                // Airport_Includes_Employee
                                // $employees = $conn->query("SELECT * FROM Airport_Includes_Employee JOIN Employee ON Airport_Includes_Employee.SSN = Employee.SSN  where APCode = {$apcode}");
                                $i++;
                                while($row=$airplanes->fetch_assoc()):
                                    // $trans = get_html_translation_table(HTML_ENTITIES,ENT_QUOTES);
                                    // unset($trans["\""], $trans["<"], $trans[">"], $trans["<h2"]);
                                    // $desc = strtr(html_entity_decode($row['description']),$trans);
                                    // $desc=str_replace(array("<li>","</li>"), array("",", "), $desc);
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['AirplaneID'] ?></td>
                                    <td class=""><b><?php echo ucwords($row['License_plate_num']) ?></b></td>
                                    <td class="">
                                        <p class="truncate"><?php echo strip_tags($row['OwnerID']) ?></p>
                                    </td>
                                    <td>
                                        <p><?php echo date("F d, Y",strtotime($row['LeasedDate'])) ?></p>
                                    </td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_airplane&id=<?php echo $row['AirplaneID'] ?>"
                                                data-id="<?php echo $row['AirplaneID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_airplane&airplaneid=<?php echo $row["AirplaneID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_airplane" href="javascript:void(0)"
                                                data-id="<?php echo $row['AirplaneID'] ?>">Delete</a>
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
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Consultant List</b></span>
                    <div><small>A Consultant is an expert of a Model at this Airport</small></div>
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
                                <col width="30%">
                                <col width="30%">
                                <col width="20%">
                                <col width="20%">
                            </colgroup>
                            <!-- CREATE TABLE Expert_At
                            (
                                ConsultID INT,
                                APCode    CHAR(3),
                                ModelID   INT,
                                PRIMARY KEY (ConsultID, APCode, ModelID),
                                FOREIGN KEY (ConsultID) REFERENCES Consultant (ID) ON DELETE CASCADE ON UPDATE CASCADE,
                                FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
                                FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
                            ); 
                            CREATE TABLE Consultant
                            (
                                ID INT AUTO_INCREMENT,
                                Name    VARCHAR(50),
                                PRIMARY KEY (ID)
                            );
                            -->
                            <thead>
                                <th>Consultant ID</th>
                                <th>Consultant Name</th>
                                <th>Model ID</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select consultants who are experts on the specific model
                                $consultants_query = $conn->query("
                                    SELECT *
                                    FROM Expert_At
                                    JOIN Consultant ON Expert_At.ConsultID = Consultant.ID
                                    WHERE Expert_At.APCode = '".$_GET['id']."'
                                ");

                                while ($row = $consultants_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ConsultID'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['ModelID'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_airplane&id=<?php echo $row['AirplaneID'] ?>"
                                                data-id="<?php echo $row['AirplaneID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_airplane&airplaneid=<?php echo $row["AirplaneID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_airplane" href="javascript:void(0)"
                                                data-id="<?php echo $row['AirplaneID'] ?>">Delete</a>
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
        $(document).on('click', '.view_airplane', function() {
            window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
        });

        $(document).on('click', '.delete_airplane', function() {
            _conf_str("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
                'data-id')]);
        });
    })

    function delete_airplane($airplaneid) {
        start_load()
        $.ajax({
            url: 'ajax.php?action=delete_airplane',
            method: 'POST',
            data: {
                airplaneid: $airplaneid
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
                        location.replace('index.php?page=view_airplane&id='.$_GET['id'])
                    }, 750)
                }
            }
        })
    }
    </script>