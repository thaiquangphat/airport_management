<?php
    $TCSSN = $_SESSION['saveSSN'];
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_employee">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">SSN</label>
                            <input type="text" name="SSN" class="form-control form-control-sm" required
                                value="<?php echo isset($TCSSN) ? $TCSSN : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Morning Shift</label>
                            <select class="form-control form-control-sm select2" name="Morning">
                                <?php
                                    $type="Unpick";
                                    $num=$conn->query("SELECT * FROM TCShift WHERE TCSSN = '" . $TCSSN . "' AND Shift = 'Morning'")->num_rows;
                                    if ($num > 0) $type="Pick"; 
                                ?>
                                <option value="Unpick" <?php echo isset($type) && $type == 'Unpick' ? 'selected' : '' ?>>Unpick</option>
                                <option value="Pick" <?php echo isset($type) && $type == 'Pick' ? 'selected' : '' ?>>Pick</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Afternoon Shift</label>
                            <select class="form-control form-control-sm select2" name="Afternoon">
                                <?php
                                    $type="Unpick";
                                    $num=$conn->query("SELECT * FROM TCShift WHERE TCSSN = '" . $TCSSN . "' AND Shift = 'Afternoon'")->num_rows;
                                    if ($num > 0) $type="Pick"; 
                                ?>
                                <option value="Unpick" <?php echo isset($type) && $type == 'Unpick' ? 'selected' : '' ?>>Unpick</option>
                                <option value="Pick" <?php echo isset($type) && $type == 'Pick' ? 'selected' : '' ?>>Pick</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Evening Shift</label>
                            <select class="form-control form-control-sm select2" name="Evening">
                                <?php
                                    $type="Unpick";
                                    $num=$conn->query("SELECT * FROM TCShift WHERE TCSSN = '" . $TCSSN . "' AND Shift = 'Evening'")->num_rows;
                                    if ($num > 0) $type="Pick"; 
                                ?>
                                <option value="Unpick" <?php echo isset($type) && $type == 'Unpick' ? 'selected' : '' ?>>Unpick</option>
                                <option value="Pick" <?php echo isset($type) && $type == 'Pick' ? 'selected' : '' ?>>Pick</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="" class="control-label">Night Shift</label>
                            <select class="form-control form-control-sm select2" name="Night">
                                <?php
                                    $type="Unpick";
                                    $num=$conn->query("SELECT * FROM TCShift WHERE TCSSN = '" . $TCSSN . "' AND Shift = 'Night'")->num_rows;
                                    if ($num > 0) $type="Pick"; 
                                ?>
                                <option value="Unpick" <?php echo isset($type) && $type == 'Unpick' ? 'selected' : '' ?>>Unpick</option>
                                <option value="Pick" <?php echo isset($type) && $type == 'Pick' ? 'selected' : '' ?>>Pick</option>
                            </select>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_traffic_controller'">Cancel</button>
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
    // Function to handle change event of the select element for Morning
    $('#manage_employee select[name="Morning"]').change(function() {
        var selectedMorning = $(this).val();
        $('#manage_employee input[name="Morning"]').val(selectedMorning);
    });

    $('#manage_employee select[name="Afternoon"]').change(function() {
        var selectedAfternoon = $(this).val();
        $('#manage_employee input[name="Afternoon"]').val(selectedAfternoon);
    });

    $('#manage_employee select[name="Evening"]').change(function() {
        var selectedEvening = $(this).val();
        $('#manage_employee input[name="Evening"]').val(selectedEvening);
    });

    $('#manage_employee select[name="Night"]').change(function() {
        var selectedNight = $(this).val();
        $('#manage_employee input[name="Night"]').val(selectedNight);
    });
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_traffic_controller',
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
                    location.replace('index.php?page=list_traffic_controller')
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