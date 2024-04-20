<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary" href="./index.php?page=new_model"><i
                        class="fa fa-plus"></i> Add New Model</a>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Model ID</th>
                        <th>Model Name</th>
                        <th>Capacity</th>
                        <th>Max Speed</th>
                        <th>No Engineer Expertise</th>
                        <th>No Airplane of this Model</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Model order by ID asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['ID'] ?></b></td>
                        <td><b><?php echo $row['MName'] ?></b></td>
                        <td><b><?php echo $row['Capacity'] ?></b></td>
                        <td><b><?php echo $row['MaxSpeed'] ?></b></td>
                        <td><b><?php 
                                $qry2 = $conn->query("SELECT count(*) as total FROM Model JOIN Expertise ON Model.ID = Expertise.ModelID where ID = ".$row['ID'])->fetch_assoc();
                                echo $qry2['total'] 
                        ?></b></td>
                        <td><b><?php 
                                $qry3 = $conn->query("SELECT count(*) as total FROM Airplane where ModelID = ".$row['ID'])->fetch_assoc();
                                echo $qry3['total'] 
                        ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airplane"
                                    href="./index.php?page=view_model&id=<?php echo $row['ID'] ?>"
                                    data-id="<?php echo $row['ID'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_model&modelid=<?php echo $row["ID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_model" href="javascript:void(0)"
                                    data-id="<?php echo $row['ID'] ?>">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    $('#list').dataTable()

    $(document).on('click', '.view_model', function() {
        window.location.href = "view_model.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_model', function() {
        _conf_str("Are you sure to delete this Model?", "delete_model", [$(this).attr(
            'data-id')]);
    });
})

function delete_model($id) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_model',
        method: 'POST',
        data: {
            id: $id
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            }
            // else {
            //     alert_toast('Data failed to delete.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_model')
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
}
</script>