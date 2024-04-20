<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_model">
                <input type="hidden" name="ID" value="<?php echo isset($ID) ? $ID : '' ?>">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Model Name</label>
                            <input type="text" name="MName" class="form-control form-control-sm" required
                                value="<?php echo isset($MName) ? $MName : '' ?>">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Capacity</label>
                            <input type="text" name="Capacity" class="form-control form-control-sm" required
                                value="<?php echo isset($Capacity) ? $Capacity : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Max Speed</label>
                            <input type="text" name="MaxSpeed" class="form-control form-control-sm" required
                                value="<?php echo isset($MaxSpeed) ? $MaxSpeed : '' ?>">
                        </div>
                    </div>
                </div>

                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_model'">Cancel</button>
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
    // Function to handle change event of the select element for AirlineID
    $('#manage_model select[name="MName"]').change(function() {
        var selectedMName = $(this).val();
        $('#manage_model input[name="MName"]').val(selectedMName);
    });

    // Function to handle change event of the select element for OwnerID
    $('#manage_model select[name="Capacity"]').change(function() {
        var selectedCapacity = $(this).val();
        // var selectedOwnerID = parseInt($(this).val());
        $('#manage_model input[name="Capacity"]').val(selectedCapacity);
    });

    // Function to handle change event of the select element for ModelID
    $('#manage_model select[name="MaxSpeed"]').change(function() {
        var selectedMaxSpeed = $(this).val();
        $('#manage_model input[name="MaxSpeed"]').val(selectedMaxSpeed);
    });
})

$('#manage_model').submit(function(e) {
    e.preventDefault()

    // Validate capacity
    var capacity = parseInt($('input[name="Capacity"]').val());
    if (isNaN(capacity)) {
        alert('Please enter a valid integer for Capacity.');
        return false; // Prevent form submission
    }

    // Validate max speed
    var maxSpeed = parseFloat($('input[name="MaxSpeed"]').val());
    if (isNaN(maxSpeed)) {
        alert('Please enter a valid float for Max Speed.');
        return false; // Prevent form submission
    }

    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_model',
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
                    location.replace('index.php?page=list_model')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_model')
                }, 750)
            }
            // else {
            //     alert_toast('Data failed to saved.', "error");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_model')
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