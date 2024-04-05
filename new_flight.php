<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_flight">
                <input type="hidden" name="FlightID" value="<?php echo isset($FlightID) ? $FlightID : '' ?>">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="">Status</label>
                            <select class="form-control form-control-sm select2" name="Status" required>
                                <option value="On Air">On Air</option>
                                <option value="Landed">Landed</option>
                                <option value="Unassigned">Unassigned</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Traffic Controller SSN</label>
                            <select class="form-control form-control-sm select2" name="TCSSN" required>
                                <option></option>
                                <?php 
                                    $TC = $conn->query("SELECT * FROM Traffic_Controller order by SSN asc ");
                                    while($row= $TC->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['SSN'] ?>"
                                    <?php echo isset($TCSSN) && $TCSSN == $row['SSN'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['SSN']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="">Route ID</label>
                            <select class="form-control form-control-sm select2" name="RID" required>
                                <option></option>
                                <?php 
                                    $routes = $conn->query("SELECT * FROM Route order by RName asc ");
                                    while($row= $routes->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['ID'] ?>"
                                    <?php echo isset($RID) && $RID == $row['ID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['ID']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Airplane ID</label>
                            <select class="form-control form-control-sm select2" name="AirplaneID" required>
                                <option></option>
                                <?php 
                                    $airplanes = $conn->query("SELECT * FROM Airplane order by AirplaneID asc ");
                                    while($row= $airplanes->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['AirplaneID'] ?>"
                                    <?php echo isset($AirplaneID) && $AirplaneID == $row['AirplaneID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['AirplaneID']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Flight Code</label>
                            <input type="text" name="FlightCode" class="form-control form-control-sm" required
                                value="<?php echo isset($FlightCode) ? $FlightCode : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Expected Arrive Time</label>
                            <input type="date" name="EAT" class="form-control form-control-sm" required
                                value="<?php echo isset($EAT) ? $EAT : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Expected Departure Time</label>
                            <input type="date" name="EDT" class="form-control form-control-sm" required
                                value="<?php echo isset($EDT) ? $EDT : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>

                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_airplane'">Cancel</button>
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
    // Function to handle change event of the select element for Status
    $('#manage_flight select[name="RID"]').change(function() {
        var selectedRID = $(this).val();
        $('#manage_flight input[name="RID"]').val(selectedRID);
    });

    $('#manage_flight select[name="Status"]').change(function() {
        var selectedStatus = $(this).val();
        $('#manage_flight input[name="Status"]').val(selectedStatus);
    });

    $('#manage_flight select[name="AirplaneID"]').change(function() {
        var selectedAirplaneID = $(this).val();
        $('#manage_flight input[name="AirplaneID"]').val(selectedAirplaneID);
    });

    $('#manage_flight select[name="TCSSN"]').change(function() {
        var selectedTCSSN = $(this).val();
        $('#manage_flight input[name="TCSSN"]').val(selectedTCSSN);
    });

    $('#manage_flight select[name="FlightCode"]').change(function() {
        var selectedFlightCode = $(this).val();
        $('#manage_flight input[name="FlightCode"]').val(selectedFlightCode);
    });

    $('#manage_flight select[name="ExpectedDepTime"]').change(function() {
        var selectedExpectedDepTime = $(this).val();
        $('#manage_flight input[name="ExpectedDepTime"]').val(selectedExpectedDepTime);
    });

    $('#manage_flight select[name="ExpectedArrTime"]').change(function() {
        var selectedExpectedArrTime = $(this).val();
        $('#manage_flight input[name="ExpectedArrTime"]').val(selectedExpectedArrTime);
    });
})

$('#manage_flight').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_flight',
        data: new FormData($(this)[0]),
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST',
        success: function(resp) {
            if (resp == 0) {
                alert_toast('Some field missing.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_flight')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_flight')
                }, 750)
            } else if (resp == 2) {
                $('#msg').html(
                    "<div class='alert alert-danger'>Flight ID already exist.</div>");
                $('[name="FlightID"]').addClass("border-danger")
                end_load()
            } else if (resp == 3) {
                $('#msg').html(
                    "<div class='alert alert-danger'>License Plate Number already exist.</div>"
                );
                $('[name="License_plate_num"]').addClass("border-danger")
                end_load()
            } else {
                alert_toast('Data failed to saved.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_flight')
                }, 750)
            }
        }
    })
})
</script>