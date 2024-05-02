<?php include 'db_connect.php' ?>
<?php
$qry = $conn->query("SELECT * FROM Flight JOIN Route ON Flight.RID = Route.ID")->fetch_array();
foreach($qry as $k => $v){
    $$k = $v;
}
?>
<div>
    <div id="booking" class="section">
        <div class="section-center">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <div class="booking-cta">
                            <h1>Book your flight today</h1>
                            <p>This is PhuPaulKhoi Airport. Enjoy booking your flight.
                            </p>
                        </div>
                    </div>
                    <div class="col-md-7 col-md-offset-1">
                        <div class="booking-form">
                            <form>
                                <!-- <div class="form-group">
                                    <div class="form-checkbox">
                                        <label for="baseflight">
                                            <input type="radio" id="baseflight" name="flight-type">
                                            <span></span>Base Flight
                                        </label>
                                        <label for="returningflight">
                                            <input type="radio" id="returningflight" name="flight-type">
                                            <span></span>Returning Flight
                                        </label>
                                    </div>
                                </div> -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="" class="control-label">Flying from</label>
                                            <select id="departureAirport" class="form-control form-control-sm select2"
                                                name="DepartureAirportID" required>
                                                <option></option>
                                                <?php 
                                                    $airports = $conn->query("SELECT * FROM Airport ORDER BY APCode ASC");
                                                    while($row = $airports->fetch_assoc()):
                                                ?>
                                                <option value="<?php echo $row['APCode']; ?>"
                                                    <?php echo isset($DepartureAirportID) && $DepartureAirportID == $row['APCode'] ? "selected" : '' ?>>
                                                    <?php echo ucwords($row['APCode'] . ' - ' . $row['APName']); ?>
                                                </option>
                                                <?php endwhile; ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="" class="control-label">Flying to</label>
                                            <select id="destinationAirport" class="form-control form-control-sm select2"
                                                name="DestinationAirportID" required>
                                                <option></option>
                                                <?php 
                                                    $airports = $conn->query("SELECT * FROM Airport ORDER BY APCode ASC");
                                                    while($row = $airports->fetch_assoc()):
                                                ?>
                                                <option value="<?php echo $row['APCode']; ?>"
                                                    <?php echo isset($DestinationAirportID) && $DestinationAirportID == $row['APCode'] ? "selected" : '' ?>>
                                                    <?php echo ucwords($row['APCode'] . ' - ' . $row['APName']); ?>
                                                </option>
                                                <?php endwhile; ?>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <span class="form-label">Departing</span>
                                            <input class="form-control" type="date" name="datedaparting" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <span class="form-label">Returning</span>
                                            <input class="form-control" type="date" name="datereturning" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <span class="form-label">Number of Tickets</span>
                                            <input class="form-control" type="number" name="NumberOfTickets" min="1"
                                                max="10" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <span class="form-label">Travel class</span>
                                            <select class="form-control" name="TravelClass">
                                                <option>Economy class</option>
                                                <option>Business class</option>
                                                <option>First class</option>
                                            </select>
                                            <span class="select-arrow"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-btn">
                                    <button class="submit-btn">Show flights</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div><!-- This templates was made by Colorlib (https://colorlib.com) -->
<div id="flightList"></div>

<style>
.section {
    display: flex;
    justify-content: center;
    align-items: center;
    height: auto;
    /* Subtract the height of the navbar or other fixed elements */
}

.section .section-center {
    width: 100%;
    max-width: 1200px;
    /* Adjust this value as needed */
}

#booking {
    font-family: 'Lato', sans-serif;
    background-image: url('./img/background.jpg');
    background-size: cover;
    background-position: center;
    color: #191a1e;
}

.booking-form {
    position: relative;
    background: #fff;
    max-width: 642px;
    width: 100%;
    margin: auto;
    padding: 45px 25px 25px;
    border-radius: 4px;
    -webkit-box-shadow: 0px 0px 10px -5px rgba(0, 0, 0, 0.4);
    box-shadow: 0px 0px 10px -5px rgba(0, 0, 0, 0.4);
}

.booking-form .form-group {
    position: relative;
    margin-bottom: 20px;
}

.booking-form .form-control {
    background-color: #fff;
    height: 65px;
    padding: 0px 15px;
    padding-top: 24px;
    color: #191a1e;
    border: 2px solid #dfe5e9;
    font-size: 16px;
    font-weight: 700;
    -webkit-box-shadow: none;
    box-shadow: none;
    border-radius: 4px;
    -webkit-transition: 0.2s all;
    transition: 0.2s all;
}

.booking-form .form-control::-webkit-input-placeholder {
    color: #dfe5e9;
}

