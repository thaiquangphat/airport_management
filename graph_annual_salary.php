<?php 
include 'db_connect.php';

// Query to get salary data for each employee type
$query_pilot = "SELECT Salary FROM Pilot JOIN Employee ON Pilot.SSN = Employee.SSN";
$query_flight_attendant = "SELECT Salary FROM Flight_Attendant JOIN Employee ON Flight_Attendant.SSN = Employee.SSN";
$query_engineer = "SELECT Salary FROM Engineer JOIN Employee ON Engineer.SSN = Employee.SSN";
$query_traffic_controller = "SELECT Salary FROM Traffic_Controller JOIN Employee ON Employee.SSN = Traffic_Controller.SSN";
$query_administrative_support = "SELECT Salary FROM Administrative_Support JOIN Employee ON Employee.SSN = Administrative_Support.SSN";

$result_pilot = mysqli_query($conn, $query_pilot);
$result_flight_attendant = mysqli_query($conn, $query_flight_attendant);
$result_engineer = mysqli_query($conn, $query_engineer);
$result_traffic_controller = mysqli_query($conn, $query_traffic_controller);
$result_administrative_support = mysqli_query($conn, $query_administrative_support);

$dataPoints = [];

// Function to fetch data and append to $dataPoints
function fetchData($result, $label) {
    global $dataPoints; // Access global $dataPoints array
    $salaries = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $salaries[] = $row['Salary'];
    }

    // Sort salaries to calculate quartiles
    sort($salaries);
    
    $count = count($salaries);
    $min = $salaries[0];
    $max = $salaries[$count - 1];
    $q1 = $salaries[floor($count * 0.25)];
    $median = $salaries[floor($count * 0.5)];
    $q3 = $salaries[floor($count * 0.75)];

    $dataPoints[] = [
        "label" => $label,
        "y" => [$min, $q1, $q3, $max, $median]
    ];
}

fetchData($result_pilot, "Pilot");
fetchData($result_flight_attendant, "Flight Attendant");
fetchData($result_engineer, "Engineer");
fetchData($result_traffic_controller, "Traffic Controller");
fetchData($result_administrative_support, "Administrative Support");

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
                <div id="chartContainer" style="height: 370px; width: 100%;"></div>
            </div>
            <!--/. container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <script>
    window.onload = function() {

        var chart = new CanvasJS.Chart("chartContainer", {
            animationEnabled: true,
            title: {
                text: "Annual Salary Range by Employee Type"
            },
            axisY: {
                title: "Annual Salary (in USD)",
                prefix: "$",
                interval: 10000,
                labelFormatter: addSymbols
            },
            data: [{
                type: "boxAndWhisker",
                yValueFormatString: "$#,##0",
                dataPoints: <?php echo json_encode($dataPoints, JSON_NUMERIC_CHECK); ?>
            }]
        });
        chart.render();

        function addSymbols(e) {
            var suffixes = ["", "K", "M", "B"];

            var order = Math.max(Math.floor(Math.log(Math.abs(e.value)) / Math.log(1000)), 0);
            if (order > suffixes.length - 1)
                order = suffixes.length - 1;

            var suffix = suffixes[order];
            return CanvasJS.formatNumber(e.value / Math.pow(1000, order)) + suffix;
        }

    }
    </script>
    <script src="https://cdn.canvasjs.com/canvasjs.min.js"></script>

</div>