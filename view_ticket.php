<?php include 'db_connect.php' ?>
<?php
if(isset($_GET['ticketid'])){
	$qry = $conn->query("SELECT *, CONCAT(Fname, ' ', Lname) AS PName FROM Ticket 
                        JOIN Passenger ON Ticket.PID = Passenger.PID
                        JOIN Seat ON Ticket.FlightID = Seat.FlightID AND Ticket.SeatNum = Seat.SeatNum
                        where TicketID = ".$_GET['ticketid'])->fetch_array();
    foreach($qry as $k => $v){
        $$k = $v;
    }
}
?>

<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Ticket ID</b></dt>
                                <dd><?php echo ucwords($TicketID) ?></dd>
                                <dt><b class="border-bottom border-primary">Passenger Name</b></dt>
                                <dd><?php echo ucwords($PName) ?></dd>
                                <dt><b class="border-bottom border-primary">Passport Number</b></dt>
                                <dd><?php echo ucwords($PassportNo) ?></dd>
                                <dt><b class="border-bottom border-primary">Sex</b></dt>
                                <dd><?php echo ucwords($Sex) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-6">
                            <dl>
                                <dt><b class="border-bottom border-primary">Seat Number</b></dt>
                                <dd><?php echo ucwords($SeatNum) ?></dd>
                                <dt><b class="border-bottom border-primary">Seat Status</b></dt>
                                <dd><?php echo ucwords($Status) ?></dd>
                                <dt><b class="border-bottom border-primary">Class</b></dt>
                                <dd><?php echo ucwords($Class) ?></dd>
                                <dt><b class="border-bottom border-primary">Price</b></dt>
                                <dd><?php echo ucwords($Price) ?></dd>
                            </dl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">

    </div>
</div>

<style>
</style>

<script>
$(document).ready(function() {
    $('#list').dataTable()

    $(document).on('click', '.delete_ticket', function() {
        _conf_str("Are you sure to delete this Ticket?", "delete_ticket", [$(this).attr(
            'data-id')]);
    });
})

function delete_ticket($ticketid) {
    start_load()
    $.ajax({
        url: 'ajax.php?action=delete_ticket',
        method: 'POST',
        data: {
            ticketid: $ticketid
        },
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully deleted", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            }
            // else {
            //     alert_toast('Data failed to delete.', "error");
            //     setTimeout(function() {
            //         // location.replace('index.php?page=list_airplane')
            //         location.replace('index.php?page=view_passenger&pid='.$_GET['id'])
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