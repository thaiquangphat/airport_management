<?php 
    $ownerid = $_SESSION['ownerid'];
    // echo 'Person';
    // echo $ownerid;
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_owner">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">ID</label>
                            <input type="text" name="OwnerID" class="form-control form-control-sm" required
                                value="<?php echo isset($OwnerID) ? $OwnerID : $ownerid ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Name</label>
                            <input type="text" name="Name" class="form-control form-control-sm" required
                                value="<?php echo isset($Name) ? $Name : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Address</label>
                            <input type="text" name="Address" class="form-control form-control-sm" required
                                value="<?php echo isset($Address) ? $Address : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_owner'">Cancel</button>
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
$('#manage_owner').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_owner_cooperation',
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
                    location.replace('index.php?page=list_owner')
                }, 750)
            } else if (resp == 3) {
                alert_toast('Name exists.', "error");
                setTimeout(function() {
                    location.reload();
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