<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Consultant where ID = '".$_GET['id']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Consultant ID</b></dt>
                                <dd><?php echo ucwords($ID) ?></dd>
                                <dt><b class="border-bottom border-primary">Consultant Name</b></dt>
                                <dd><?php echo ucwords($Name) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">No Airport Expert At</b></dt>
                                <?php 
                                    $qry2 = $conn->query("SELECT count(*) as total FROM Expert_At where ConsultID = ".$_GET['id'])->fetch_assoc();
                                    echo $qry2['total'] 
                                ?>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Expert-Airport-Model List</b></span>
                    <div><small>This show the information of Airport and Model that this Consultant experts at.</small>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>Consultant ID</th>
                                <th>Consultant Name</th>
                                <th>Airport Code</th>
                                <th>Model ID</th>
                                <th>Model Name</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select consultants who are experts on the specific model
                                $consultants_query = $conn->query("
                                    SELECT *
                                    FROM Expert_At
                                    JOIN Consultant ON Expert_At.ConsultID = Consultant.ID
                                    JOIN Model ON Model.ID = Expert_At.ModelID
                                    JOIN Airport ON Airport.APCode = Expert_At.APCode
                                    WHERE Expert_At.ConsultID = '".$_GET['id']."'
                                ");

                                while ($row = $consultants_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ConsultID'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['APCode'] ?></td>
                                    <td class=""><?php echo $row['ModelID'] ?></td>
                                    <td class=""><?php echo $row['MName'] ?></td>
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
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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
    $(document).on('click', '.delete_expert', function() {
        _conf_str("Are you sure to delete this expertise [" + $(this).attr('data-id') + "] ?",
            "delete_expert", [$(this).attr('data-id')]);
    });
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