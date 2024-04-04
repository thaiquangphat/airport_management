<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_employee">
            <input type="hidden" name="SSN" value="<?php echo isset($SSN) ? $SSN : '' ?>">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">New SSN</label>
                            <input type="text" name="NewSSN" class="form-control form-control-sm" placeholder="Leave this section blank if no change in SSN"
                                value="<?php echo isset($NewSSN) ? $NewSSN : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Phone number</label>
                            <input type="text" name="Phone" class="form-control form-control-sm" required
                                value="<?php echo isset($Phone) ? $Phone : '' ?>">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">First name</label>
                            <input type="text" name="Fname" class="form-control form-control-sm" required
                                value="<?php echo isset($Fname) ? $Fname : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Last name</label>
                            <input type="text" name="Lname" class="form-control form-control-sm" required
                                value="<?php echo isset($Lname) ? $Lname : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Minit</label>
                            <input type="text" name="Minit" class="form-control form-control-sm" required
                                value="<?php echo isset($Minit) ? $Minit : '' ?>">
                        </div>
                    </div>
                </div>
                <div class="row">
                <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Salary</label>
                            <input type="text" name="Salary" class="form-control form-control-sm" required
                                value="<?php echo isset($Salary) ? $Salary : '' ?>">
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
                            <label for="" class="control-label">Gender</label>
                            <select class="form-control form-control-sm select2" name="Sex">
                                <option></option>
                                <option value="F">Female</option>
                                <option selected="selected" value="M">Male</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Choose type</label>
                            <select class="form-control form-control-sm select2" name="EmpType">
                                <option></option>
                                <option value="ADSupport">Administrative Support</option>
                                <option value="FlightEmployee">Flight Employee</option>
                                <option value="Engineer">Engineer</option>
                                <option value="Traffic Controller">Traffic Controller</option>
                            </select>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2" type="submit">Save</button>
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
    $('#manage_employee select[name="Sex"]').change(function() {
        var selectedGender = $(this).val();
        $('#manage_employee input[name="Sex"]').val(selectedGender);
    });

    // Function to handle change event of the input element for Date Of Birth
    $('#manage_employee input[name="DOB"]').change(function() {
        var selectedDateOfBirth = $(this).val();
        $('#manage_employee input[name="DOB"]').val(selectedDateOfBirth);
    });

    // Function to handle change event of the input element for EmpType
    $('#manage_employee input[name="EmpType"]').change(function() {
        var selectedEmpType = $(this).val();
        $('#manage_employee input[name="EmpType"]').val(selectedEmpType);
    });
})

$('#manage_employee').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_employee',
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
                    location.replace('index.php?page=list_employee')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_employee')
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