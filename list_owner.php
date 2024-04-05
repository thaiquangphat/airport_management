<?php include'db_connect.php' ?>
<div>
    <label for="owner-type">Choose Owner Type:</label>
    <select id="owner-type">
        <option value="person">Person</option>
        <option value="cooperation">Cooperation</option>
    </select>
</div>
<div id="person-table" style="" class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_owner_person"><i class="fa fa-plus"></i> Add New Owner-Person</a>
            </div>
            <?php endif; ?>
        </div>
        <!-- SSN CHAR(10),
        Name VARCHAR(50),
        Phone CHAR(10),
        Address VARCHAR(50),
        OwnerID INT, -->
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list">
                <thead>
                    <tr>
                        <th>Person SSN</th>
                        <th>Person Name</th>
                        <th>Person Phone</th>
                        <th>Person Address</th>
                        <th>Owner ID</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Person order by SSN asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['SSN'] ?></b></td>
                        <td><b><?php echo $row['Name'] ?></b></td>
                        <td><b><?php echo $row['Phone'] ?></b></td>
                        <td><b><?php echo $row['Address'] ?></b></td>
                        <td><b><?php echo $row['OwnerID'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airline"
                                    href="./index.php?page=view_person&ownerid=<?php echo $row['OwnerID'] ?>"
                                    data-id="<?php echo $row['OwnerID'] ?>">View</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_person&ownerid=<?php echo $row["OwnerID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_person" href="javascript:void(0)"
                                    data-id="<?php echo $row['OwnerID'] ?>">Delete</a>
                            </div>
                        </td>
                    </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="cooperation-table" style="display: none;" class="col-lg-12">
    <div class="card card-outline card-success">
        <div class="card-header">
            <?php if($_SESSION['login_type'] == 1): ?>
            <div class="card-tools">
                <a class="btn btn-block btn-sm btn-default btn-flat border-primary"
                    href="./index.php?page=new_owner_cooperation"><i class="fa fa-plus"></i> Add New
                    Owner-Cooperation</a>
            </div>
            <?php endif; ?>
        </div>
        <!-- Name VARCHAR(50),
        Address VARCHAR(50),
        Phone CHAR(10),
        OwnerID INT, -->
        <div class="card-body">
            <table class="table table-hover table-bordered" id="list1">
                <thead>
                    <tr>
                        <th>Cooperation Name</th>
                        <th>Cooperation Address</th>
                        <th>Cooperation Phone</th>
                        <th>Owner ID</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
					$i = 1;
					$qry = $conn->query("SELECT * FROM Cooperation order by Name asc");
                    $i++;
					while($row= $qry->fetch_assoc()):
					?>
                    <tr>
                        <td><b><?php echo $row['Name'] ?></b></td>
                        <td><b><?php echo $row['Address'] ?></b></td>
                        <td><b><?php echo $row['Phone'] ?></b></td>
                        <td><b><?php echo $row['OwnerID'] ?></b></td>
                        <td class="text-center">
                            <button type="button"
                                class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                data-toggle="dropdown" aria-expanded="true">
                                Action
                            </button>
                            <div class="dropdown-menu" style="">
                                <a class="dropdown-item view_airline"
                                    href="./index.php?page=view_cooperation&ownerid=<?php echo $row['OwnerID'] ?>"
                                    data-id="<?php echo $row['OwnerID'] ?>">View</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item"
                                    href="./index.php?page=edit_cooperation&ownerid=<?php echo $row["OwnerID"]; ?>">Edit</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item delete_cooperation" href="javascript:void(0)"
                                    data-id="<?php echo $row['OwnerID'] ?>">Delete</a>
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
    $('#list1').dataTable()

    document.getElementById('owner-type').addEventListener('change', function() {
        var selectedOption = this.value;
        // Hide all tables
        document.getElementById('person-table').style.display = 'none';
        document.getElementById('cooperation-table').style.display = 'none';
        // Show the selected table
        document.getElementById(selectedOption + '-table').style.display = 'block';
    });

    $(document).on('click', '.view_person', function() {
        window.location.href = "view_person.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_person', function() {
        _conf_str("Are you sure to delete this Owner-Person?", "delete_owner", [$(this).attr(
            'data-id')]);
    });

    $(document).on('click', '.view_cooperation', function() {
        window.location.href = "view_cooperation.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_cooperation', function() {
        _conf_str("Are you sure to delete this Owner-Cooperation?", "delete_owner", [$(this).attr(
            'data-id')]);
    });
})

function delete_owner($ownerid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_owner',
        method: 'POST',
        data: {
            ownerid: $ownerid
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
                    location.replace('index.php?page=list_owner')
                }, 750)
            }
        }
    })
}
</script>