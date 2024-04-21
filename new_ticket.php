<?php 
    // echo $TicketID;
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_ticket">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Ticket ID</label>
                            <input type="text" name="TicketID" class="form-control form-control-sm" required
                                value="<?php echo isset($TicketID) ? $TicketID : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Passenger ID</label>
                            <input type="text" name="PID" class="form-control form-control-sm" required
                                value="<?php echo isset($PID) ? $PID : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Seat Num</label>
                            <input type="text" name="SeatNum" class="form-control form-control-sm" required
                                value="<?php echo isset($SeatNum) ? $SeatNum : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Flight ID</label>
                            <input type="text" name="FlightID" class="form-control form-control-sm" required
                                value="<?php echo isset($FlightID) ? $FlightID : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Check In Status</label>
                            <select class="form-control form-control-sm select2" name="CheckInStatus" <?php echo isset($CheckInStatus) && $CheckInStatus == 'Yes' ? 'disabled' : '' ?>>
                                <option value="Yes" <?php echo isset($CheckInStatus) && $CheckInStatus == 'Yes' ? "selected" : ''?>>Yes</option>
                                <option value="No" <?php echo isset($CheckInStatus) && $CheckInStatus == 'No' ? "selected" : '' ?>>No</option>
                            </select>
                            <?php 
                                // Add a hidden input to ensure that the value 'Yes' is still submitted even if the select is disabled
                                if (isset($CheckInStatus) && $CheckInStatus == 'Yes') {
                                    echo '<input type="hidden" name="CheckInStatus" value="Yes">';
                                }
                            ?>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Check In Time</label>
                            <input type="datetime-local" name="CheckInTime" class="form-control form-control-sm" <?php echo isset($CheckInStatus) && $CheckInStatus == 'Yes' ? 'readonly' : '' ?>
                                value="<?php echo isset($CheckInTime) ? $CheckInTime : '' ?>" required>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Book Time</label>
                            <input type="datetime-local" name="BookTime" class="form-control form-control-sm" <?php echo isset($CheckInStatus) && $CheckInStatus == 'Yes' ? 'readonly' : '' ?>
                                value="<?php echo isset($BookTime) ? $BookTime : '' ?>" required>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Cancel Time</label>
                            <input type="datetime-local" name="CancelTime" class="form-control form-control-sm"
                                value="<?php echo isset($CancelTime) ? $CancelTime : '' ?>" required>
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_employee'">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>
<style>
img#cimg {
    height: 15vh;
    width: 15vh;
    object-fit: cover;
    border-radius: 100% 100%;
}
</style>
<script>
$(document).ready(function() {
    // Function to handle change event of the select element for Sex
    $('#manage_ticket select[name="CheckInStatus"]').change(function() {
        var selectedStatus = $(this).val();
        $('#manage_employee input[name="CheckInStatus"]').val(selectedStatus);
    });

    $('#manage_ticket select[name="CheckInTime"]').change(function() {
        var selectedCheckInTime = $(this).val();
        $('#manage_employee input[name="CheckInTime"]').val(selectedCheckInTime);
    });

    $('#manage_ticket select[name="BookTime"]').change(function() {
        var selectedBookTime = $(this).val();
        $('#manage_employee input[name="BookTime"]').val(selectedBookTime);
    });
    
    $('#manage_ticket select[name="CancelTime"]').change(function() {
        var selectedCancelTime = $(this).val();
        $('#manage_employee input[name="CancelTime"]').val(selectedCancelTime);
    });
})

$('#manage_ticket').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_ticket',
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
                    location.reload();
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved, redirecting.', "success");
                setTimeout(function() {
                    location.replace("./index.php?page=view_passenger&pid=<?php echo $PID?>")
                }, 750)
            } else {
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