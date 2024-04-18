<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Airport where APCode = '".$_GET['id']."'")->fetch_array();
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
                                <dt><b class="border-bottom border-primary">Airport Name</b></dt>
                                <dd><?php echo ucwords($APName) ?></dd>
                                <dt><b class="border-bottom border-primary">Airport Code</b></dt>
                                <dd><?php echo ucwords($APCode) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">City</b></dt>
                                <dd><?php echo ucwords($City) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Latitude</b></dt>
                                <dd><?php echo ucwords($Latitude) ?></dd>
                            </dl>
                            <dl>
                                <dt><b class="border-bottom border-primary">Longitude</b></dt>
                                <dd><?php echo ucwords($Longitude) ?></dd>
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
                    <div><small>A Flight on the Route which has this Airport as Source or Destination</small></div>
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
                                <col width="25%">
                                <col width="10%">
                                <col width="15%">
                                <col width="15%">
                                <col width="15%">
                                <col width="10%">
                            </colgroup> -->
                            <thead>
                                <th>Flight ID</th>
                                <th>Route ID</th>
                                <th>Route Name</th>
                                <th>Status</th>
                                <th>Traffic Controller</th>
                                <th>EAT</th>
                                <th>EDT</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                // $tasks = $conn->query("SELECT * FROM task_list where project_id = {$id} order by task asc");
                                // Airport_Contains_Airplane 
                                $flights = $conn->query("SELECT * FROM Flight JOIN Route ON Flight.RID = Route.ID where APCode = '".$_GET['id']."'");

                                // Airport_Includes_Employee
                                // $employees = $conn->query("SELECT * FROM Airport_Includes_Employee JOIN Employee ON Airport_Includes_Employee.SSN = Employee.SSN  where APCode = {$apcode}");
                                $i++;
                                while($row=$flights->fetch_assoc()):
                                    // $trans = get_html_translation_table(HTML_ENTITIES,ENT_QUOTES);
                                    // unset($trans["\""], $trans["<"], $trans[">"], $trans["<h2"]);
                                    // $desc = strtr(html_entity_decode($row['description']),$trans);
                                    // $desc=str_replace(array("<li>","</li>"), array("",", "), $desc);
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['FlightID'] ?></td>
                                    <td class=""><?php echo $row['RID'] ?></td>
                                    <td class=""><?php echo $row['RName'] ?></td>
                                    <td class="">
                                        <p class="truncate"><?php echo strip_tags($row['Status']) ?></p>
                                    </td>
                                    <td class=""><?php echo $row['TCSSN'] ?></td>
                                    <td>
                                        <p><?php echo date("F d, Y",strtotime($row['EAT'])) ?></p>
                                    </td>
                                    <td>
                                        <p><?php echo date("F d, Y",strtotime($row['EDT'])) ?></p>
                                    </td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_airplane"
                                                href="./index.php?page=view_flight&id=<?php echo $row['FlightID'] ?>"
                                                data-id="<?php echo $row['FlightID'] ?>">View</a>

                                            <div class="dropdown-divider"></div>
                                            <a class="dropdown-item"
                                                href="./index.php?page=edit_flight&flighid=<?php echo $row["FlightID"]; ?>">Edit</a>
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
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <span><b>Consultant List</b></span>
                    <div><small>A Consultant is an expert of a Model at this Airport</small></div>
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
                                <col width="30%">
                                <col width="30%">
                                <col width="20%">
                                <col width="20%">
                            </colgroup> -->
                            <!-- CREATE TABLE Expert_At
                            (
                                ConsultID INT,
                                APCode    CHAR(3),
                                ModelID   INT,
                                PRIMARY KEY (ConsultID, APCode, ModelID),
                                FOREIGN KEY (ConsultID) REFERENCES Consultant (ID) ON DELETE CASCADE ON UPDATE CASCADE,
                                FOREIGN KEY (APCode) REFERENCES Airport (APCode) ON DELETE CASCADE ON UPDATE CASCADE,
                                FOREIGN KEY (ModelID) REFERENCES Model (ID) ON DELETE CASCADE ON UPDATE CASCADE
                            ); 
                            CREATE TABLE Consultant
                            (
                                ID INT AUTO_INCREMENT,
                                Name    VARCHAR(50),
                                PRIMARY KEY (ID)
                            );
                            -->
                            <thead>
                                <th>Consultant ID</th>
                                <th>Consultant Name</th>
                                <th>Model ID</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select consultants who are experts on the specific model
                                $consultants_query = $conn->query("
                                    SELECT *
                                    FROM Expert_At
                                    JOIN Consultant ON Expert_At.ConsultID = Consultant.ID
                                    WHERE Expert_At.APCode = '".$_GET['id']."'
                                ");

                                while ($row = $consultants_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ConsultID'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['ModelID'] ?></td>
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