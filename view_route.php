<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Route where ID = ".$_GET['id'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<!-- 
ID int(11) AI PK 
RName char(7) 
Distance float 
APCode char(3) 
-->

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Route ID</b></dt>
                                <dd><?php echo ucwords($ID) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Route Name</b></dt>
                                <dd><?php echo ucwords($RName) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Distance</b></dt>
                                <dd><?php echo ucwords($Distance) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Airport Code</b></dt>
                                <dd><?php echo ucwords($APCode) ?></dd>
                            </dl>
                            <?php 
                                $totalFlight = $conn->query("SELECT COUNT(*) as total FROM Flight WHERE RID = ".$_GET['id'])->fetch_assoc();
                            ?>
                            <dl>
                                <dt><b class="border-bottom border-primary">Total Flights</b></dt>
                                <dd><?php echo $totalFlight['total']; ?></dd>
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
                    <span><b>Flight On This Route:</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <colgroup>
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
                            </colgroup>
                            <thead>
                                <th>Flight ID</th>
                                <th>Route ID</th>
                                <th>Status</th>
                                <th>Traffic Controller SSN</th>
                                <th>AAT</th>
                                <th>EAT</th>
                                <th>ADT</th>
                                <th>EDT</th>
                                <th>Base Price</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select employees from Airport_Includes_Employee table for the specified APCode
                                $flights = $conn->query("
                                    SELECT *
                                    FROM Flight
                                    WHERE RID = '".$_GET['id']."'
                                ");

                                $i++;
                                while ($row = $flights->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightID'] ?></td>
                                    <td class=""><?php echo $row['RID'] ?></td>
                                    <td class=""><?php echo $row['Status'] ?></td>
                                    <td class=""><?php echo $row['TCSSN'] ?></td>
                                    <td class=""><?php echo $row['AAT'] ?></td>
                                    <td class=""><?php echo $row['EAT'] ?></td>
                                    <td class=""><?php echo $row['ADT'] ?></td>
                                    <td class=""><?php echo $row['EDT'] ?></td>
                                    <td class=""><?php echo $row['BasePrice'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>

                                        <div class="dropdown-menu" style="">
                                            <?php if($_SESSION['login_type'] != 3): ?>
                                            <a class="dropdown-item view_flight"
                                                href="./index.php?page=view_flight&id=<?php echo $row['FlightID'] ?>"
                                                data-id="<?php echo $row['FlightID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_flight&id=<?php echo $row["FlightID"]; ?>">Edit</a>
                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item delete_flight" href="javascript:void(0)"
                                                data-id="<?php echo $row['FlightID'] ?>">Delete</a>
                                            <?php endif; ?>
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
            }
            // else {
            //     alert_toast('Data failed to delete.', "error");
            //     setTimeout(function() {
            //         // location.replace('index.php?page=list_airplane')
            //         location.replace('index.php?page=view_flight&id='.$_GET['id'])
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