<?php
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_airline">
                <input type="hidden" name="AirlineID" value="<?php echo isset($AirlineID) ? $AirlineID : '' ?>">
                <div class="row">
                    <div class="col-md-12 border-right">
                        <div class="form-group">
                            <label for="" class="control-label">Airline Name</label>
                            <input type="text" name="Name" class="form-control form-control-sm" required
                                value="<?php echo isset($Name) ? $Name : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Country</label>
                            <input type="text" name="Country" class="form-control form-control-sm" required
                                value="<?php echo isset($Country) ? $Country : '' ?>">
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2" type="submit">Save</button>
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
    $.ajax({
        url: 'ajax.php?action=update_airline',
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
            } else {
                alert_toast('Data failed to save.', "error");
                setTimeout(function() {
                    location.replace('index.php?page=list_airline')
                }, 750)
            }
        }
    })
})
</script>