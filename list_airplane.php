<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_airplane"><i class="fa fa-plus"></i> Add New Airplane</a>
            </div>
            <?php endif; ?>
        </div>
        <!-- AirplaneID INT AUTO_INCREMENT,
        License_plate_num VARCHAR(7) UNIQUE NOT NULL,
        AirlineID CHAR(3) NOT NULL,
        OwnerID INT NOT NULL,
        ModelID INT,
        LeasedDate TIMESTAMP NOT NULL,
        MName VARCHAR(50), -->
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Airplane ID</th>
                        <th>License Plate Number</th>
                        <th>Airline ID</th>
                        <th>Owner ID</th>
                        <th>Model ID</th>
                        <th>Leased Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Airplane order by AirplaneID asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['AirplaneID'] ?></b></td>
                        <td><b><?php echo $row['License_plate_num'] ?></b></td>
                        <td><b><?php echo $row['AirlineID'] ?></b></td>
                        <td><b><?php echo $row['OwnerID'] ?></b></td>
                        <td><b><?php echo $row['ModelID'] ?></b></td>
                        <td><b><?php echo $row['LeasedDate'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airplane"
                                    href="./index.php?page=view_airplane&id=<?php echo $row['AirplaneID'] ?>"
                                    data-id="<?php echo $row['AirplaneID'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_airplane&airplaneid=<?php echo $row["AirplaneID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_airplane" href="javascript:void(0)"
                                    data-id="<?php echo $row['AirplaneID'] ?>">Delete</a>
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

    // NOTE HONG XOA
    // $('.view_airplane').click(function() {
    //     window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    // })

    // $('.delete_airplane').click(function() {
    //     _conf("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
    //         'data-id')])
    // })
    $(document).on('click', '.view_airplane', function() {
        window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_airplane', function() {
        _conf_str("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
            'data-id')]);
    });
})

function delete_airplane($airplaneid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_airplane',
        method: 'POST',
        data: {
            airplaneid: $airplaneid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                alert_toast('Data failed to delete.', "fail");
                setTimeout(function() {
                    location.replace('index.php?page=list_airplane')
                }, 750)
            }
        }
    })
}
</script>