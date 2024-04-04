<?php include'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_employee"><i class="fa fa-plus"></i> Add New Flight Employee</a>
            </div>
            <?php endif; ?>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>FESSN</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT Employee.SSN, concat(Employee.Fname,' ',Employee.Minit, ' ', Employee.Lname) as name, 'Flight Attendant' as ASType FROM Employee Join Flight_Attendant on Employee.SSN = Flight_Attendant.SSN
                                         UNION
                                         SELECT Employee.SSN, concat(Employee.Fname,' ',Employee.Minit, ' ', Employee.Lname) as name, 'Pilot' as ASType FROM Employee Join Pilot on Employee.SSN = Pilot.SSN");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['SSN'] ?></b></td>
                        <td><b><?php echo $row['name'] ?></b></td>
                        <td><b><?php echo $row['ASType'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_employee"
                                    href="./index.php?page=view_employee&ssn=<?php echo $row['SSN'] ?>"
                                    data-id="<?php echo $row['SSN'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_employee&ssn=<?php echo $row["SSN"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_employee" href="javascript:void(0)"
                                    data-id="<?php echo $row['SSN'] ?>">Delete</a>
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

    $(document).on('click', '.view_employee', function() {
        window.location.href = "view_employee.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_employee', function() {
        _conf_str("Are you sure to delete this Employee?", "delete_employee", [$(this).attr(
            'data-id')]);
    });
})

function delete_employee($ssn) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_employee',
        method: 'POST',
        data: {
            ssn: $ssn
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
                    location.replace('index.php?page=list_employee')
                }, 75000)
            }
        }
    })
}
</script>