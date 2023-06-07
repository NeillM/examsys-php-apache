# examsys-php-apache: A development webserver for ExamSys

A PHP environment configured for ExamSys development.

## Versions

| PHP Version | Tags |
|-------------|------|
| PHP 8.0     | 8.0  |
| PHP 7.4     | 7.4  |

## Example useage

The following command will expose the current working directory on port 8080:

docker run --name web0 -p 8080:80  -v $PWD:/var/www/html uonlearningtech/examsys-php-apache:7.4

## Features

* Preconfigured php extensions required for ExamSys
* Serves wwwroot configured at /var/www/html
* Xdebug is installed and enabled
    * idekey: examsys

## Directories

We have the following directories created and configured to be owned by www-data by default:

* /rogodata
* /rogodataunit
* /rogodatabehat
* /faildump

## Also see

This container is used by:

* [examsys-docker](https://bitbucket.org/examsys/examsys-docker) a docker composer based set of tools that setup a full ExamSys development environment.
