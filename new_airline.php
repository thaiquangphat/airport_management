<?php
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_airline">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Airline ID</label>
                            <input type="text" name="AirlineID" class="form-control form-control-sm" required
                                value="<?php echo isset($AirlineID) ? $AirlineID : '' ?>" maxlength="3">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">IATA Designator</label>
                            <input type="text" name="IATADesignator" class="form-control form-control-sm" required
                                value="<?php echo isset($IATADesignator) ? $IATADesignator : '' ?>" maxlength="2">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Airline Name</label>
                            <input type="text" name="Name" class="form-control form-control-sm" required
                                value="<?php echo isset($Name) ? $Name : '' ?>">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Country</label>
                            <input type="text" name="Country" class="form-control form-control-sm" required
                                value="<?php echo isset($Country) ? $Country : '' ?>">
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_airline'">Cancel</button>
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
$('#manage_airline').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('')
    $.ajax({
        url: 'ajax.php?action=save_airline',
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
                    location.replace('index.php?page=list_airline')
                }, 750)
            } else if (resp == 2) {
                $('#msg').html("<div class='alert alert-danger'>Airline ID already exist.</div>");
                $('[name="AirlineID"]').addClass("border-danger")
                end_load()
            } else if (resp == 3) {
                $('#msg').html(
                    "<div class='alert alert-danger'>IATA Designator already exist.</div>");
                $('[name="IATADesignator"]').addClass("border-danger")
                end_load()
            }
            // else {
            //     alert_toast('Data failed to saved.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_airline')
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