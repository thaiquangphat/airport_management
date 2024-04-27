<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <div class="dropdown">
        <a href="./" class="brand-link">
            <h3 class="text-center p-0 m-0">
                <b><?php echo isset($_SESSION['login_name']) ? $_SESSION['login_name'] : ''; ?></b>
            </h3>
        </a>
    </div>
    <div class="sidebar pb-4 mb-4">
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column nav-flat" data-widget="treeview" role="menu"
                data-accordion="false">
                <li class="nav-item dropdown">
                    <a href="./" class="nav-link nav-home">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>
                            Dashboard
                        </p>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_airport nav-view_airport">
                        <i class="nav-icon fas fa-building"></i>
                        <p>
                            Airport
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_airport" class="nav-link nav-new_airport tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_airport" class="nav-link nav-list_airport tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_airline nav-view_airline">
                        <i class="nav-icon fas fa-rocket"></i>
                        <p>
                            Airline
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_airline" class="nav-link nav-new_airline tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_airline" class="nav-link nav-list_airline tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_owner">
                        <i class="nav-icon fas fa-briefcase"></i>
                        <p>
                            Owner
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_owner" class="nav-link nav-new_owner tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add Owner</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_owner" class="nav-link nav-list_owner tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_airline nav-view_model">
                        <i class="nav-icon fas fa-robot"></i>
                        <p>
                            Model
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_model" class="nav-link nav-new_model tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_model" class="nav-link nav-list_model tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_airplane nav-view_airplane">
                        <i class="nav-icon fas fa-plane"></i>
                        <p>
                            Airplane
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_airplane" class="nav-link nav-new_airplane tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_airplane" class="nav-link nav-list_airplane tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=graph_top_airplane"
                                class="nav-link nav-graph_top_airplane tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Top 10 Most Used Airplane</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="./index.php?page=list_route" class="nav-link nav-list_route">
                        <i class="fas fa-route nav-icon"></i>
                        <p>Route</p>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="./index.php?page=booking" class="nav-link nav-booking">
                        <i class="fas fa-money-bill nav-icon"></i>
                        <p>Booking</p>
                    </a>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_flight nav-view_flight">
                        <i class="nav-icon fas fa-plane-departure"></i>
                        <p>
                            Flight
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_flight" class="nav-link nav-new_flight tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_flight" class="nav-link nav-list_flight tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_employee">
                        <i class="nav-icon fas fa-users"></i>
                        <p>
                            Employee
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_employee" class="nav-link nav-new_employee tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add Employee</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=graph_employee" class="nav-link nav-graph_employee tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Graph for Employee</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=graph_annual_salary"
                                class="nav-link nav-graph_annual_salary tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Graph Annual Salary</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_employee" class="nav-link nav-list_employee tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>All</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_administrative_support"
                                class="nav-link nav-list_administrative_support tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Adminstrative Support</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_flight_employee"
                                class="nav-link nav-list_flight_employee tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Flight Employee</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_engineer" class="nav-link nav-list_engineer tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Engineer</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_traffic_controller"
                                class="nav-link nav-list_traffic_controller tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Traffic Controller</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_consultant nav-view_consultant">
                        <i class="nav-icon fas fa-user-tie"></i>
                        <p>
                            Consultant
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_consultant" class="nav-link nav-new_consultant tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_consultant" class="nav-link nav-list_consultant tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a href="#" class="nav-link nav-edit_passenger nav-view_passenger">
                        <i class="nav-icon fas fa-user-tie"></i>
                        <p>
                            Passenger
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <li class="nav-item">
                            <a href="./index.php?page=new_passenger" class="nav-link nav-new_passenger tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Add New</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=list_passenger" class="nav-link nav-list_passenger tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>List</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="./index.php?page=graph_top_passenger"
                                class="nav-link nav-graph_top_passenger tree-item">
                                <i class="fas fa-angle-right nav-icon"></i>
                                <p>Top 10 VIP</p>
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </nav>
    </div>
</aside>
<script>
$(document).ready(function() {
    var page = '<?php echo isset($_GET['page']) ? $_GET['page'] : 'home' ?>';
    var s = '<?php echo isset($_GET['s']) ? $_GET['s'] : '' ?>';
    if (s != '')
        page = page + '_' + s;
    if ($('.nav-link.nav-' + page).length > 0) {
        $('.nav-link.nav-' + page).addClass('active')
        if ($('.nav-link.nav-' + page).hasClass('tree-item') == true) {
            $('.nav-link.nav-' + page).closest('.nav-treeview').siblings('a').addClass('active')
            $('.nav-link.nav-' + page).closest('.nav-treeview').parent().addClass('menu-open')
        }
        if ($('.nav-link.nav-' + page).hasClass('nav-is-tree') == true) {
            $('.nav-link.nav-' + page).parent().addClass('menu-open')
        }
    }
})
</script>