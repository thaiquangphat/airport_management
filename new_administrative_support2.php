<?php
    $AdSSN = $_SESSION['saveSSN'];
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_employee">
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">SSN</label>
                            <input type="text" name="SSN" class="form-control form-control-sm" required
                                value="<?php echo isset($AdSSN) ? $AdSSN : '' ?>" readonly>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label for="" class="control-label">ASType</label>
                            <?php
                                $asType="";
                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'HR'")->num_rows; 
                                if ($check > 0) $asType = 'HR';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Secretary'")->num_rows; 
                                if ($check > 0) $asType = 'Secretary';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Data Entry'")->num_rows; 
                                if ($check > 0) $asType = 'Data Entry';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Receptionist'")->num_rows; 
                                if ($check > 0) $asType = 'Receptionist';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Communications'")->num_rows; 
                                if ($check > 0) $asType = 'Communications';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Security'")->num_rows; 
                                if ($check > 0) $asType = 'Security';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'PR'")->num_rows; 
                                if ($check > 0) $asType = 'PR';

                                $check=$conn->query("SELECT ASType FROM Administrative_Support WHERE SSN = '" . $AdSSN . "' and ASType = 'Emergency Service'")->num_rows; 
                                if ($check > 0) $asType = 'Emergency Service';
                            ?>
                            <select class="form-control form-control-sm select2" name="ASType">
                                <option value="HR" <?php echo isset($asType) && $asType == 'HR' ? 'selected' : '' ?>>HR</option>
                                <option value="Secretary" <?php echo isset($asType) && $asType == 'Secretary' ? 'selected' : '' ?>>Secretary</option>
                                <option value="Data Entry" <?php echo isset($asType) && $asType == 'Data Entry' ? 'selected' : '' ?>>Data Entry</option>
                                <option value="Receptionist" <?php echo isset($asType) && $asType == 'Receptionist' ? 'selected' : '' ?>>Receptionist</option>
                                <option value="Communications" <?php echo isset($asType) && $asType == 'Communications' ? 'selected' : '' ?>>Communications</option>
                                <option value="PR" <?php echo isset($asType) && $asType == 'PR' ? 'selected' : '' ?>>PR</option>
                                <option value="Security" <?php echo isset($asType) && $asType == 'Security' ? 'selected' : '' ?>>Sercurity</option>
                                <option value="Ground Service" <?php echo isset($asType) && $asType == 'Ground Service' ? 'selected' : '' ?>>Ground Service</option>
                                <option value="Emergency Service" <?php echo isset($asType) && $asType == 'Emergency Service' ? 'selected' : '' ?>>Emergency Service</option>
                            </select>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2" type="submit">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_administrative_support'">Cancel</button>
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
    $('#manage_employee select[name="ASType"]').change(function() {
        var selectedASType = $(this).val();
        $('#manage_employee input[name="ASType"]').val(selectedASType);
    });
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_administrative_support',
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
                    location.replace('index.php?page=list_administrative_support')
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