<?php

if (!is_dir(dirname(__DIR__).'/vendor')) {
    throw new LogicException('Dependencies are missing. Try running "composer install".');
}

if (!is_file(dirname(__DIR__).'/vendor/autoload.php')) {
    throw new LogicException('Autoload are missing. Try running "composer dump-autoload".');
}

require_once dirname(__DIR__).'/vendor/autoload.php';

echo 'Hello from PHP (version: ' . PHP_VERSION . ')';
