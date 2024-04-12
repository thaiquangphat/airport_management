<?php
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_owner">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <input name="OwnerID" class="form-control form-control-sm" required
                                value="<?php echo isset($OwnerID) ? $OwnerID : '' ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Phone number</label>
                            <input type="text" name="Phone" class="form-control form-control-sm" required
                                value="<?php echo isset($Phone) ? $Phone : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Type</label>
                            <?php 
                                $type = 0;
                                if (isset($OwnerID)) {
                                    $qry = $conn->query("SELECT * FROM Cooperation WHERE OwnerID = '" . $OwnerID . "'");
                                    $num = $qry->fetch_assoc();
                                    if ($num > 0) $type = 1;
                                }
                            ?>
                            <select class="form-control form-control-sm select2" name="Type">
                                <option></option>
                                <option value="Cooperation" <?php echo $type == 1 ? 'selected' : '' ?>>Cooperation</option>
                                <option value="Person" <?php echo $type == 0 ? 'selected' : '' ?>>Person</option>
                            </select>
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
$(document).ready(function() {
    // Function to handle change event of the select element for Sex
    $('#manage_owner select[name="Type"]').change(function() {
        var selectedType = $(this).val();
        $('#manage_owner input[name="Type"]').val(selectedType);
    });

    $('#manage_owner input[name="ownerid"]').change(function() {
        var selectedOwnerID = $(this).val();
        $('#manage_owner input[name="ownerid"]').val(selectedOwnerID);
    });
})

$('#manage_owner').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=update_owner',
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
                    location.replace('index.php?page=list_owner')
                }, 750)
            } else if (resp == 2) {
                alert_toast('Data successfully saved, redirecting', "success");
                setTimeout(function() {
                    location.replace('index.php?page=new_owner_person')
                }, 750)
            } else if (resp == 3) {
                alert_toast('Data successfully saved, redirecting', "success");
                setTimeout(function() {
                    location.replace('index.php?page=new_owner_cooperation')
                }, 750)
            } else if (resp == 4) {
                alert_toast('Data successfully saved, redirecting', "success");
                setTimeout(function() {
                    location.replace('index.php?page=edit_owner_person')
                }, 750)
            } else if (resp == 5) {
                alert_toast('Data successfully saved, redirecting', "success");
                setTimeout(function() {
                    location.replace('index.php?page=edit_owner_cooperation')
                }, 750)
            } else if (resp == 10) {
                alert_toast('Debug', "error");
                setTimeout(function() {
                    location.reload();
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