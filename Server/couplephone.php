<?php

if (!empty($_POST))
{
	$phoneid = $_POST["phoneid"];
	$uuid = $_POST["uuid"];
	$major = $_POST["major"];
	$minor = $_POST["minor"];

	$folderpath = dirname(__FILE__) . DIRECTORY_SEPARATOR;
	$filename = "coupleData.json";

	$config = array();

	$config['config']['coupled'] = true;
	$config['config']['settings']['phoneid'] = $phoneid;
	$config['config']['settings']['uuid'] = $uuid;
	$config['config']['settings']['major'] = $major;
	$config['config']['settings']['minor'] = $minor;

     
     $couplestatus = array();
     $couplestatus['status'] = 'success';
     if(is_writable($folderpath)) {
         file_put_contents($filename, json_encode($config));
     } else {
         $couplestatus['status'] = 'failure';
     }
     
     header('Content-Type: application/json; charset=UTF-8');
     echo json_encode($couplestatus);
     exit(0);
}
