<?php 
include 'db_connect.php';

// Query to get top 10 most used airplanes
$query = "SELECT * FROM top_ten_airplane";

$result = mysqli_query($conn, $query);

$dataPoints = [];

while ($row = mysqli_fetch_assoc($result)) {
    $dataPoints[] = array(
        "label" => $row['AirplaneID'],  // Using AirplaneID as label
        "y" => $row['NumberOfFlights']
    );
}
?>

<div class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">
    <div class="wrapper">
        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div id="chartContainer" style="height: 370px; width: 100%;"></div>
            </div>
            <!--/. container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <script>
    window.onload = function() {
        if (document.getElementById("chartContainer")) {
            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: true,
                theme: "light2",
                title: {
                    text: "Top 10 Most Used Airplanes"
                },
                axisY: {
                    title: "Number of Flights"
                },
                axisX: {
                    title: "Airplane ID"
                },
                data: [{
                    type: "column",
                    dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
                }]
            });
            chart.render();
        } else {
            console.error("chartContainer not found");
        }
    }
    </script>
    <script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>

</div>