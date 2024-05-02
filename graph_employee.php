<?php 
include 'db_connect.php';

$query = "SELECT * FROM employee_distribution_by_type";  // Assuming Employee table contains all types

$result = mysqli_query($conn, $query);

$row = mysqli_fetch_assoc($result);

$totalCount = $row['TotalCount'];

$dataPoints = array(
    array("label" => "Pilot", "y" => ($row['PilotCount'] / $totalCount) * 100),
    array("label" => "Flight Attendant", "y" => ($row['FlightAttendantCount'] / $totalCount) * 100),
    array("label" => "Engineer", "y" => ($row['EngineerCount'] / $totalCount) * 100),
    array("label" => "Traffic Controller", "y" => ($row['TrafficControllerCount'] / $totalCount) * 100),
    array("label" => "Administrative Support", "y" => ($row['AdministrativeSupportCount'] / $totalCount) * 100)
);

?>

<style>
/* Responsive height for the chart */
@media (max-width: 768px) {
    #chartContainer {
        height: 350px;
    }
}

@media (min-width: 769px) and (max-width: 992px) {
    #chartContainer {
        height: 50px;
    }
}

@media (min-width: 993px) {
    #chartContainer {
        height: 700px;
    }
}
</style>

<div class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">
    <div class="wrapper">
        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div id="chartContainer" style="height: 500px; width: 100%;"></div>
            </div>
            <!--/. container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <script>
    window.onload = function() {
        var chart = new CanvasJS.Chart("chartContainer", {
            theme: "light2",
            animationEnabled: true,
            title: {
                text: "Employee Distribution by Type"
            },
            data: [{
                type: "pie",
                indexLabel: "{label} - {y}",
                yValueFormatString: "#,##0.##\"%\"",
                // indexLabelPlacement: "inside",
                indexLabelFontColor: "#36454F",
                indexLabelFontSize: 18,
                indexLabelFontWeight: "bolder",
                // showInLegend: true,
                // legendText: "{label}",
                toolTipContent: "{label}: {y} employees",
                dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
            }]
        });
        chart.render();
    }
    </script>
    <script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>

</div>