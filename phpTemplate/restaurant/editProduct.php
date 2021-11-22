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
		$type = $_GET['type'];
		$price = $_GET['price'];
		$detail = $_GET['detail'];
		$image = $_GET['image'];
		$status= $_GET['status'];
		
							
		$sql = "UPDATE `product` SET `name` = '$name', `type` = '$type', `price` = '$price', `detail` = '$detail', `image` = '$image', `status` = '$status' WHERE id = '$id'";

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