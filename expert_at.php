<?php 
    $cid = $_SESSION['cid'];
?>
<div class="col-lg-12">
    <div class="card">
        <div class="card-body">
            <form action="" id="manage_expert">
                <input hidden="hidden" name="ID" value="<?php echo isset($ID) ? $ID : $cid ?>" readonly>
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label for="" class="control-label">Consultant Name</label>
                            <?php
                                $qry = $conn->query("SELECT * FROM Consultant WHERE ID = '" . $cid . "'");
                                $row = $qry->fetch_assoc();
                                $name = $row['Name']; 
                            ?>
                            <input type="text" name="Name" class="form-control form-control-sm" required
                                value="<?php echo isset($Name) ? $Name : $name ?>" readonly>
                            <small id="#msg"></small>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Airport Code</label>
                            <select class="form-control form-control-sm select2" name="APCode">
                                <option></option>
                                <?php 
                                    $airports = $conn->query("SELECT * FROM Airport order by APCode asc ");
                                    while($row= $airports->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['APCode'] ?>"
                                    <?php echo ucwords($row['APCode'] . ': ' . $row['APName']) ?>>
                                    <?php echo ucwords($row['APCode'] . ': ' . $row['APName']) ?>
                                </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="" class="control-label">Model ID</label>
                            <select class="form-control form-control-sm select2" name="ModelID" id="modelIDSelect">
                                <option></option>
                                <?php 
                                    $models = $conn->query("SELECT * FROM Model order by ID asc ");
                                    while($row= $models->fetch_assoc()):
                                ?>
                                <option value="<?php echo $row['ID'] ?>"
                                    <?php echo ucwords($row['ID'] . ': ' . $row['MName']) ?>>
                                    <?php echo ucwords($row['ID'] . ': ' . $row['MName']) ?>
                                </option>
                                <?php endwhile; ?>
                            </select>
                        </div>
                        <div class="col-lg-12 text-right justify-content-center d-flex">
                            <button class="btn btn-primary mr-2">Add</button>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="card-body">
                            <table class="table table-hover table-bordered" id="list">
                                <thead>
                                    <tr>
                                        <th>Airport</th>
                                        <th>Model</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    $i = 1;
                                    $qry = $conn->query("SELECT * FROM Expert_At JOIN Airport ON Expert_At.APCode = Airport.APCode JOIN Model ON Expert_At.ModelID = Model.ID WHERE ConsultID = '" . $cid . "'");
                                    $i++;
                                    while($row= $qry->fetch_assoc()):
                                    ?>
                                    <tr>
                                        <td><b><?php echo $row['APName'] ?></b></td>
                                        <td><b><?php echo $row['MName'] ?></b></td>
                                        <td class="">
                                            <button type="button"
                                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                                data-toggle="dropdown" aria-expanded="true">
                                                Action
                                            </button>
                                            <div class="dropdown-menu" style="">
                                                <a class="dropdown-item delete_expert" href="javascript:void(0)"
                                                    data-id="<?php echo $row['ConsultID'].'-'.$row['APCode'].'-'.$row['ModelID']?>">
                                                    Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                    <?php endwhile; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <form action="" id="finish">
                <div class="col-lg-12 text-right justify-content-center d-flex">
                    <button class="btn btn-primary mr-2">Save</button>
                    <button class="btn btn-secondary" type="button"
                        onclick="location.href = 'index.php?page=list_consultant'">Cancel</button>
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
    // Function to handle change event of the select element for OwnerID
    $('#manage_expert select[name="APCode"]').change(function() {
        var selectedAPCode = $(this).val();
        // var selectedOwnerID = parseInt($(this).val());
        $('#manage_expert input[name="APCode"]').val(selectedAPCode);
    });

    // Function to handle change event of the select element for ModelID
    $('#manage_expert select[name="ModelID"]').change(function() {
        var selectedModelID = $(this).val();
        $('#manage_expert input[name="ModelID"]').val(selectedModelID);
    });

    $(document).on('click', '.delete_expert', function() {
        _conf_str("Are you sure to delete this expertise [" + $(this).attr('data-id') + "] ?",
            "delete_expert", [$(this).attr('data-id')]);
    });
})

$('#manage_expert').submit(function(e) {
    e.preventDefault()
    start_load()
    $('#msg').html('');

    $.ajax({
        url: 'ajax.php?action=new_expert',
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
            } else if (resp == 2) {
                alert_toast('Duplicate value exist.', "error");
                setTimeout(function() {
                    location.reload()
                }, 750)
            } else if (resp == 1) {
                alert_toast('Data successfully saved.', "success");
                setTimeout(function() {
                    location.reload()
                }, 750)
            }
            // else {
            //     alert_toast('Data failed to saved.', "error");
            //     setTimeout(function() {
            //         location.reload()
            //     }, 750)
            // }
            else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 2000);
            }
        }.bind(this) // Bind this to the AJAX context
    })
})

function delete_expert($data) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_expert',
        method: 'POST',
        data: {
            data: $data
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else if (resp == 3) {
                alert_toast('Debug', "error");
                setTimeout(function() {
                    location.reload();
                }, 750)
            }
            // else {
            //     alert_toast('Data failed to delete.', "error");
            //     setTimeout(function() {
            //         location.reload();
            //     }, 750)
            // }
            else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 2000);
            }
        }.bind(this) // Bind this to the AJAX context
    })
}
</script>