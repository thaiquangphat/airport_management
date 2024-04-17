<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Flight JOIN Route ON Flight.RID = Route.ID where FlightID = ".$_GET['id'])->fetch_array();
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
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="10%">
                            </colgroup> -->
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
                                                href="./index.php?page=view_employee&id=<?php echo $row['ssn'] ?>"
                                                data-id="<?php echo $row['ssn'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_employee&ssn=<?php echo $row["ssn"]; ?>"
                                                data-id="<?php echo $row['ssn'] ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_operate" href="javascript:void(0)"
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
            <div class="card card-outline card-primary" id="list1">
                <div class="card-header">
                    <span><b>Passenger On This Flight</b></span>
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
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="10%">
                            </colgroup> -->
                            <thead>
                                <th>Passenger ID</th>
                                <th>Seat No</th>
                                <th>Price</th>
                                <th>Name</th>
                                <th>Passport Number</th>
                                <th>Sex</th>
                                <th>Nationality</th>
                                <th>User Created</th>
                                <th>User Name</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT DISTINCT *, CONCAT(Passenger.Fname, ' ', Passenger.Lname) as PName, CONCAT(Users.FirstName, ' ', Users.LastName) as UName
                                    FROM Passenger 
                                    JOIN Ticket ON Passenger.PID = Ticket.PID
                                    JOIN Flight ON Ticket.FlightID = Flight.FlightID
                                    JOIN Seat ON Flight.FlightID = Seat.FlightID
                                    JOIN Users ON Passenger.UserID = Users.ID
                                    WHERE Ticket.FlightID = '".$_GET['id']."'
                                ");

                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['PID'] ?></td>
                                    <td class=""><?php echo $row['SeatNum'] ?></td>
                                    <td class=""><?php echo $row['Price'] ?></td>
                                    <td class=""><?php echo $row['PName'] ?></td>
                                    <td class=""><?php echo $row['PassportNo'] ?></td>
                                    <td class=""><?php echo $row['Sex'] ?></td>
                                    <td class=""><?php echo $row['Nationality'] ?></td>
                                    <td class=""><?php echo $row['UserID'] ?></td>
                                    <td class=""><?php echo $row['UName'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_employee"
                                                href="./index.php?page=view_employee&id=<?php echo $row['ssn'] ?>"
                                                data-id="<?php echo $row['ssn'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_employee&ssn=<?php echo $row["ssn"]; ?>"
                                                data-id="<?php echo $row['ssn'] ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_operate" href="javascript:void(0)"
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
</div>

<script>
$(document).ready(function() {
    $('.table').dataTable();
    $(document).on('click', '.view_airport', function() {
        window.location.href = "view_airport.php?id=" + $(this).attr('data-apcode');
    });

    $(document).on('click', '.delete_airport', function() {
        _conf_str("Are you sure to delete this Airport?", "delete_airport", [$(this).attr(
            'data-apcode')]);
    });
})

function delete_airport($apcode) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_airport',
        method: 'POST',
        data: {
            apcode: $apcode
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
                    location.replace('index.php?page=list_airport')
                }, 750)
            }
        }
    })
}
</script>