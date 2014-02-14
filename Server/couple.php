<?php

 if (!empty($_POST))
{
	$phoneid = $_POST["submit"];
	$uuid = $_POST["uuid"];
	$major = $_POST["major"];
	$minor = $_POST["minor"];

	$folderpath = dirname(__FILE__) . DIRECTORY_SEPARATOR;
	$filename = "coupleData.json";

	$config = new array();

	$config['config']['coupled'] = true;
	$config['config']['settings']['phoneid'] = $phoneid;
	$config['config']['settings']['uuid'] = $uuid;
	$config['config']['settings']['major'] = $major;
	$config['config']['settings']['minor'] = $minor;

	if(is_writable($folderpath)) {
		file_put_contents($filename, json_encode($config));
	}

}

?>