<?php
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_airport">
                <div class="row">
                    <div class="col-md-12 border-right">
                        <div class="form-group">
                            <label for="" class="control-label" class="alert alert-warning" role="alert">Airport
                                Code</label>
                            <input type="text" name="APCode" class="form-control form-control-sm" required
                                value="<?php echo isset($APCode) ? $APCode : '' ?>">
                            <small id="#msg"></small>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Airport Name</label>
                            <input type="text" name="APName" class="form-control form-control-sm" maxlength="50"
                                required value="<?php echo isset($APName) ? $APName : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Airport City</label>
                            <input type="text" name="City" class="form-control form-control-sm" maxlength="50" required
                                value="<?php echo isset($City) ? $City : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Latitude</label>
                            <input type="number" name="Latitude" class="form-control form-control-sm" step="any"
                                required value="<?php echo isset($Latitude) ? $Latitude : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Longitude</label>
                            <input type="number" name="Longitude" class="form-control form-control-sm" step="any"
                                required value="<?php echo isset($Longitude) ? $Longitude : '' ?>">
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_airport'">Cancel</button>
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
    // Function to handle input in the APCode field
    $('[name="APCode"]').on('input', function() {
        var inputLength = $(this).val().length;
        if (inputLength < 3) {
            $('#msg').html(
                "<div class='alert alert-warning' role='alert'>Airport Code should be exactly 3 characters.</div>"
            );
        } else if (inputLength > 3) {
            $(this).val($(this).val().substr(0, 3)); // Trim input to 3 characters
            $('#msg').html(
                "<div class='alert alert-warning' role='alert'>Airport Code should be exactly 3 characters.</div>"
            );
        } else {
            $('#msg').html(''); // Clear any existing warning messages
        }
    });
});

$('#manage_airport').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('')
    $.ajax({
        url: 'ajax.php?action=save_airport',
        data: new FormData($(this)[0]),
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST',
        success: function(resp) {
            if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_airport')
                }, 750)
            } else if (resp == 2) {
                $('#msg').html(
                    "<div class='alert alert-danger' role='alert'>Airport Code already exist.</div>"
                );
                $('[name="APCode"]').addClass("border-danger")
                end_load()
            }
            // else {
            //     alert_toast('Data failed to saved.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_airport')
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