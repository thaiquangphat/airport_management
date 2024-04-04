<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_airline"><i class="fa fa-plus"></i> Add New Airline</a>
            </div>
            <?php endif; ?>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Airline ID</th>
                        <th>IATA Designator</th>
                        <th>Airline Name</th>
                        <th>Country</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Airline order by AirlineID asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['AirlineID'] ?></b></td>
                        <td><b><?php echo $row['IATADesignator'] ?></b></td>
                        <td><b><?php echo $row['Name'] ?></b></td>
                        <td><b><?php echo $row['Country'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airline"
                                    href="./index.php?page=view_airline&id=<?php echo $row['AirlineID'] ?>"
                                    data-id="<?php echo $row['AirlineID'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_airline&airlineid=<?php echo $row["AirlineID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_airline" href="javascript:void(0)"
                                    data-id="<?php echo $row['AirlineID'] ?>">Delete</a>
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
    // $('.view_airline').click(function() {
    //     window.location.href = "view_airline.php?id=" + $(this).attr('data-id');
    // })

    // // $('.view_airline').click(function() {
    // //     uni_modal("<i class='fa fa-id-card'></i> Airport Details", "view_airline.php?id=" + $(this)
    // //         .attr(
    // //             'data-apcode'))
    // // })
    // $('.delete_airline').click(function() {
    //     _conf_str("Are you sure to delete this Airline?", "delete_airline", [$(this).attr(
    //         'data-id')])
    // })
    $(document).on('click', '.view_airline', function() {
        window.location.href = "view_airline.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_airline', function() {
        _conf_str("Are you sure to delete this Airline?", "delete_airline", [$(this).attr(
            'data-id')]);
    });
})

function delete_airline($airlineid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_airline',
        method: 'POST',
        data: {
            airlineid: $airlineid
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
                    location.replace('index.php?page=list_airline')
                }, 750)
            }
        }
    })
}
</script>