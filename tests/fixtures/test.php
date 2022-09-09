<?php
/**
 * Tests that the PHP modules required by ExamSys are present.
 *
 * @copyright  2022 University of Nottingham
 * @author     Neill Magill <neill.magill@nottingham.ac.uk>
 */

$phpmodules = [
    'curl',
    'ctype',
    'fileinfo',
    'gd',
    'intl',
    'ldap',
    'mbstring',
    'mysqli',
    'openssl',
    'pdo_mysql',
    'sockets',
    'xml',
    'xmlrpc',
    'zlib',
];

$missiing = [];
foreach ($phpmodules as $module) {
    if (!extension_loaded($module)) {
        $missing[] = $module;
    }
}

if (empty($missing)) {
    $status = 'OK';
    $httpcode = '200';
    $exitcode = 0;
} else {
    $status = 'Missing: ' . implode(', ' , $missing);
    $httpcode = '500';
    $exitcode = 1;
}

if (php_sapi_name() !== 'cli') {
    header("HTTP/1.1 $httpcode - $status");
}

echo "$status\n";
exit($exitcode);
