 <?php
$servername = "unity-mariadb";
$username = "root";
$password = "root";
$dbname = "course4";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM players";
$result = $conn->query($sql);

$json_array = array();

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    $json_array[] = $row;
  }
} else {
  echo "0 results";
}

echo json_encode($json_array);

$conn->close();
?> 