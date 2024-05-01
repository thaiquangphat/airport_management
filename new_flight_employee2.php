<?php
    $FSSN = $_SESSION['saveSSN'];
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_employee">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">SSN</label>
                            <input type="text" name="SSN" class="form-control form-control-sm" required
                                value="<?php echo isset($FSSN) ? $FSSN : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Type</label>
                            <select class="form-control form-control-sm select2" name="FType" disabled>
                                <?php
                                    $type="";
                                    $check=$conn->query("SELECT * FROM Pilot WHERE SSN = '" . $FSSN . "'")->num_rows; 
                                    if ($check > 0) $type = 'Pilot';

                                    $check=$conn->query("SELECT * FROM Flight_Attendant WHERE SSN = '" . $FSSN . "'")->num_rows; 
                                    if ($check > 0) $type = 'Flight Attendant';
                                ?>
                                <option value="Flight Attendant"
                                    <?php echo isset($type) && $type == 'Flight Attendant' ? 'selected' : '' ?>>Flight
                                    Attendant</option>
                                <option value="Pilot" <?php echo isset($type) && $type == 'Pilot' ? 'selected' : '' ?>>
                                    Pilot</option>
                            </select>
                            <input type="hidden" name="FType" value="<?php echo $type; ?>">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">License</label>
                            <?php
                                $license="";
                                $num=$conn->query("SELECT * FROM Pilot WHERE SSN = '" . $FSSN . "'")->num_rows;
                                if ($num > 0) { 
                                    $check=$conn->query("SELECT * FROM Pilot WHERE SSN = '" . $FSSN . "'"); 
                                    if ($check){
                                        $row = $check->fetch_assoc();
                                        $license = $row['License'];
                                    }
                                }
                            ?>
                            <input type="text" name="License" class="form-control form-control-sm"
                                value="<?php echo isset($license) ? $license : '' ?>"
                                placeholder="Leave blank if flight attendant">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Year Experience</label>
                            <?php
                                $year="";
                                $num=$conn->query("SELECT * FROM Flight_Attendant WHERE SSN = '" . $FSSN . "'")->num_rows;
                                if ($num > 0) {
                                    $check=$conn->query("SELECT * FROM Flight_Attendant WHERE SSN = '" . $FSSN . "'"); 
                                    if ($check){
                                        $row = $check->fetch_assoc();
                                        $year = $row['Year_experience'];
                                    }
                                }
                            ?>
                            <input type="text" name="Year_Experience" class="form-control form-control-sm"
                                value="<?php echo isset($year) ? $year : '' ?>" placeholder="Leave blank if pilot">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_flight_employee'">Cancel</button>
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
    $('#manage_employee select[name="FType"]').change(function() {
        var selectedFType = $(this).val();
        $('#manage_employee input[name="FType"]').val(selectedFType);

        // If selected type is Pilot
        if (selectedFType === 'Pilot') {
            // Make the Year Experience field readonly
            $('input[name="Year_Experience"]').prop('readonly', true);
            // Make the License field editable
            $('input[name="License"]').prop('readonly', false);
        } else if (selectedFType === 'Flight Attendant') {
            // Make the License field readonly
            $('input[name="License"]').prop('readonly', true);
            // Make the Year Experience field editable
            $('input[name="Year_Experience"]').prop('readonly', false);
        }
    });

    $('#manage_employee input[name="License"]').change(function() {
        var selectedLicense = $(this).val();
        $('#manage_employee input[name="License"]').val(selectedLicense);
    });

    $('#manage_employee input[name="Year_experience"]').change(function() {
        var selectedYear_experience = $(this).val();
        $('#manage_employee input[name="Year_experience"]').val(selectedYear_experience);
    });
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_flight_employee',
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
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_flight_employee')
                }, 750)
            }
            // else {
            //     alert_toast('Data failed to saved.', "error");
            //     setTimeout(function() {
            //         location.reload();
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
})
</script>