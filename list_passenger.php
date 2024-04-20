<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_passenger"><i class="fa fa-plus"></i> Add New Passenger</a>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Passenger ID</th>
                        <th>Name</th>
                        <th>Sex</th>
                        <th>Date of Birth</th>
                        <th>Passport Number</th>
                        <th>Nationality</th>
                        <th>Total Spent</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT *, concat(Fname,' ',Minit, ' ', Lname) as pname
                                        FROM Passenger order by PID asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['PID_Decode'] ?></b></td>
                        <td><b><?php echo $row['pname'] ?></b></td>
                        <td><b><?php echo $row['Sex'] ?></b></td>
                        <td><b><?php echo $row['DOB'] ?></b></td>
                        <td><b><?php echo $row['PassportNo'] ?></b></td>
                        <td><b><?php echo $row['Nationality'] ?></b></td>
                        <td><b><?php 
                            $qry2 = $conn->query("SELECT COALESCE(CalculateTotalSpent({$row['PID']}), 0) as total")->fetch_assoc();
                            echo $qry2['total']; 
                        ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_passenger"
                                    href="./index.php?page=view_passenger&pid=<?php echo $row['PID'] ?>"
                                    data-id="<?php echo $row['PID'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_passenger&pid=<?php echo $row["PID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_passenger" href="javascript:void(0)"
                                    data-id="<?php echo $row['PID'] ?>">Delete</a>
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

    $(document).on('click', '.view_passenger', function() {
        window.location.href = "view_passenger.php?pid=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_passenger', function() {
        _conf_str("Are you sure to delete this Passenger?", "delete_passenger", [$(this).attr(
            'data-id')]);
    });
})

function delete_passenger($pid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_passenger',
        method: 'POST',
        data: {
            pid: $pid
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
            //         location.replace('index.php?page=list_passenger')
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