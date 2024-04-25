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
<h2>Booking for Flight <?php echo $row['FlightCode'], '-', $row['FlightID']; ?></h2>

<div class="col-lg-12">
    <div class="card">
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
                                    $seats = $conn->query("SELECT Seat.SeatNum, Seat.Class, Seat.Price
                                                           FROM Seat JOIN Ticket ON Seat.FlightID = Ticket.FlightID
                                                           WHERE Seat.FlightID = " . $row['FlightID'] . " AND Seat.Status = 'Available' 
                                                           AND (Seat.FlightID, Seat.SeatNum) NOT IN 
                                                           (SELECT FlightID, SeatNum FROM Ticket)");
                                    while($srow= $seats->fetch_assoc()):
                                ?>
                                <option value="<?php echo $srow['SeatNum'] ?>"
                                    <?php echo ucwords($srow['SeatNum'] . '-' . $srow['Class'] . '-' . $srow['Price']) ?>>
                                    <?php echo ucwords($srow['SeatNum'] . '-' . $srow['Class'] . '-' . $srow['Price']) ?>
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
                                        <th>No.</th>
                                        <th>PID</th>
                                        <th>Seat Number</th>
                                        <th>Flight Code</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $i = 1;
                                    $qrylog = $conn->query("SELECT * FROM new_seat_log");
                                    $i++;
                                    while($rowlog= $qrylog->fetch_assoc()):
                                    ?>
                                    <tr>
                                        <td><b><?php echo $rowlog['logid'] ?></b></td>
                                        <td><b><?php echo $rowlog['PID_Decode'] ?></b></td>
                                        <td><b><?php echo $rowlog['SeatNum'] ?></b></td>
                                        <td><b><?php echo $rowlog['FlightCode'] ?></b></td>
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
                    <button class="btn btn-primary mr-2">Save</button>
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

$('#finish').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=clear_log',
        method: 'POST',
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
                    location.replace("index.php?page=view_flight&id=<?php echo $FID?>")
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

</script>