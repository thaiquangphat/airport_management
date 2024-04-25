<!DOCTYPE html>
<html lang="en">
<?php
session_start();
include "./db_connect.php";
ob_start();
// if(!isset($_SESSION['system'])){

// $system = $conn->query("SELECT * FROM system_settings")->fetch_array();
// foreach ($system as $k => $v) {
//     $_SESSION["system"][$k] = $v;
// }
// }
ob_end_flush();
?>
<?php if (isset($_SESSION["login_id"])) {
    header("location:index.php?page=home");
} ?>
<?php include "header.php"; ?>

<style>
#intro {
    background-image: url(https://wallpaperset.com/w/full/9/5/8/217503.jpg);
    background-size: cover;
    /* Make the background image cover the entire screen */
    background-repeat: no-repeat;
    /* Prevent the background image from repeating */
    background-position: center;
    /* Center the background image */
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
            <a href="#" class="text-black"><b><?php echo "Airport Management System"; ?> - Login</b></a>
        </div>
        <!-- /.login-logo -->
        <div class="card" style="">
            <div class="card-body login-card-body" style="">
                <form action="" id="login-form">
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
                        <!-- <div class="col-12">
                            <div class="icheck-primary">
                                <input type="checkbox" id="remember">
                                <label for="remember">
                                    Remember Me
                                </label>
                            </div>
                        </div> -->
                        <!-- /.col -->
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary btn-block">Sign In</button>
                        </div>
                        <!-- /.col -->
                    </div>
                    <div class="row">
                        <!-- /.col -->
                        <!-- <div
                            style="border: 1px solid transparent; padding: .375rem .75rem; border-right: 0; display: block; width: 100%;">
                            Don't have an account?
                            <a href="register.php"> Register</button>
                        </div> -->
                        <!-- /.col -->
                    </div>
                </form>
            </div>
            <!-- /.login-card-body -->
        </div>
    </div>
    <!-- /.login-box -->
    <script>
    $(document).ready(function() {
        $('#login-form').submit(function(e) {
            e.preventDefault()
            start_load()
            if ($(this).find('.alert-danger').length > 0)
                $(this).find('.alert-danger').remove();
            $.ajax({
                url: 'ajax.php?action=login',
                method: 'POST',
                data: $(this).serialize(),
                // error: err => {
                //     console.log(err)
                //     end_load();
                // },
                success: function(resp) {
                    if (resp == 1) {
                        // location.href = 'index.php?page=home';
                        // added here
                        alert_toast(" Database connection success.", 'success');
                        setTimeout(function() {
                            location.replace('index.php?page=home')
                        }, 750)
                        // end added
                    }
                    // else {
                    //     $('#login-form').prepend(
                    //         '<div class="alert alert-danger">Username or password is incorrect.</div>'
                    //     )
                    //     end_load();
                    // }
                    else {
                        alert_toast(" Database connection failed.",
                            'warning'
                        ); // Display the error message returned from the server
                        setTimeout(function() {
                            location.reload();
                        }, 2000);
                    }
                }.bind(this) // Bind this to the AJAX context
            })
        })
    })
    </script>
    <?php include "footer.php"; ?>

</body>

</html>