<?php
    $fid = $_SESSION['fid'];
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

<!--  -->

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-4">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Flight Employee List</b></span>
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
                                $flight_employee = $conn->query("SELECT Operates.fssn, CONCAT(Employee.Fname, ' ', Employee.Lname) as name, 
                                                                CASE 
                                                                    WHEN Operates.Role = 'FA' THEN 'Flight Attendant'
                                                                    ELSE 'Pilot'
                                                                END AS Role
                                                                FROM Operates JOIN Employee ON Operates.fssn = Employee.ssn WHERE FlightID = '" . $fid . "'");

                                $i++;
                                while ($row = $flight_employee->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['name'] ?></td>
                                    <td class=""><b><?php echo ucwords($row['Role']) ?></b></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_employee"
                                                href="./index.php?page=view_employee&id=<?php echo $row['fssn'] ?>"
                                                data-id="<?php echo $row['fssn'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_operate" href="javascript:void(0)"
                                                data-id="<?php echo $row['fssn'] ?>">Remove</a>
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
                    <span><b>Employee List</b></span>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered" id="list">
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
                                $flight_employee = $conn->query("SELECT Pilot.ssn, CONCAT(Employee.Fname, ' ', Employee.Lname) as name, 'Pilot' AS Role
                                                                FROM Pilot JOIN Employee ON Pilot.ssn = Employee.ssn WHERE Pilot.ssn NOT IN (
                                                                    SELECT Operates.fssn
                                                                    FROM Operates JOIN Employee ON Operates.fssn = Employee.ssn WHERE FlightID = '" . $fid . "')
                                                                UNION 
                                                                SELECT Flight_Attendant.ssn, CONCAT(Employee.Fname, ' ', Employee.Lname) as name, 'Flight Attendant' AS Role
                                                                FROM Flight_Attendant JOIN Employee ON Flight_Attendant.ssn = Employee.ssn WHERE Flight_Attendant.ssn NOT IN (
                                                                    SELECT Operates.fssn
                                                                    FROM Operates JOIN Employee ON Operates.fssn = Employee.ssn WHERE FlightID = '" . $fid . "')");

                                $i++;
                                while ($row = $flight_employee->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['name'] ?></td>
                                    <td class=""><b><?php echo ucwords($row['Role']) ?></b></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_employee"
                                                href="./index.php?page=view_employee&id=<?php echo $row['fssn'] ?>"
                                                data-id="<?php echo $row['fssn'] ?>">View</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item add_operate" href="javascript:void(0)"
                                                data-id="<?php echo $row['fssn'] ?>">Remove</a>
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
    <hr>
        <div class="col-lg-12 text-right justify-content-center d-flex">
            <button class="btn btn-primary mr-2">Save</button>
            <button class="btn btn-secondary" type="button"
                onclick="location.href = 'index.php?page=list_flight'">Cancel</button>
        </div>
    <hr>
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