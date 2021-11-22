<?php
	include 'connected.php';

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
		
		$id = $_GET['id'];
		$name = $_GET['name'];
		$phone = $_GET['phone'];
		$address = $_GET['address'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
		$time = $_GET['time'];
		$openclose = $_GET['openclose'];
		
							
		$sql = "UPDATE `shop` SET `name` = '$name', `phone` = '$phone', `address` = '$address', `lat` = '$lat', `lng` = '$lng', `time` = '$time', `openclose` = '$openclose' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Kittipong";
   
}

	mysqli_close($link);
?>