.booking-form .form-control:-ms-input-placeholder {
    color: #dfe5e9;
}

.booking-form .form-control::placeholder {
    color: #dfe5e9;
}

.booking-form .form-control:focus {
    background: #f9fafb;
}

.booking-form input[type="date"].form-control:invalid {
    color: #dfe5e9;
}

.booking-form select.form-control {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
}

.booking-form select.form-control+.select-arrow {
    position: absolute;
    right: 6px;
    bottom: 6px;
    width: 32px;
    line-height: 32px;
    height: 32px;
    text-align: center;
    pointer-events: none;
    color: #dfe5e9;
    font-size: 14px;
}

.booking-form select.form-control+.select-arrow:after {
    content: '\279C';
    display: block;
    -webkit-transform: rotate(90deg);
    transform: rotate(90deg);
}

.booking-form .form-label {
    position: absolute;
    top: 6px;
    left: 20px;
    font-weight: 700;
    text-transform: uppercase;
    line-height: 24px;
    height: 24px;
    font-size: 12px;
    color: #98c9ee;
}

.booking-form .form-checkbox input {
    position: absolute !important;
    margin-left: -9999px !important;
    visibility: hidden !important;
}

.booking-form .form-checkbox label {
    position: relative;
    padding-top: 4px;
    padding-left: 30px;
    font-weight: 700;
    color: #191a1e;
}

.booking-form .form-checkbox label+label {
    margin-left: 15px;
}

.booking-form .form-checkbox input+span {
    position: absolute;
    left: 2px;
    top: 4px;
    width: 20px;
    height: 20px;
    background: #fff;
    border: 2px solid #dfe5e9;
    border-radius: 50%;
}

.booking-form .form-checkbox input+span:after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0px;
    height: 0px;
    border-radius: 50%;
    background-color: #4fa3e3;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
    -webkit-transition: 0.2s all;
    transition: 0.2s all;
}

.booking-form .form-checkbox input:not(:checked)+span:after {
    opacity: 0;
}

.booking-form .form-checkbox input:checked+span:after {
    opacity: 1;
    width: 10px;
    height: 10px;
}

.booking-form .submit-btn {
    color: #fff;
    background-color: #4fa3e3;
    font-weight: 400;
    height: 65px;
    font-size: 18px;
    border: none;
    width: 100%;
    border-radius: 4px;
    text-transform: uppercase
}

.booking-cta {
    margin-top: 45px;
}

.booking-cta h1 {
    font-size: 52px;
    text-transform: uppercase;
    color: #4fa3e3;
    font-weight: 400;
}

.booking-cta p {
    font-size: 22px;
    color: #191a1e;
}
</style>

<script>
function fetchFlights() {
    var departureAirport = document.getElementById("departureAirport").value;
    var destinationAirport = document.getElementById("destinationAirport").value;
    var datedaparting = document.querySelector("input[name='datedaparting']").value;
    var datereturning = document.querySelector("input[name='datereturning']").value;

    $.ajax({
        url: 'fetch_flights.php', // Ensure this path is correct
        method: 'POST',
        data: {
            departureAirport: departureAirport,
            destinationAirport: destinationAirport,
            datedaparting: datedaparting,
            datereturning: datereturning
        },
        success: function(response) {
            $('#flightList').html(response); // Update the flightList div with the fetched flights
        },
        error: function(error) {
            console.log(error);
        }
    });
}

document.addEventListener("DOMContentLoaded", function() {
    // Add event listeners to handle radio button changes
    // document.getElementById("baseflight").addEventListener("change", updateFlightType);
    // document.getElementById("returningflight").addEventListener("change", updateFlightType);

    // function updateFlightType() {
    //     var departureAirport = document.getElementById("departureAirport");
    //     var destinationAirport = document.getElementById("destinationAirport");

    //     if (document.getElementById("baseflight").checked) {
    //         // For Base Flight
    //         departureAirport.value = "ADE";
    //         departureAirport.setAttribute("disabled", true);
    //         destinationAirport.removeAttribute("disabled");
    //         destinationAirport.value = '';
    //     } else {
    //         // For Returning Flight
    //         destinationAirport.value = "ARW";
    //         destinationAirport.setAttribute("disabled", true);
    //         departureAirport.removeAttribute("disabled");
    //         departureAirport.value = '';
    //     }
    // }

    // // Trigger the function to set initial values
    // updateFlightType();

    // Handle form submission
    document.querySelector(".submit-btn").addEventListener("click", function(e) {
        e.preventDefault(); // Prevent default form submission
        fetchFlights(); // Fetch and display flights
    });

});
</script>