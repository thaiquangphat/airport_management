<?php
include 'db_connect.php';

$flightID = $_GET['flightid'];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $numberOfTickets = $_POST['NumberOfTickets'];
    // Here, you can add the code to save the booking details to the database
    
    // Redirect to another page or display a confirmation message
}

// Fetch flight details
$stmt = $conn->prepare("SELECT * FROM Flight WHERE FlightID = ?");
$stmt->bind_param("i", $flightID);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();

// Fetch available seats
$stmtSeats = $conn->prepare("SELECT * FROM Seat WHERE FlightID = ? AND Status = 'Available'");
$stmtSeats->bind_param("i", $flightID);
$stmtSeats->execute();
$resultSeats = $stmtSeats->get_result();
$availableSeats = $resultSeats->fetch_all(MYSQLI_ASSOC);
?>

<form method="post">
    <h2>Booking for Flight <?php echo $row['FlightCode']; ?></h2>

    <div class="form-group">
        <label for="NumberOfTickets">Number of Tickets:</label>
        <input type="number" class="form-control" id="NumberOfTickets" name="NumberOfTickets" min="1" max="10" required>
    </div>

    <div class="form-group">
        <label for="SeatSelection">Select a Seat:</label>
        <select class="form-control" id="SeatSelection" name="SeatSelection" required>
            <option value="">Select a seat</option>
            <?php foreach ($availableSeats as $seat) : ?>
            <option value="">
                <?php echo $seat['SeatNum']; ?> - <?php echo $seat['Class']; ?>
            </option>
            <?php endforeach; ?>
        </select>
    </div>

    <button type="submit" class="btn btn-primary">Book</button>
</form>