<?php include 'db_connect.php' ?>
<div class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_employee"><i class="fa fa-plus"></i> Add New Employee</a>
            </div>
            <?php endif; ?>
        </div>
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>SSN</th>
                        <th>Name</th>
                        <th>Sex</th>
                        <th>Salary</th>
                        <th>Phone</th>
                        <th>Date of Birth</th>
                        <th>Age</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $i = 1;
                    $qry = $conn->query("SELECT E.SSN AS emp_SSN, Sex, Salary, Phone, DOB, concat(Fname,' ',Minit, ' ', Lname) as name,
                                         CASE
                                            WHEN Engineer.SSN IS NOT NULL THEN 'Engineer'
                                            WHEN FA.SSN IS NOT NULL THEN 'Flight Attendant'
                                            WHEN P.SSN IS NOT NULL THEN 'Pilot'
                                            WHEN TC.SSN IS NOT NULL THEN 'Traffic Controller'
                                            WHEN ASup.SSN IS NOT NULL THEN 'Administrative Support'
                                            ELSE 'Unknown'
                                        END as role
                                        FROM Employee E
                                        LEFT JOIN Engineer ON E.SSN = Engineer.SSN
                                        LEFT JOIN Flight_Attendant FA ON E.SSN = FA.SSN
                                        LEFT JOIN Pilot P ON E.SSN = P.SSN
                                        LEFT JOIN Traffic_Controller TC ON E.SSN = TC.SSN
                                        LEFT JOIN Administrative_Support ASup ON E.SSN = ASup.SSN
                                        ORDER BY E.SSN ASC");
                    $i++;
                    while($row= $qry->fetch_assoc()):
                    ?>
                    <tr>
                        <td><b><?php echo $row['emp_SSN'] ?></b></td>
                        <td><b><?php echo $row['name'] ?></b></td>
                        <td><b><?php echo $row['Sex'] ?></b></td>
                        <td><b><?php echo $row['Salary'] ?></b></td>
                        <td><b><?php echo $row['Phone'] ?></b></td>
                        <td><b><?php echo $row['DOB'] ?></b></td>
                        <td><b><?php 
                            $qry2 = $conn->query("SELECT COALESCE(CalculateAgeBySSN({$row['emp_SSN']}), 0) as empage")->fetch_assoc();
                            echo $qry2['empage']; 
                        ?></b></td>
                        <td><b><?php echo $row['role'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_employee"
                                    href="./index.php?page=view_employee&ssn=<?php echo $row['emp_SSN'] ?>"
                                    data-id="<?php echo $row['emp_SSN'] ?>">View</a>

                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_employee&ssn=<?php echo $row["emp_SSN"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_employee" href="javascript:void(0)"
                                    data-id="<?php echo $row['emp_SSN'] ?>">Delete</a>
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
            }
            // else {
            //     alert_toast('Data failed to delete.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_employee')
            //     }, 75000)
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