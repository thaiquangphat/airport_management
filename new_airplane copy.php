<?php 
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_airplane">
                <input type="hidden" name="AirplaneID" value="<?php echo isset($AirplaneID) ? $AirplaneID : '' ?>">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">License Plate Number</label>
                            <input type="text" name="License_plate_num" class="form-control form-control-sm" required
                                value="<?php echo isset($License_plate_num) ? $License_plate_num : '' ?>">
                            <small id="#msg"></small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Airline ID</label>
                            <select class="form-control form-control-sm select2" name="AirlineID">
                                <option></option>
                                <?php 
                                    $airlines = $conn->query("SELECT * FROM Airline order by Name asc ");
                                    while($row= $airlines->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['AirlineID'] ?>"
                                    <?php echo isset($AirlineID) && $AirlineID == $row['AirlineID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['Name']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="owner-type-chosen">Choose Owner Type:</label>
                            <select id="owner-type-chosen">
                                <option value="person">Person</option>
                                <option value="cooperation">Cooperation</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div id="person-choose" style="" class="form-group">
                            <label for="" class="control-label">Owner-Person Name</label>
                            <select class="form-control form-control-sm select2" name="OwnerID">
                                <option></option>
                                <?php 
                                    $persons = $conn->query("SELECT * FROM Person order by Name asc ");
                                    while($row= $persons->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['OwnerID'] ?>"
                                    <?php echo isset($OwnerID) && $OwnerID == $row['OwnerID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['Name']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <div id="cooperation-choose" style="display: none;" class="form-group">
                            <label for="" class="control-label">Owner-Cooperation Name</label>
                            <select class="form-control form-control-sm select2" name="OwnerID">
                                <option></option>
                                <?php 
                                    $coops = $conn->query("SELECT * FROM Cooperation order by Name asc ");
                                    while($row= $coops->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['OwnerID'] ?>"
                                    <?php echo isset($OwnerID) && $OwnerID == $row['OwnerID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['Name']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Model ID</label>
                            <select class="form-control form-control-sm select2" name="ModelID">
                                <option></option>
                                <?php 
                                    $models = $conn->query("SELECT * FROM Model order by MName asc ");
                                    while($row= $models->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['ID'] ?>"
                                    <?php echo isset($ModelID) && $ModelID == $row['ID'] ? "selected" : '' ?>>
                                    <?php echo ucwords($row['MName']) ?></option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="" class="control-label">Leased Date</label>
                            <input type="date" class="form-control form-control-sm" autocomplete="off" name="LeasedDate"
                                value="<?php echo isset($LeasedDate) ? date("Y-m-d",strtotime($LeasedDate)) : '' ?>">
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
    document.getElementById('owner-type-chosen').addEventListener('change', function() {
        var selectedOption = this.value;
        // Hide all tables
        document.getElementById('person-choose').style.display = 'none';
        document.getElementById('cooperation-choose').style.display = 'none';
        // Show the selected table
        document.getElementById(selectedOption + '-choose').style.display = 'block';
    });

    // Function to handle change event of the select element for AirlineID
    // $('#manage_airplane select[name="AirlineID"]').change(function() {
    //     var selectedAirlineID = $(this).val();
    //     $('#manage_airplane input[name="AirlineID"]').val(selectedAirlineID);
    // });

    // // Function to handle change event of the select element for OwnerID
    // $('#manage_airplane select[name="OwnerID"]').change(function() {
    //     // var selectedOwnerID = $(this).val();
    //     var selectedOwnerID = parseInt($(this).val());
    //     $('#manage_airplane input[name="OwnerID"]').val(selectedOwnerID);
    // });

    // // Function to handle change event of the select element for ModelID
    // $('#manage_airplane select[name="ModelID"]').change(function() {
    //     var selectedModelID = $(this).val();
    //     $('#manage_airplane input[name="ModelID"]').val(selectedModelID);
    // });

    // // Function to handle change event of the input element for LeasedDate
    // $('#manage_airplane input[name="LeasedDate"]').change(function() {
    //     var selectedLeasedDate = $(this).val();
    //     $('#manage_airplane input[name="LeasedDate"]').val(selectedLeasedDate);
    // });
})

$('#manage_airplane').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');
    var selectedOwnerID;
    var ownerType = $('#owner-type-chosen').val();
    if (ownerType === 'person') {
        selectedOwnerID = parseInt($('#person-choose select[name="OwnerID"]').val());
    } else if (ownerType === 'cooperation') {
        selectedOwnerID = parseInt($('#cooperation-choose select[name="OwnerID"]').val());
    }

    // Set the selectedOwnerID as the value for the OwnerID input field
    $('input[name="OwnerID"]').val(selectedOwnerID);
    $.ajax({
        url: 'ajax.php?action=save_airplane',
        data: new FormData($(this)[0]),
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST',
        success: function(resp) {
            alert(resp);
            if (resp == 0) {
                alert_toast('Some field missing.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_airplane')
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.replace('index.php?page=list_airplane')
                }, 750)
            } else if (resp == 2) {
                $('#msg').html(
                    "<div class='alert alert-danger'>Airplane ID already exist.</div>");
                $('[name="AirplaneID"]').addClass("border-danger")
                end_load()
            } else if (resp == 3) {
                $('#msg').html(
                    "<div class='alert alert-danger'>License Plate Number already exist.</div>"
                );
                $('[name="License_plate_num"]').addClass("border-danger")
                end_load()
            } else {
                alert_toast('Data failed to saved.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_airplane')
                }, 750)
            }
        }
    })
})
</script>