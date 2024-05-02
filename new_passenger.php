<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">

            <form action="" id="manage_passenger">
                <input type="hidden" name="PID" value="<?php echo isset($PID) ? $PID : '' ?>">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Passport Number</label>
                            <input type="text" name="PassportNo" class="form-control form-control-sm" required
                                value="<?php echo isset($PassportNo) ? $PassportNo : '' ?>" maxlength="12">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">First name</label>
                            <input type="text" name="Fname" class="form-control form-control-sm" required
                                value="<?php echo isset($Fname) ? $Fname : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Minit</label>
                            <input type="text" name="Minit" class="form-control form-control-sm" required
                                value="<?php echo isset($Minit) ? $Minit : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Last name</label>
                            <input type="text" name="Lname" class="form-control form-control-sm" required
                                value="<?php echo isset($Lname) ? $Lname : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Nationality</label>
                            <input type="text" name="Nationality" class="form-control form-control-sm" required
                                value="<?php echo isset($Nationality) ? $Nationality : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Date Of Birth</label>
                            <input type="date" class="form-control form-control-sm" autocomplete="off" name="DOB"
                                value="<?php echo isset($DOB) ? date("Y-m-d",strtotime($DOB)) : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Sex</label>
                            <select class="form-control form-control-sm select2" name="Sex">
                                <option></option>
                                <option value="F">Female</option>
                                <option value="M" selected="selected">Male</option>
                            </select>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_passenger'">Cancel</button>
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
    $('#manage_passenger select[name="Nationality"]').change(function() {
        var nationaility = $(this).val();
        $('#manage_passenger input[name="Nationality"]').val(nationaility);
    });
    // Function to handle change event of the select element for Sex
    $('#manage_passenger select[name="Sex"]').change(function() {
        var selectedGender = $(this).val();
        $('#manage_passenger input[name="Sex"]').val(selectedGender);
    });

    // Function to handle change event of the input element for Date Of Birth
    $('#manage_passenger input[name="DOB"]').change(function() {
        var selectedDateOfBirth = $(this).val();
        $('#manage_passenger input[name="DOB"]').val(selectedDateOfBirth);
    });
})

$('#manage_passenger').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_passenger',
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
                    location.replace('index.php?page=list_passenger')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_passenger')
                }, 750)
            } else if (resp == 3) {
                $('#msg').html(
                    "<div class='alert alert-danger'>Passport Number already exist.</div>");
                $('[name="PassportNo"]').addClass("border-danger")
                end_load()
            }
            // else {
            //     alert_toast('Data failed to saved.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_passenger')
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