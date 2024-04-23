<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_consultant">
                <input type="hidden" name="ID" value="<?php echo isset($ID) ? $ID : '' ?>">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="" class="control-label">Consultant Name</label>
                            <input type="text" name="Name" class="form-control form-control-sm" required
                                value="<?php echo isset($Name) ? $Name : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=home'">Cancel</button>
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
// $(document).ready(function() {
//     // Function to handle change event of the select element for OwnerID
//     // $('#manage_consultant select[name="APCode"]').change(function() {
//     //     var selectedAPCode = $(this).val();
//     //     // var selectedOwnerID = parseInt($(this).val());
//     //     $('#manage_consultant input[name="APCode"]').val(selectedAPCode);
//     // });

//     // // Function to handle change event of the select element for ModelID
//     // $('#manage_consultant select[name="ModelID"]').change(function() {
//     //     var selectedModelID = $(this).val();
//     //     $('#manage_consultant input[name="ModelID"]').val(selectedModelID);
//     // });
// })

$('#manage_consultant').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=save_consultant',
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
                    location.reload()
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=expert_at')
                }, 750)
            } else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 2000);
            } 
        }.bind(this) // Bind this to the AJAX context
            // else {
            //     alert_toast('Data failed to saved.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_consultant')
            //     }, 750)
            // }
        //     else {
        //         alert_toast('Error: ' + resp,
        //             "error"); // Display the error message returned from the server
        //         setTimeout(function() {
        //             location.reload();
        //         }, 2000);
        //     } else {
        //         alert_toast('Data failed to saved.', "error");
        //         setTimeout(function() {
        //             location.reload()
        //         }, 750)
        //     }
        // }.bind(this) // Bind this to the AJAX context

    })
})
</script>