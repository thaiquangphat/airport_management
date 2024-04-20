<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Airline where AirlineID = '".$_GET['id']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Airline ID</b></dt>
                                <dd><?php echo ucwords($AirlineID) ?></dd>
                                <dt><b class="border-bottom border-primary">IATA Designator</b></dt>
                                <dd><?php echo ucwords($IATADesignator) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Airline Name</b></dt>
                                <dd><?php echo ucwords($Name) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Country</b></dt>
                                <dd><?php echo ucwords($Country) ?></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Airplane List:</b></span>
                    <div><small>Airplanes which belong to this Airline</small></div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <colgroup>
                                <col width="10%">
                                <col width="25%">
                                <col width="25%">
                                <col width="15%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <th>ID</th>
                                <th>License Plate Number</th>
                                <th>Owner ID</th>
                                <th>Model ID</th>
                                <th>Leased Date</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                // $tasks = $conn->query("SELECT * FROM task_list where project_id = {$id} order by task asc");
                                // Airport_Contains_Airplane 
                                $airplanes = $conn->query("SELECT * FROM Airplane JOIN Owner ON Airplane.OwnerID = Owner.OwnerID where AirlineID = '".$_GET['id']."'");

                                // Airport_Includes_Employee
                                // $employees = $conn->query("SELECT * FROM Airport_Includes_Employee JOIN Employee ON Airport_Includes_Employee.SSN = Employee.SSN  where APCode = {$apcode}");
                                $i++;
                                while($row=$airplanes->fetch_assoc()):
                                    // $trans = get_html_translation_table(HTML_ENTITIES,ENT_QUOTES);
                                    // unset($trans["\""], $trans["<"], $trans[">"], $trans["<h2"]);
                                    // $desc = strtr(html_entity_decode($row['description']),$trans);
                                    // $desc=str_replace(array("<li>","</li>"), array("",", "), $desc);
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['AirplaneID'] ?></td>
                                    <td class=""><b><?php echo ucwords($row['License_plate_num']) ?></b></td>
                                    <td class="">
                                        <p class="truncate"><?php echo ($row['OwnerID']) ?></p>
                                    </td>
                                    <td class="">
                                        <p class="truncate"><?php echo ($row['ModelID']) ?></p>
                                    </td>
                                    <td>
                                        <p><?php echo date("F d, Y",strtotime($row['LeasedDate'])) ?></p>
                                    </td>
                                    <td class="">
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
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.truncate {
    -webkit-line-clamp: 1 !important;
}
</style>
<script>
$(document).ready(function() {
    $('#list').dataTable()

    $(document).on('click', '.view_airplane', function() {
        window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_airplane', function() {
        _conf_str("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
            'data-id')]);
    });
})

function delete_airplane($airplaneid) {
    start_load();
    $.ajax({
        url: 'ajax.php?action=delete_airplane',
        method: 'POST',
        data: {
            airplaneid: $airplaneid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success');
                setTimeout(function() {
                    location.reload();
                }, 1500);
            } else {
                alert_toast('Error: ' + resp,
                    "error"); // Display the error message returned from the server
                setTimeout(function() {
                    location.reload();
                }, 750);
            }
        }.bind(this) // Bind this to the AJAX context
    });
}
</script>