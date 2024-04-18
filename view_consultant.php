<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['id'])){
	$qry = $conn->query("SELECT * FROM Consultant where ID = '".$_GET['id']."'")->fetch_array();
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
                                <dt><b class="border-bottom border-primary">Consultant ID</b></dt>
                                <dd><?php echo ucwords($ID) ?></dd>
                                <dt><b class="border-bottom border-primary">Consultant Name</b></dt>
                                <dd><?php echo ucwords($Name) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">No Airport Expert At</b></dt>
                                <?php 
                                    $qry2 = $conn->query("SELECT count(*) as total FROM Expert_At where ConsultID = ".$_GET['id'])->fetch_assoc();
                                    echo $qry2['total'] 
                                ?>
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
                    <span><b>Expert-Airport-Model List</b></span>
                    <div><small>This show the information of Airport and Model that this Consultant experts at.</small>
                    </div>
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
                                <th>Airport Code</th>
                                <th>Model ID</th>
                                <th>Model Name</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;

                                // Select consultants who are experts on the specific model
                                $consultants_query = $conn->query("
                                    SELECT *
                                    FROM Expert_At
                                    JOIN Consultant ON Expert_At.ConsultID = Consultant.ID
                                    JOIN Model ON Model.ID = Expert_At.ModelID
                                    JOIN Airport ON Airport.APCode = Expert_At.APCode
                                    WHERE Expert_At.ConsultID = '".$_GET['id']."'
                                ");

                                while ($row = $consultants_query->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['ConsultID'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['APCode'] ?></td>
                                    <td class=""><?php echo $row['ModelID'] ?></td>
                                    <td class=""><?php echo $row['MName'] ?></td>
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
</style>

<script>
</script>