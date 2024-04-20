<?php 
include('db_connect.php');
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
// if(isset($_GET['id'])){
//     $user = $conn->query("SELECT * FROM users where id =".$_GET['id']);
//     foreach($user->fetch_array() as $k =>$v){
//         $meta[$k] = $v;
//     }
// }
?>
<div class="container-fluid">
    <div id="msg"></div>

    <form action="" id="manage-user">
        <input type="hidden" name="id"
            value="<?php echo isset($_SESSION['login_name']) ? $_SESSION['login_name']: '' ?>">
        <div class="form-group">
            <label for="name">User Name</label>
            <input type="text" name="firstname" id="firstname" class="form-control"
                value="<?php echo isset($meta['firstname']) ? $meta['firstname']: '' ?>" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" class="form-control" value="" autocomplete="off">
            <small><i>Leave this blank if you dont want to change the password.</i></small>
        </div>


    </form>
</div>
<style>
img#cimg {
    height: 15vh;
    width: 15vh;
    object-fit: cover;
    border-radius: 100% 100%;
}
</style>
<script>
$('#manage-user').submit(function(e) {
    e.preventDefault();
    start_load()
    $.ajax({
        url: 'ajax.php?action=update_user',
        data: new FormData($(this)[0]),
        cache: false,
        contentType: false,
        processData: false,
        method: 'POST',
        type: 'POST',
        success: function(resp) {
            if (resp == 1) {
                alert_toast("Data successfully saved", 'success')
                setTimeout(function() {
                    location.reload()
                }, 1500)
            } else {
                $('#msg').html('<div class="alert alert-danger">Username already exist</div>')
                end_load()
            }
        }
    })
})
</script>