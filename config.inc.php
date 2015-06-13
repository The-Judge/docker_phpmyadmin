<?php
$cfg['blowfish_secret'] = 'BFSECRET';
$cfg['DisplayServersList'] = true;
$cfg['AllowArbitraryServer'] = true;

/*
 Sets here the complete URL (with full path) to your phpMyAdmin installation’s directory. E.g.
 http://www.example.net/path_to_your_phpMyAdmin_directory/. Note also that the URL on most of web servers are
 case–sensitive. Don’t forget the trailing slash at the end.
*/
$cfg['PmaAbsoluteUri'] = 'PMAABSOLUTEURI';

$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
?>

