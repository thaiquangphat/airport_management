<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_airport"><i class="fa fa-plus"></i> Add New Airport</a>
            </div>
            <?php endif; ?>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th class="text-center">#</th>
                        <th>Airport Name</th>
                        <th>Airport Code</th>
                        <th>City</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Airport order by APName asc");
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <th class="text-center"><?php echo $i++ ?></th>
                        <td><b><?php echo $row['APName'] ?></b></td>
                        <td><b><?php echo $row['APCode'] ?></b></td>
                        <td><b><?php echo $row['City'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airport"
                                    href="./index.php?page=view_airport&id=<?php echo $row['APCode'] ?>"
                                    data-code="<?php echo $row['APCode'] ?>">View</a>

                                <!-- <a class="dropdown-item view_airport" href="javascript:void(0)"
                                    data-apcode="<?php echo $row['APCode'] ?>">View</a> -->
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_airport&apcode=<?php echo $row["APCode"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_airport" href="javascript:void(0)"
                                    data-apcode="<?php echo $row['APCode'] ?>">Delete</a>
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
    // $('.view_airport').click(function() {
    //     window.location.href = "view_airport.php?id=" + $(this).attr('data-apcode');
    // })

    // // $('.view_airport').click(function() {
    // //     uni_modal("<i class='fa fa-id-card'></i> Airport Details", "view_airport.php?id=" + $(this)
    // //         .attr(
    // //             'data-apcode'))
    // // })
    // $('.delete_airport').click(function() {
    //     _conf_str("Are you sure to delete this Airport?", "delete_airport", [$(this).attr(
    //         'data-apcode')])
    // })
    // Use event delegation for the click event
    // NOTE HONG XOA
    $(document).on('click', '.view_airport', function() {
        window.location.href = "view_airport.php?id=" + $(this).attr('data-apcode');
    });

    $(document).on('click', '.delete_airport', function() {
        _conf_str("Are you sure to delete this Airport?", "delete_airport", [$(this).attr(
            'data-apcode')]);
    });
})

function delete_airport($apcode) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_airport',
        method: 'POST',
        data: {
            apcode: $apcode
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
                    location.replace('index.php?page=list_airport')
                }, 750)
            }
        }
    })
}
</script>