<?php
echo "hi there, how are you?";
$servername = "localhost";
$username = "";
$password = "";

echo "after var definition";

// Create connection
$conn = new mysqli($servername, $username, $password);

echo "after conn";

// Check connection
if ($conn->connect_error) {
	die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully";
?>



