<?php include 'db_connect.php' ?>
<?php
    if(isset($_GET['sid'])){
        // echo $_GET['sid'];
        $array = explode('-', $_GET['sid']);
        $fid = $array[0];
        $seatnum = $array[1];

        $qry = $conn->query("SELECT Seat.FlightID, Seat.SeatNum, Seat.Class, Seat.Status, Seat.Price, Ticket.TicketID, Ticket.PID, Flight.FlightCode
                             FROM Seat
                             LEFT JOIN Ticket ON Seat.FlightID = Ticket.FlightID AND Seat.SeatNum = Ticket.SeatNum
                             LEFT JOIN Flight ON Flight.FlightID = Seat.FlightID
                             WHERE Seat.FlightID = '" . $fid . "' AND Seat.SeatNum = '" . $seatnum . "'")->fetch_array();
        foreach($qry as $k => $v){
            $$k = $v;
        }

        // echo $fid;
        // echo $seatnum;
        // $qry = $conn->query("SELECT *, CONCAT(Fname, ' ', Minit, ' ', Lname) as PName FROM Passenger where PID = ".$_GET['pid'])->fetch_array();
        // foreach($qry as $k => $v){
        //     $$k = $v;
        // }
    }
?>
<div class="col-lg-12">
    <div class="row">
        <div class="col-md-12">
            <div class="callout callout-info">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-sm-4">
                            <dl>
                                <dt><b class="border-bottom border-primary">Flight ID</b></dt>
                                <dd><?php echo ucwords($FlightID) ?></dd>
                                <dt><b class="border-bottom border-primary">Flight Code</b></dt>
                                <dd><?php echo ucwords($FlightCode) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-4">
                            <dl>
                                <dt><b class="border-bottom border-primary">Seat Number</b></dt>
                                <dd><?php echo ucwords($SeatNum) ?></dd>
                                <dt><b class="border-bottom border-primary">Class</b></dt>
                                <dd><?php echo ucwords($Class) ?></dd>
                            </dl>
                        </div>
                        <div class="col-md-4">
                            <dl>
                                <dt><b class="border-bottom border-primary">Status</b></dt>
                                <dd><?php echo ucwords($Status) ?></dd>
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
        <div class="col-md-12">
            <div class="card card-outline card-primary" id="list1">
                <div class="card-header">
                    <span><b>Ticket Owns This Seat</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>Ticket ID</th>
                                <th>PID</th>
                                <th>Check In Time</th>
                                <th>Check In Status</th>
                                <th>Book Time</th>
                                <th>Cancel Time</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT Ticket.TicketID, Ticket.PID, Ticket.CheckInTime, Ticket.CheckInStatus, Ticket.BookTime, Ticket.CancelTime
                                    FROM Ticket
                                    WHERE Ticket.SeatNum = '" . $seatnum . "' AND Ticket.FlightID = '" . $fid . "'");

                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['TicketID'] ?></td>
                                    <td class=""><?php echo $row['PID'] ?></td>
                                    <td class=""><?php echo $row['CheckInTime'] ?></td>
                                    <td class=""><?php echo $row['CheckInStatus'] ?></td>
                                    <td class=""><?php echo $row['BookTime'] ?></td>
                                    <td class=""><?php echo $row['CancelTime'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <?php if($row['CancelTime'] == '1970-01-01 00:00:00' && $row['CheckInStatus'] == 'No'): ?>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item edit_ticket"
                                                href="./index.php?page=edit_ticket&tid=<?php echo $row['TicketID'] ?>"
                                                data-id="<?php echo $row['TicketID'] ?>">Edit</a>
                                        </div>
                                        <?php endif ?>
                                    </td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-primary" id="list1">
                <div class="card-header">
                    <span><b>Passenger Owns This Seat</b></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-condensed m-0 table-hover">
                            <thead>
                                <th>PID</th>
                                <th>Passport Number</th>
                                <th>Passenger Name</th>
                                <th>Date Of Birth</th>
                                <th>Nationality</th>
                                <th>Sex</th>
                                <th>Action</th>
                            </thead>
                            <tbody>
                                <?php 
                                $i = 1;
                                $feinfo = $conn->query("
                                    SELECT Passenger.PID_Decode, Passenger.PID, Passenger.PassportNo, CONCAT(Passenger.Fname, ' ', Passenger.Lname) as Name, Passenger.DOB, Passenger.Sex, Passenger.Nationality, Ticket.SeatNum
                                    FROM Ticket
                                    JOIN Passenger ON Passenger.PID = Ticket.PID 
                                    WHERE Passenger.PID = '" . $PID . "' AND Ticket.FlightID = '" .$FlightID."' AND Ticket.SeatNum = '" .$seatnum."'");
                                $i++;
                                while ($row = $feinfo->fetch_assoc()):
                                ?>
                                <tr>
                                    <td class=""><?php echo $row['PID'] ?></td>
                                    <td class=""><?php echo $row['PassportNo'] ?></td>
                                    <td class=""><?php echo $row['Name'] ?></td>
                                    <td class=""><?php echo $row['DOB'] ?></td>
                                    <td class=""><?php echo $row['Nationality'] ?></td>
                                    <td class=""><?php echo $row['Sex'] ?></td>
                                    <td class="">
                                        <button type="button"
                                            class="btn btn-default btn-sm btn-flat border-info wave-effect text-info dropdown-toggle"
                                            data-toggle="dropdown" aria-expanded="true">
                                            Action
                                        </button>
                                        <div class="dropdown-menu" style="">
                                            <a class="dropdown-item view_seat"
                                                href="./index.php?page=view_passenger&pid=<?php echo $row['PID']?>"
                                                data-id="<?php echo $row['PID'] ?>">View</a>
                                        </div>
                                    </td>
                                </tr>
                                <?php 
                                endwhile;
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
