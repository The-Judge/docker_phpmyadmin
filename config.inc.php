<?php
$cfg['blowfish_secret'] = 'BFSECRET';
$cfg['DisplayServersList'] = true;
$cfg['AllowArbitraryServer'] = true;

$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
?>

