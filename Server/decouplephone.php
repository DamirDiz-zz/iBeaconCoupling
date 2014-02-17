<?php

$folderpath = dirname(__FILE__) . DIRECTORY_SEPARATOR;
$filename = "coupleData.json";

$config = array();

$config['config']['coupled'] = false;
$config['config']['settings']['phoneid'] = "";
$config['config']['settings']['uuid'] = "";
$config['config']['settings']['major'] = "";
$config['config']['settings']['minor'] = "";

$decouplestatus = array();
$decouplestatus['status'] = 'success';

if(is_writable($folderpath)) {
	file_put_contents($filename, json_encode($config));
} else {
    $decouplestatus['status'] = 'failure';
}

header('Content-Type: application/json; charset=UTF-8');
echo json_encode($decouplestatus);
exit(0);