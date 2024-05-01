<?php
include 'db_connect.php';

$flightID = $_GET['flightid'];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $numberOfTickets = $_POST['NumberOfTickets'];
    // Here, you can add the code to save the booking details to the database
    
    // Redirect to another page or display a confirmation message
}

// Fetch flight details
$stmt = $conn->prepare("SELECT * FROM Flight WHERE FlightID = ?");
$stmt->bind_param("i", $flightID);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();

// Fetch available seats
$stmtSeats = $conn->prepare("SELECT * FROM Seat WHERE FlightID = ? AND Status = 'Available'");
$stmtSeats->bind_param("i", $flightID);
$stmtSeats->execute();
$resultSeats = $stmtSeats->get_result();
$availableSeats = $resultSeats->fetch_all(MYSQLI_ASSOC);
?>

<h2>Booking for Flight <?php echo $row['FlightCode']; ?></h2>

<div class="col-lg-12">
    <div class="card">
        <div class="card-header">
            <div class="row">
                <!-- <div class="col-md-6">
                    <div class="card-tools">
                        <a class="btn btn-sm btn-default btn-flat border-primary" href="./index.php?page=new_passenger"
                            target='_blank'> <i class="fa fa-plus"></i> Add New Passenger if Not Exist
                        </a>
                    </div>
                </div> -->
                <div class="col-md-12">
                    <div><small>Note that when the ticket has been booked, if you want to cancel the ticket, you
                            have to come to <b><a href="index.php?page=list_passenger">View Passenger</a></b></small></div>
                </div>
            </div>
        </div>
        <div class="card-body">
            <form action="" id="manage_booking">
                <input hidden="hidden" name="FID" value="<?php echo isset($FID) ? $FID : $row['FlightID'] ?>" readonly>
                <div class="row">

                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Flight Code</label>
                            <?php
                                $qry = $conn->query("SELECT * FROM Flight WHERE FlightID = '" . $row['FlightID'] . "'");
                                $frow = $qry->fetch_assoc();
                                $code = $frow['FlightCode']; 
                            ?>
                            <input type="text" name="flightcode" class="form-control form-control-sm" required
                                value="<?php echo isset($flightcode) ? $flightcode : $code ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Passenger Name</label>
                            <select class="form-control form-control-sm select2" name="PID">
                                <option></option>
                                <?php
                                    $passenger = $conn->query("SELECT *, concat(fname, ' ', minit, ' ', lname) as name FROM Passenger ORDER BY PID ASC");
                                    while($prow= $passenger->fetch_assoc()):
                                ?>
                                <option value="<?php echo $prow['PID'] ?>"
                                    <?php echo ucwords($prow['PID_Decode'] . ': ' . $prow['name']) ?>>
                                    <?php echo ucwords($prow['PID_Decode'] . ': ' . $prow['name']) ?>
                                </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Seat Choose</label>
                            <select class="form-control form-control-sm select2" name="SeatNum" id="SeatNumSelect">
                                <option></option>
                                <?php 
                                    // $seats = $conn->query("SELECT DISTINCT Seat.SeatNum, Seat.Class, Seat.Price
                                    //                        FROM Seat 
                                    //                        JOIN Ticket ON Seat.FlightID = Ticket.FlightID AND Seat.SeatNum = Ticket.SeatNum
                                    //                        WHERE Seat.FlightID = " . $row['FlightID'] . " AND Seat.Status = 'Available' 
                                    //                        AND (Seat.SeatNum) NOT IN 
                                    //                        (SELECT SeatNum FROM Ticket WHERE FlightID = " . $row['FlightID'] . " AND CheckInStatus = 'No')");
                                    
                                    // $seats = $conn->query("SELECT DISTINCT Seat.SeatNum, Seat.Class, Seat.Price
                                    //                         FROM Seat 
                                    //                         WHERE Seat.FlightID = " . $row['FlightID'] . " AND Seat.Status = 'Available' 
                                    //                         AND (Seat.SeatNum) NOT IN 
                                    //                             (SELECT SeatNum FROM Ticket WHERE FlightID = " . $row['FlightID'] . " AND (CheckInStatus = 'No' OR CancelTime <> '1970-01-01 00:00:00'))
                                    //                         ");
                                    
                                    $seats = $conn->query("SELECT DISTINCT Seat.SeatNum, Seat.Class, Seat.Price
                                                            FROM Seat 
                                                            WHERE Seat.FlightID = " . $row['FlightID'] . " AND Seat.Status = 'Available' 
                                                            AND (Seat.SeatNum) NOT IN 
                                                            (
                                                                SELECT SeatNum FROM Ticket 
                                                                WHERE Ticket.FlightID = ". $row['FlightID'] ."
                                                                AND (Ticket.CheckInStatus = 'Yes' OR (Ticket.CheckInStatus = 'No' AND Ticket.CancelTime = '1970-01-01 00:00:00'))
                                                            );
                                     ");
                                    
                                    while($srow= $seats->fetch_assoc()):
                                ?>
                                <option value="<?php echo $srow['SeatNum'] ?>"
                                    <?php echo ucwords($srow['SeatNum'] . '-' . $srow['Class'] . '-$' . $srow['Price']) ?>>
                                    <?php echo ucwords($srow['SeatNum'] . '-' . $srow['Class'] . '-$' . $srow['Price']) ?>
                                </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <div class="col-lg-12 text-right justify-content-center d-flex">
                            <button class="btn btn-primary mr-2">Book</button>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <table class="table table-hover table-bordered" id="list">
                                <thead>
                                    <tr>
                                        <!-- <th>No.</th> -->
                                        <th>Ticket ID</th>
                                        <th>PID</th>
                                        <th>Seat Number</th>
                                        <th>Flight Code</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $i = 1;
                                    $qrylog = $conn->query("SELECT * FROM new_seat_log ORDER BY logid DESC");
                                    $i++;
                                    while($rowlog= $qrylog->fetch_assoc()):
                                    ?>
                                    <tr>
                                        <!-- <td><b><?php echo $rowlog['logid'] ?></b></td> -->
                                        <td><b><?php echo $rowlog['ticket_id'] ?></b></td>
                                        <td><b><?php echo $rowlog['PID_Decode'] ?></b></td>
                                        <td><b><?php echo $rowlog['SeatNum'] ?></b></td>
                                        <td><b><?php echo $rowlog['FlightCode'] ?></b></td>
                                        <?php
                                            // get flight id for query
                                            $fid_qry = $conn->query("SELECT * FROM Flight WHERE FlightCode = '" .$rowlog['FlightCode']. "'");
                                            $fid_row = $fid_qry->fetch_assoc();
                                            $fid = $fid_row['FlightID'];

                                            // get cancel status for query
                                            $pid_pass = substr($rowlog['PID_Decode'], 1);
                                            $stat = $conn->query("SELECT * FROM Ticket WHERE PID = '" .$pid_pass. "' AND SeatNum = '" .$rowlog['SeatNum']. "' AND FlightID = '" .$fid. "' AND CancelTime <> '1970-01-01 00:00:00' LIMIT 1")->num_rows;
                                            $can_stat = "";
                                            if ($stat > 0) $can_stat = "Canceled";
                                            else $can_stat = "Booked";
                                        ?>
                                        <td><b><?php echo $can_stat ?></b></td>
                                        <td class="text-center">
                                            <button type="button"
                                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                                data-toggle="dropdown" aria-expanded="true">
                                                Action
                                            </button>
                                            <div class="dropdown-menu" style="">
                                                <a class="dropdown-item view_airplane"
                                                    href="./index.php?page=view_passenger&pid=<?php echo $pid_pass ?>"
                                                    data-id="<?php echo $pid_pass ?>">View</a>
                                            </div>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <form action="" id="finish">
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2" type="button"
                        onclick="location.href = './index.php?page=view_flight&id=<?php echo $flightID?>'">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = './index.php?page=new_passenger'">Can't find your PID, create one here</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Function to handle change event of the select element for OwnerID
    $('#manage_booking select[name="flightcode"]').change(function() {
        var selectedflightcode = $(this).val();
        // var selectedOwnerID = parseInt($(this).val());
        $('#manage_booking input[name="flightcode"]').val(selectedflightcode);
    });

    $('#manage_booking select[name="FID"]').change(function() {
        var selectedFID = $(this).val();
        // var selectedOwnerID = parseInt($(this).val());
        $('#manage_booking input[name="FID"]').val(selectedFID);
    });

    // Function to handle change event of the select element for ModelID
    $('#manage_booking select[name="PID"]').change(function() {
        var selectedPID = $(this).val();
        $('#manage_expert input[name="PID"]').val(selectedPID);
    });

    // Function to handle change event of the select element for ModelID
    $('#manage_booking select[name="SeatNum"]').change(function() {
        var selectedSeatNum = $(this).val();
        $('#manage_expert input[name="SeatNum"]').val(selectedSeatNum);
    });
})

$('#manage_booking').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_ticket',
        data: new FormData($(this)[0]),
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST',
        success: function(resp) {
            if (resp == 0) {
                alert_toast('Some field missing.', "error");
                setTimeout(function() {
                    location.reload()
                }, 750)
            } else if (resp == 2) {
                alert_toast('Duplicate value exist.', "error");
                setTimeout(function() {
                    location.reload()
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.reload()
                }, 750)
            }
            // else {
            //     alert_toast('Data failed to saved.', "error");
            //     setTimeout(function() {
            //         location.reload()
            //     }, 750)
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
})

// $('#finish').submit(function() {
//         start_load();
//         $.ajax({
//             url: 'ajax.php?action=clear_log',
//             method: 'POST',
//             success: function(resp) {
//                 if (resp == 1) {
//                     alert_toast('Data successfully saved.', "success");
//                     setTimeout(function() {
//                         location.href = "./index.php?page=list_flight";
//                     }, 2000);
//                 } else {
//                     alert_toast('Error: ' + resp, "error");
//                     setTimeout(function() {
//                         location.reload();
//                     }, 2000);
//                 }
//             }.bind(this)
//         });
//     });
</script>