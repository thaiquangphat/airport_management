<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th class="text-center">Route ID</th>
                        <th>Route Name</th>
                        <th>No Flight</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Route order by ID asc");
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <th class="text-center"><?php echo $row['ID'] ?></th>
                        <td><b><?php echo ucwords($row['RName']) ?></b></td>
                        <td><b><?php 
                                $qry2 = $conn->query("SELECT count(*) as total FROM Flight where RID = ".$row['ID'])->fetch_assoc();
                                echo $qry2['total'] 
                        ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_route"
                                    href="./index.php?page=view_route&id=<?php echo $row['ID'] ?>"
                                    data-id="<?php echo $row['ID'] ?>">View</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_route" href="javascript:void(0)"
                                    data-id=<?php echo $row['ID'] ?>>Delete</a>
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

    $(document).on('click', '.view_route', function() {
        window.location.href = "view_route.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_route', function() {
        _conf_str("Are you sure to delete this Route?", "delete_route", [$(this).attr(
            'data-id')]);
    });
})

function delete_route($id) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_route',
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
            } else {
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