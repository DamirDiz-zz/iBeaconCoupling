<?php

$folderpath = dirname(__FILE__) . DIRECTORY_SEPARATOR;
$filename = "coupleData.json";


$config = new array();

$config['config']['coupled'] = false;
$config['config']['settings']['phoneid'] = "";
$config['config']['settings']['uuid'] = "";
$config['config']['settings']['major'] = "";
$config['config']['settings']['minor'] = "";

if(is_writable($folderpath)) {
	file_put_contents($filename, json_encode($config));
}

?>