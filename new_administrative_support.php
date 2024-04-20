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
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="form-group">
                            <label for="" class="control-label">ASType</label>
                            <select class="form-control form-control-sm select2" name="ASType">
                                <option></option>
                                <option value="HR" selected="selected">HR</option>
                                <option value="Secretary">Secretary</option>
                                <option value="Data Entry">Data Entry</option>
                                <option value="Receptionist">Receptionist</option>
                                <option value="Communications">Communications</option>
                                <option value="PR">PR</option>
                                <option value="Sercurity">Sercurity</option>
                                <option value="Ground Service">Ground Service</option>
                                <option value="Emergency Service">Emergency Service</option>
                            </select>
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
        url: 'ajax.php?action=save_administrative_support',
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