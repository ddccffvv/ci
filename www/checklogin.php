
<?php
$servername = "localhost";
$username = "";
$password = "";

$name = $_POST["username"];
$pass = $_POST["password"];


// Create connection
$conn = new mysqli($servername, $username, $password, "testing");


// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
} 
$sql = "select * from users where name='" . $name . "' and password='" . $pass . "'";
$result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) == 1) {
	echo "access granted";
} else {
	echo "wrong username/password combination";
}

mysqli_close($conn);
?>
