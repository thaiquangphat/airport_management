<?php
include 'db_connect.php';

$departureAirport = $conn->real_escape_string($_POST['departureAirport']);
$destinationAirport = $conn->real_escape_string($_POST['destinationAirport']);
$datedaparting = $_POST['datedaparting'];
$datereturning = $_POST['datereturning'];

// Convert dates to MySQL format
$datedaparting = date("Y-m-d", strtotime($datedaparting));
$datereturning = date("Y-m-d", strtotime($datereturning));

// Prepare and bind parameters for the query
$stmt = $conn->prepare("SELECT Flight.FlightID, Flight.Status, Flight.FlightCode, Flight.EAT, Flight.EDT
                       FROM Flight 
                       JOIN Route ON Flight.RID = Route.ID 
                       WHERE RName = CONCAT(?, '-', ?) 
                       AND Flight.Status = 'Unassigned'
                       AND DATE(EAT) BETWEEN ? AND ? 
                       AND DATE(EDT) BETWEEN ? AND ?");
$stmt->bind_param("ssssss", $departureAirport, $destinationAirport, $datedaparting, $datereturning, $datedaparting, $datereturning);
$stmt->execute();
$result = $stmt->get_result();

$html = '<div class="card card-outline card-success">
        <table class="table table-hover table-bordered" id="list">
            <thead>
                <tr>
                    <th>Flight ID</th>
                    <th>Status</th>
                    <th>Flight Code</th>
                    <th>Expected Arrive Time</th>
                    <th>Expected Depart Time</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>';

while($row = $result->fetch_assoc()):
    $html .= '<tr>
                <td>'.$row['FlightID'].'</td>
                <td>'.$row['Status'].'</td>
                <td>'.$row['FlightCode'].'</td>
                <td>'.$row['EAT'].'</td>
                <td>'.$row['EDT'].'</td>
                <td class="text-center">
                    <button type="button" class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle" data-toggle="dropdown" aria-expanded="true">Action</button>
                    <div class="dropdown-menu" style="">
                        <a class="dropdown-item view_flight" href="./index.php?page=view_flight&id='.$row['FlightID'].'" data-id="'.$row['FlightID'].'">View</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="./index.php?page=edit_flight&flightid='.$row["FlightID"].'">Edit</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="./index.php?page=book_flight&flightid='.$row['FlightID'].'">Booking</a>
                    </div>
                </td>
            </tr>';
endwhile;

$html .= '</tbody></table></div>';

echo $html;

$stmt->close();
$conn->close();
?>

<script>
$(document).ready(function() {
    $('#list').dataTable()
    $(document).on('click', '.view_flight', function() {
        window.location.href = "view_flight.php?id=" + $(this).attr('data-apcode');
    });

    $(document).on('click', '.edit_flight', function() {
        window.location.href = "edit_flight.php?id=" + $(this).attr('data-apcode');
    });

    $(document).on('click', '.book_flight', function() {
        window.location.href = "book_flight.php?flightid=" + $(this).attr('data-apcode');
    });

    $(document).on('click', '.delete_airport', function() {
        _conf_str("Are you sure to delete this Airport?", "delete_airport", [$(this).attr(
            'data-apcode')]);
    });
})

function delete_airport($apcode) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_airport',
        method: 'POST',
        data: {
            apcode: $apcode
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            }
            // else {
            //     alert_toast('Data failed to delete.', "fail");
            //     setTimeout(function() {
            //         location.replace('index.php?page=list_airport')
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