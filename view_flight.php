<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Flight 
                        JOIN Airplane ON Airplane.AirplaneID = Flight.AirplaneID
                        JOIN Route ON Flight.RID = Route.ID 
                        JOIN Model ON Airplane.ModelID = Model.ID
                        where FlightID = ".$_GET['id'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
$fid =  $_GET['id'];
?>
<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-3">
                            <dl>
                                <dt><b class="border-bottom border-primary">Flight Code</b></dt>
                                <dd><?php echo ucwords($FlightCode) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Airplane ID</b></dt>
                                <dd><?php echo ucwords($AirplaneID) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Status</b></dt>
                                <dd><?php echo ucwords($Status) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-3">
                            <?php 
                                if (strpos($RName, 'SGN-') !== false) {
                                    list($from, $to) = explode('-', $RName);
                                } elseif (strpos($RName, '-SGN') !== false) {
                                    list($to, $from) = explode('-', $RName);
                                }
                            ?>
                            <dl>
                                <dt><b class="border-bottom border-primary">From</b></dt>
                                <dd><?php echo ucwords($from) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">To</b></dt>
                                <dd><?php echo ucwords($to) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Base Price</b></dt>
                                <dd><?php echo ucwords($BasePrice) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-3">
                            <dl>
                                <dt><b class="border-bottom border-primary">Expected Departure Time</b></dt>
                                <dd><?php echo ucwords($EDT) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Actual Departure Time</b></dt>
                                <dd><?php echo ucwords($ADT) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Revenue</b></dt>
                                <dd>
                                    <?php 
                                        $qry2 = $conn->query("SELECT COALESCE(revenue_flights({$_GET['id']}), 0) as total")->fetch_assoc();
                                        echo $qry2['total'] 
                                    ?>
                                </dd>
                            </dl>
                        </div>
                        <div class="col-md-3">
                            <dl>
                                <dt><b class="border-bottom border-primary">Expected Arrival Time</b></dt>
                                <dd><?php echo ucwords($EAT) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Actual Arrival Time</b></dt>
                                <dd><?php echo ucwords($AAT) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Number of Seat</b></dt>
                                <dd><?php echo ucwords(ROUND($Capacity*0.9)) ?></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary" id="list">
                <div class="card-header">
                    <span><b>Flight Employees On This Flight</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>SSN</th>
                                <th>Name</th>
                                <th>Phone Number</th>
                                <th>Date Of Birth</th>
                                <th>Sex</th>
                                <th>Role</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT Employee.SSN AS ssn, Employee.Phone, CONCAT(Employee.Fname, ' ', Employee.Lname) as Name, Employee.DOB, Employee.Sex,
                                    CASE 
                                        WHEN Operates.Role = 'Pilot' THEN 'Pilot'
                                        WHEN Operates.Role = 'Flight Attendant' THEN 'Flight Attendant'
                                    END AS Role
                                    FROM Employee JOIN Operates ON Employee.SSN = Operates.FSSN
                                    WHERE Operates.FlightID = '".$_GET['id']."'
                                ");

                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ssn'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['Phone'] ?></td>
                                    <td class=""><?php echo $row['DOB'] ?></td>
                                    <td class=""><?php echo $row['Sex'] ?></td>
                                    <td class=""><?php echo $row['Role'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_employee"
                                                href="./index.php?page=view_employee&ssn=<?php echo $row['ssn'] ?>"
                                                data-id="<?php echo $row['ssn'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_employee&ssn=<?php echo $row["ssn"]; ?>"
                                                data-id="<?php echo $row['ssn'] ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_employee" href="javascript:void(0)"
                                                data-id="<?php echo $row['ssn'] ?>">Delete</a>
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
            <div class="card card-outline card-primary" id="list">
                <div class="card-header">
                    <span><b>Passenger On This Flight</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>PID</th>
                                <th>Passport Number</th>
                                <th>Passenger Name</th>
                                <th>Date Of Birth</th>
                                <th>Nationality</th>
                                <th>Sex</th>
                                <th>Seat Num</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT Passenger.PID_Decode, Passenger.PID, Passenger.PassportNo, CONCAT(Passenger.Fname, ' ', Passenger.Lname) as Name, Passenger.DOB, Passenger.Sex, Passenger.Nationality, Ticket.SeatNum
                                    FROM Ticket
                                    JOIN Seat ON Ticket.FlightID = Seat.FlightID AND Ticket.SeatNum = Seat.SeatNum
                                    JOIN Passenger ON Passenger.PID = Ticket.PID
                                    WHERE Ticket.FlightID = '".$_GET['id']."'
                                ");

                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['PID_Decode'] ?></td>
                                    <td class=""><?php echo $row['PassportNo'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['DOB'] ?></td>
                                    <td class=""><?php echo $row['Nationality'] ?></td>
                                    <td class=""><?php echo $row['Sex'] ?></td>
                                    <td class=""><?php echo $row['SeatNum'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_passenger"
                                                href="./index.php?page=view_passenger&pid=<?php echo $row['PID'] ?>"
                                                data-id="<?php echo $row['PID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_passenger&pid=<?php echo $row["PID"]; ?>"
                                                data-id="<?php echo $row['PID'] ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_passenger" href="javascript:void(0)"
                                                data-id="<?php echo $row['PID'] ?>">Delete</a>
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
            <div class="card card-outline card-primary" id="list1">
                <div class="card-header">
                    <span><b>Seat Of This Flight</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>Flight Code</th>
                                <th>Seat No</th>
                                <th>Class</th>
                                <th>Status</th>
                                <th>Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT Seat.FlightID, Seat.SeatNum, Seat.Class, Seat.Status, Seat.Price, Flight.FlightCode
                                    FROM Seat
                                    JOIN Flight ON Seat.FlightID = Flight.FlightID
                                    WHERE Seat.FlightID = '".$_GET['id']."'
                                    ORDER BY SeatNum ASC
                                ");

                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightCode'] ?></td>
                                    <td class=""><?php echo $row['SeatNum'] ?></td>
                                    <td class=""><?php echo $row['Class'] ?></td>
                                    <td class=""><?php echo $row['Status'] ?></td>
                                    <td class=""><?php echo $row['Price'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
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

<script>
$(document).ready(function() {
    $('.table').dataTable();
    $(document).on('click', '.view_employee', function() {
        window.location.href = "view_employee.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_employee', function() {
        _conf_str("Are you sure to delete this Employee?", "delete_employee", [$(this).attr(
            'data-id')]);
    });
    $(document).on('click', '.view_passenger', function() {
        window.location.href = "view_employee.php?pid=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_passenger', function() {
        _conf_str("Are you sure to delete this Passenger?", "delete_passenger", [$(this).attr(
            'data-id')]);
    });
})

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
                }, 2000);
            }
        }.bind(this) // Bind this to the AJAX context
    })
}

function delete_passenger($pid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_passenger',
        method: 'POST',
        data: {
            pid: $pid
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
                }, 2000);
            }
        }.bind(this) // Bind this to the AJAX context
    })
}
</script>