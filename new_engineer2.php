<?php
    $ESSN = $_SESSION['saveSSN'];
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
                                value="<?php echo isset($ESSN) ? $ESSN : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label for="" class="control-label">EType</label>
                            <?php
                                $type="";
                                $check=$conn->query("SELECT * FROM Engineer WHERE SSN = '" . $ESSN . "' and EType = 'Avionic Engineer'")->num_rows; 
                                if ($check > 0) $type = 'Avionic Engineer';

                                $check=$conn->query("SELECT * FROM Engineer WHERE SSN = '" . $ESSN . "' and EType = 'Mechanical Engineer'")->num_rows; 
                                if ($check > 0) $type = 'Mechanical Engineer';

                                $check=$conn->query("SELECT * FROM Engineer WHERE SSN = '" . $ESSN . "' and EType = 'Electric Engineer'")->num_rows; 
                                if ($check > 0) $type = 'Electric Engineer';
                            ?>
                            <select class="form-control form-control-sm select2" name="EType">
                                <option></option>
                                <option value="Avionic Engineer" <?php echo isset($type) && $type == 'Avionic Engineer' ? 'selected' : '' ?>>Avionic Engineer</option>
                                <option value="Mechanical Engineer" <?php echo isset($type) && $type == 'Mechanical Engineer' ? 'selected' : '' ?>>Mechanical Engineer</option>
                                <option value="Electric Engineer" <?php echo isset($type) && $type == 'Electric Engineer' ? 'selected' : '' ?>>Electric Engineer</option>
                            </select>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_engineer'">Cancel</button>
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
    $('#manage_employee select[name="EType"]').change(function() {
        var selectedEType = $(this).val();
        $('#manage_employee input[name="EType"]').val(selectedEType);
    });
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_engineer',
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
                    location.replace('index.php?page=list_engineer')
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