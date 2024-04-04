<?php
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_airport">
                <div class="row">
                    <div class="col-md-12 border-right">
                        <div class="form-group">
                            <label for="" class="control-label">Airport Code</label>
                            <input type="text" name="APCode" class="form-control form-control-sm" required
                                value="<?php echo isset($APCode) ? $APCode : '' ?>">
                            <small id="#msg"></small>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Airport Name</label>
                            <input type="text" name="APName" class="form-control form-control-sm" required
                                value="<?php echo isset($APName) ? $APName : '' ?>">
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Airport City</label>
                            <input type="text" name="City" class="form-control form-control-sm" required
                                value="<?php echo isset($City) ? $City : '' ?>">
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
                $('#msg').html("<div class='alert alert-danger'>Airport Code already exist.</div>");
                $('[name="APCode"]').addClass("border-danger")
                end_load()
            } else {
                alert_toast('Data failed to saved.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_airport')
                }, 750)
            }
        }
    })
})
</script>