<?php
include 'db_connect.php';

$departureAirport = $_POST['departureAirport'];
$destinationAirport = $_POST['destinationAirport'];
$datedaparting = $_POST['datedaparting'];
$datereturning = $_POST['datereturning'];

// Convert dates to MySQL format
$datedaparting = date("Y-m-d", strtotime($datedaparting));
$datereturning = date("Y-m-d", strtotime($datereturning));

// Fetch flights based on the criteria
$qry = $conn->query("SELECT * FROM Flight 
                    JOIN Route ON Flight.RID = Route.ID 
                    WHERE RName = CONCAT('$departureAirport', '-', '$destinationAirport') 
                    AND DATE(EAT) BETWEEN '$datedaparting' AND '$datereturning' 
                    AND DATE(EDT) BETWEEN '$datedaparting' AND '$datereturning'");

$html = '<table class="table table-hover table-bordered" id="list">
            <thead>
                <tr>
                    <th>Flight ID</th>
                    <th>Status</th>
                    <th>Flight Code</th>
                    <th>Expected Arrive Time</th>
                    <th>Expected Depart Time</th>
                    <th>Revenue</th>
                    <th>No Pilot</th>
                    <th>No Flight Attendant</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>';

while($row = $qry->fetch_assoc()):
    $html .= '<tr>
                <td>'.$row['FlightID'].'</td>
                <td>'.$row['Status'].'</td>
                <td>'.$row['FlightCode'].'</td>
                <td>'.$row['EAT'].'</td>
                <td>'.$row['EDT'].'</td>
                <td>'.$row['Revenue'].'</td>
                <td>'.$row['NoPilot'].'</td>
                <td>'.$row['NoFlightAttendant'].'</td>
                <td class="text-center">
                    <button type="button" class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle" data-toggle="dropdown" aria-expanded="true">Action</button>
                    <div class="dropdown-menu" style="">
                        <a class="dropdown-item view_flight" href="./index.php?page=view_flight&id='.$row['FlightID'].'" data-id="'.$row['FlightID'].'">View</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="./index.php?page=edit_flight&flightid='.$row["FlightID"].'">Edit</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item delete_flight" href="javascript:void(0)" data-id="'.$row['FlightID'].'">Delete</a>
                    </div>
                </td>
            </tr>';
endwhile;

$html .= '</tbody></table>';

echo $html;
?>