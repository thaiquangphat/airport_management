<?php 
include 'db_connect.php';

// Query to get top 10 passengers who spend the most on tickets
$query = "SELECT p.PID, CONCAT(p.Fname, ' ', p.Lname) as PassengerName, SUM(s.Price) as TotalSpent
          FROM Passenger p
          JOIN Ticket t ON p.PID = t.PID
          JOIN Seat s ON t.SeatNum = s.SeatNum AND t.FlightID = s.FlightID
          GROUP BY p.PID
          ORDER BY TotalSpent DESC
          LIMIT 10";

$result = mysqli_query($conn, $query);

$dataPoints = [];

while ($row = mysqli_fetch_assoc($result)) {
    $dataPoints[] = array(
        "label" => $row['PassengerName'],  // Using PassengerName as label
        "y" => $row['TotalSpent']
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
                    text: "Top 10 VIP"
                },
                axisY: {
                    title: "Total Amount Spent (in $)"
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