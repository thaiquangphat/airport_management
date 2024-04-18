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
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Airport Code</label>
                            <select class="form-control form-control-sm select2" name="APCode">
                                <option></option>
                                <?php 
                                    $airports = $conn->query("SELECT * FROM Airport order by APCode asc ");
                                    while($row= $airports->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['APCode'] ?>"
                                    <?php echo isset($APCode) && $APCode == $row['APCode'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['APCode'] . ': ' . $row['APName']) ?>
                                </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Model ID</label>
                            <select class="form-control form-control-sm select2" name="ModelID" id="modelIDSelect">
                                <option></option>
                                <?php 
                                    $models = $conn->query("SELECT * FROM Model order by ID asc ");
                                    while($row= $models->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['ID'] ?>"
                                    <?php echo isset($ModelID) && $ModelID == $row['ID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['ID'] . ': ' . $row['MName']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                </div>

                <hr>
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_airplane'">Cancel</button>
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
    // document.getElementById('owner-type-chosen').addEventListener('change', function() {
    //     var selectedOption = this.value;
    //     // Hide all tables
    //     document.getElementById('person-choose').style.display = 'none';
    //     document.getElementById('cooperation-choose').style.display = 'none';
    //     // Show the selected table
    //     document.getElementById(selectedOption + '-choose').style.display = 'block';
    // });

    // Function to handle change event of the select element for OwnerID
    $('#manage_consultant select[name="APCode"]').change(function() {
        var selectedAPCode = $(this).val();
        // var selectedOwnerID = parseInt($(this).val());
        $('#manage_consultant input[name="APCode"]').val(selectedAPCode);
    });

    // Function to handle change event of the select element for ModelID
    $('#manage_consultant select[name="ModelID"]').change(function() {
        var selectedModelID = $(this).val();
        $('#manage_consultant input[name="ModelID"]').val(selectedModelID);
    });
})

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
                alert_toast('Some field missing.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_consultant')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_consultant')
                }, 750)
            } else {
                alert_toast('Data failed to saved.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_consultant')
                }, 750)
            }
        }
    })
})
</script>