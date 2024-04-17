<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Airplane where AirplaneID = '".$_GET['id']."'")->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<!-- View of airport
MAIN
airport name
airport code
city
latitude
longitude
owner

TEAM MEMBERS
Total employee of Airplane: ...
Member List
SSN Name Role -->

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Airplane ID</b></dt>
                                <dd><?php echo ucwords($AirplaneID) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">License Plate Numbere</b></dt>
                                <dd><?php echo ucwords($License_plate_num) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Airline ID</b></dt>
                                <dd><?php echo ucwords($AirlineID) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Owner ID</b></dt>
                                <dd><?php echo ucwords($OwnerID) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Model ID</b></dt>
                                <dd><?php echo ucwords($ModelID) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Leased Date</b></dt>
                                <dd><?php echo ucwords($LeasedDate) ?></dd>
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
                    <span><b>Flight List:</b></span>
                    <div><small>Flights using this Airplane</small></div>
                    <?php if($_SESSION['login_type'] != 3): ?>
                    <!-- <div class="card-tools">
                        <button class="btn btn-primary bg-gradient-primary btn-sm" type="button" id="new_task"><i
                                class="fa fa-plus"></i> New Task</button>
                    </div> -->
                    <?php endif; ?>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <!-- <colgroup>
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup> -->
                            <thead>
                                <th>Flight ID</th>
                                <th>Route ID</th>
                                <th>Route Name</th>
                                <th>Status</th>
                                <th>Traffic Controller SSN</th>
                                <th>AAT</th>
                                <th>ADT</th>
                                <th>Base Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Flight JOIN Route ON Flight.RID = Route.ID
                                    WHERE AirplaneID = '".$_GET['id']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightID'] ?></td>
                                    <td class=""><?php echo $row['RID'] ?></td>
                                    <td class=""><?php echo $row['RName'] ?></td>
                                    <td class=""><?php echo $row['Status'] ?></td>
                                    <td class=""><?php echo $row['TCSSN'] ?></td>
                                    <td class=""><?php echo $row['AAT'] ?></td>
                                    <td class=""><?php echo $row['ADT'] ?></td>
                                    <td class=""><?php echo $row['BasePrice'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_flight"
                                                href="./index.php?page=view_flight&id=<?php echo $row['FlightID'] ?>"
                                                data-id="<?php echo $row['FlightID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_flight&id=<?php echo $row["FlightID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_flight" href="javascript:void(0)"
                                                data-id="<?php echo $row['FlightID'] ?>">Delete</a>
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

    // NOTE HONG XOA
    // $('.view_airplane').click(function() {
    //     window.location.href = "view_airplane.php?id=" + $(this).attr('data-id');
    // })

    // $('.delete_airplane').click(function() {
    //     _conf("Are you sure to delete this Airplane?", "delete_airplane", [$(this).attr(
    //         'data-id')])
    // })
    $(document).on('click', '.view_flight', function() {
        window.location.href = "view_flight.php?id=" + $(this).attr('data-id');
    });

    $(document).on('click', '.delete_flight', function() {
        _conf_str("Are you sure to delete this Flight?", "delete_flight", [$(this).attr(
            'data-id')]);
    });
})

function delete_flight($flightid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_flight',
        method: 'POST',
        data: {
            flightid: $flightid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                alert_toast('Data failed to delete.', "error");
                setTimeout(function() {
                    // location.replace('index.php?page=list_airplane')
                    location.replace('index.php?page=view_flight&id='.$_GET['id'])
                }, 750)
            }
        }
    })
}
</script>