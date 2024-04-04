<?php include "db_connect.php"; ?>
<?php
$twhere = "";
if ($_SESSION["login_type"] != 1) {
    $twhere = "  ";
}
?>
<!-- Info boxes -->
<div class="col-12">
    <div class="card">
        <div class="card-body">
            Welcome <?php echo $_SESSION["login_name"]; ?>!
        </div>
    </div>
</div>
<hr>
<?php
    $where = "";
    if ($_SESSION["login_type"] == 2) {
        $where = " where manager_id = '{$_SESSION["login_id"]}' ";
    } elseif ($_SESSION["login_type"] == 3) {
        $where = " where concat('[',REPLACE(user_ids,',','],['),']') LIKE '%[{$_SESSION["login_id"]}]%' ";
    }
    $where2 = "";
    if ($_SESSION["login_type"] == 2) {
        $where2 = " where p.manager_id = '{$_SESSION["login_id"]}' ";
    } elseif ($_SESSION["login_type"] == 3) {
        $where2 = " where concat('[',REPLACE(p.user_ids,',','],['),']') LIKE '%[{$_SESSION["login_id"]}]%' ";
    }
?>

<div class="row">
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_airport">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_airport.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Airport")->num_rows; ?>
                            </h3>

                            <p>Total Airport</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-building" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_airline">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_airline.png'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Airline")->num_rows; ?>
                            </h3>

                            <p>Total Airline</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-rocket" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_owner">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_owner.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Owner")->num_rows; ?>
                            </h3>

                            <p>Total Owner</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-briefcase" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_airplane">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_airplane.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Airplane")->num_rows; ?>
                            </h3>

                            <p>Total Airplane</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-plane" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_route">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_route.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Route")->num_rows; ?>
                            </h3>

                            <p>Total Route</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-route" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_flight">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_flight.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Flight")->num_rows; ?>
                            </h3>

                            <p>Total Flight</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-plane-departure" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_employee">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_employee.png'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Employee")->num_rows; ?>
                            </h3>

                            <p>Total Employee</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-users" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>

        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_consultant">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_consultant.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Consultant")->num_rows; ?>
                            </h3>

                            <p>Total Consultant</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-user-tie" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="row">
            <div class="col-12 col-sm-6 col-md-12">
                <a href="index.php?page=list_passenger">
                    <div class="small-box bg-info shadow-sm border"
                        style="background-image: url('./img/total_passenger.jpg'); background-size: cover; background-position: center; position: relative;">
                        <div class="inner">
                            <h3>
                                <?php echo $conn->query("SELECT * FROM Passenger")->num_rows; ?>
                            </h3>

                            <p>Total Passenger</p>
                        </div>
                        <div class="icon">
                            <i class="fa fa-calendar-check" style="color: #ffffff"></i>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

</div>