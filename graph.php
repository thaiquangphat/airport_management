<?php 
    include 'db_connect.php';
    $dataPoints = array(
        array("label"=> "Education", "y"=> 284935),
        array("label"=> "Entertainment", "y"=> 256548),
        array("label"=> "Lifestyle", "y"=> 245214),
        array("label"=> "Business", "y"=> 233464),
        array("label"=> "Music & Audio", "y"=> 200285),
        array("label"=> "Personalization", "y"=> 194422),
        array("label"=> "Tools", "y"=> 180337),
        array("label"=> "Books & Reference", "y"=> 172340),
        array("label"=> "Travel & Local", "y"=> 118187),
        array("label"=> "Puzzle", "y"=> 107530)
    );
?>

<div class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">
    <div class="wrapper">
        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <!-- <div id="chartContainer" style="height: 370px; width: 100%;"></div> -->
                <div id="chartContainer" style=""></div>
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
                    text: "Top 10 Google Play Categories - till 2017"
                },
                axisY: {
                    title: "Number of Apps"
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