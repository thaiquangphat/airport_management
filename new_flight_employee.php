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
                            <select class="form-control form-control-sm select2" name="FType">
                                <option selected="selected"></option>
                                <option value="Flight Attendant">Flight Attendant</option>
                                <option value="Pilot">Pilot</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">License</label>
                            <input type="text" name="License" class="form-control form-control-sm"
                                value="<?php echo isset($License) ? $License : '' ?>"
                                placeholder="Leave blank if flight attendant">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Year Experience</label>
                            <input type="text" name="Year_Experience" class="form-control form-control-sm"
                                value="<?php echo isset($Year_Experience) ? $Year_Experience : '' ?>"
                                placeholder="Leave blank if pilot">
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
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_flight_employee',
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
            } else {
                alert_toast('Data failed to saved.', "error");
                setTimeout(function() {
                    location.reload();
                }, 750)
            }
        }
    })
})
</script>