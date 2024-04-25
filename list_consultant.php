<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_consultant"><i class="fa fa-plus"></i> Add New Consultant</a>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Consultant ID</th>
                        <th>Consultant Name</th>
                        <th>No Airport Expert At</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Consultant order by ID asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['ID'] ?></b></td>
                        <td><b><?php echo $row['Name'] ?></b></td>
                        <td><b><?php 
                                $consultID = intval($row['ID']);  // Sanitize the ID input.
                                $query = "CALL total_expert($consultID)";  // Prepare the stored procedure call.
                            
                                if ($result = $conn->query($query)) {
                                    if ($my_row = $result->fetch_assoc()) {
                                        echo $my_row['total'];  // Output the total.
                                    }
                                    $result->close();  // Close the result set.
                                    $conn->next_result();  // Prepare the connection for the next SQL command.
                                } else {
                                    echo "Error: " . $conn->error;  // Display error if the query fails.
                                }

                                // $qry2 = $conn->query("SELECT count(*) as total FROM Expert_At where ConsultID = ".$row['ID'])->fetch_assoc();
                                // echo $qry2['total'] 
                        ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airplane"
                                    href="./index.php?page=view_consultant&id=<?php echo $row['ID'] ?>"
                                    data-id="<?php echo $row['ID'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_consultant&consultantid=<?php echo $row["ID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_consultant" href="javascript:void(0)"
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

    $(document).on('click', '.view_consultant', function() {
        window.location.href = "view_consultant.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_consultant', function() {
        _conf_str("Are you sure to delete this Consultant?", "delete_consultant", [$(this).attr(
            'data-id')]);
    });
})

function delete_consultant($consultantid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_consultant',
        method: 'POST',
        data: {
            consultantid: $consultantid
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
            //         location.replace('index.php?page=list_consultant')
            //     }, 750)
            // }
            //else {
            //    alert_toast('Error: ' + resp,
            //        "error"); // Display the error message returned from the server
            //} 
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