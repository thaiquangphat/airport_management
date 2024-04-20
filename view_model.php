<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Model where ID = '".$_GET['id']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Model ID</b></dt>
                                <dd><?php echo ucwords($ID) ?></dd>
                                <dt><b class="border-bottom border-primary">Model Name</b></dt>
                                <dd><?php echo ucwords($MName) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Capacity</b></dt>
                                <dd><?php echo ucwords($Capacity) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Max Speed</b></dt>
                                <dd><?php echo ucwords($MaxSpeed) ?></dd>
                            </dl>
                        </div>
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
                    <div><small>A Consultant is an expert of this Model at an Airport</small></div>
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
                            <thead>
                                <th>Consultant ID</th>
                                <th>Consultant Name</th>
                                <th>Airport Code</th>
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
                                    WHERE Expert_At.ModelID = '".$_GET['id']."'
                                ");

                                while ($row = $consultants_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ConsultID'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['APCode'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_consultant&id=<?php echo $row['ConsultID'] ?>"
                                                data-id="<?php echo $row['ConsultID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_consultant&consultantid=<?php echo $row["ConsultID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_consultant" href="javascript:void(0)"
                                                data-id="<?php echo $row['ConsultID'] ?>">Delete</a>
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
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Engineer List</b></span>
                    <div><small>An Engineer is an expert of this Model</small></div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>SSN</th>
                                <th>Engineer Name</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select consultants who are experts on the specific model
                                $engineer_query = $conn->query("
                                    SELECT *, CONCAT(Fname, ' ', Lname) as name
                                    FROM Expertise
                                    JOIN Engineer ON Expertise.ESSN = Engineer.SSN
                                    JOIN Employee ON Employee.SSN = Engineer.SSN
                                    WHERE Expertise.ModelID = '".$_GET['id']."'
                                ");

                                while ($row = $engineer_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ESSN'] ?></td>
                                    <td class=""><?php echo $row['name'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_employee"
                                                href="./index.php?page=view_employee&ssn=<?php echo $row['SSN'] ?>"
                                                data-id="<?php echo $row['SSN'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_employee&ssn=<?php echo $row["SSN"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_employee" href="javascript:void(0)"
                                                data-id="<?php echo $row['SSN'] ?>">Delete</a>
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
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Airplane List:</b></span>
                    <div><small>An Airplane is of this model type.</small></div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>ID</th>
                                <th>License Plate Number</th>
                                <th>Owner ID</th>
                                <th>Model ID</th>
                                <th>Leased Date</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                // $tasks = $conn->query("SELECT * FROM task_list where project_id = {$id} order by task asc");
                                // Airport_Contains_Airplane 
                                $airplanes = $conn->query("SELECT * FROM  Airplane where ModelID = '".$_GET['id']."'");

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
                                    <td class=""><b><?php echo ucwords($row['ModelID']) ?></b></td>
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
</div>

<style>
.truncate {
    -webkit-line-clamp: 1 !important;
}
</style>
<script>
$(document).ready(function() {
    $('#list').dataTable()
    $(document).on('click', '.view_consultant', function() {
        window.location.href = "view_consultant.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_consultant', function() {
        _conf_str("Are you sure to delete this Consultant?", "delete_consultant", [$(this).attr(
            'data-id')]);
    });
    $(document).on('click', '.view_airplane', function() {
        window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_airplane', function() {
        _conf_str("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
            'data-id')]);
    });
    $(document).on('click', '.view_employee', function() {
        window.location.href = "view_employee.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_employee', function() {
        _conf_str("Are you sure to delete this Employee?", "delete_employee", [$(this).attr(
            'data-id')]);
    });
})

function delete_consultant($consultantid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_consultant',
        method: 'POST',
        data: {
            consultantid: $consultantid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            }
            // else {
            //     alert_toast('Data failed to delete.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_consultant')
            //     }, 750)
            // }
            else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 750);
            }
        }.bind(this) // Bind this to the AJAX context
    })
}

function delete_airplane($airplaneid) {
    start_load();
    $.ajax({
        url: 'ajax.php?action=delete_airplane',
        method: 'POST',
        data: {
            airplaneid: $airplaneid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success');
                setTimeout(function() {
                    location.reload();
                }, 1500);
            } else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 750);
            }
        }.bind(this) // Bind this to the AJAX context
    });
}

function delete_employee($ssn) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_employee',
        method: 'POST',
        data: {
            ssn: $ssn
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            }
            // else {
            //     alert_toast('Data failed to delete.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_employee')
            //     }, 75000)
            // }
            else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 750);
            }
        }.bind(this) // Bind this to the AJAX context
    })
}
</script>