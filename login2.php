<!DOCTYPE html>
<html lang="en">
<?php
// include "./db_connect.php";
ob_start();
// if(!isset($_SESSION['system'])){

// $system = $conn->query("SELECT * FROM system_settings")->fetch_array();
// foreach ($system as $k => $v) {
//     $_SESSION["system"][$k] = $v;
// }
// }
ob_end_flush();
?>
<?php include "header.php"; ?>

<style>
#intro {
    background-image: url(https://www.wallpaperuse.com/wallp/73-736441_m.jpg);
    height: 100vh;
    background-size: auto 100%;
}

/* Height for devices larger than 576px */
@media (min-width: 992px) {
    #intro {
        margin-top: -58.59px;
    }
}

.navbar .nav-link {
    color: #fff !important;
}
</style>

<body id="intro" class="hold-transition login-page bg-black">
    <div class="login-box" style="background-color: rgba(255,255,255,0.8);">
        <div class="login-logo">
            <a href="#" class="text-black"><b><?php echo "Airport" ?> - Login</b></a>
        </div>
        <!-- /.login-logo -->
        <div class="card" style="">
            <div class="card-body login-card-body" style="">
                <form action="" id="login-form" method="post">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" name="user" required placeholder="Username">
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-user"></span>
                            </div>
                        </div>
                    </div>
                    <div class="input-group mb-3">
                        <input type="password" class="form-control" name="password" required placeholder="Password">
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-lock"></span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary btn-block">Sign In</button>
                        </div>
                        <!-- /.col -->
                    </div>
                </form>
            </div>
            <!-- /.login-card-body -->
        </div>
    </div>
    <!-- /.login-box -->
    <script>
    // $(document).ready(function() {
    //     $('#login-form').submit(function(e) {
    //         e.preventDefault()
    //         start_load()
    //         if ($(this).find('.alert-danger').length > 0)
    //             $(this).find('.alert-danger').remove();
    //         $.ajax({
    //             url: 'ajax.php?action=login',
    //             method: 'POST',
    //             data: $(this).serialize(),
    //             error: err => {
    //                 console.log(err)
    //                 end_load();
    //             },
    //             success: function(resp) {
    //                 if (resp == 1) {
    //                     location.href = 'index.php?page=home';
    //                 } else {
    //                     $('#login-form').prepend(
    //                         '<div class="alert alert-danger">Username or password is incorrect.</div>'
    //                     )
    //                     end_load();
    //                 }
    //             }
    //         })
    //     })
    // })
    </script>
    <?php include "footer.php"; ?>
    <?php
        if (isset($_POST['user']) && isset($_POST['password'])) {
            $_SESSION['user-db'] = $_POST['user'];
            $_SESSION['pass-db'] = $_POST['password'];

            include("db_connect.php");

            $system = $conn->query("SELECT * FROM system_settings")->fetch_array();
            foreach ($system as $k => $v) {
                $_SESSION["system"][$k] = $v;
            }
        }
    ?>

</body>

</html>