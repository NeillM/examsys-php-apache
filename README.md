# examsys-php-apache: A development webserver for ExamSys

A PHP environment configured for ExamSys development.

## Versions

| PHP Version | Tags             |
|-------------|------------------|
| PHP 8.3     | 8.3, 8.3-nodebug |
| PHP 8.2     | 8.2              |
| PHP 8.1     | 8.1              |
| PHP 8.0     | 8.0              |
| PHP 7.4     | 7.4              |

By default xDebug is enabled on the images; from PHP 8.3 we have tags with the `-nodebug` suffix that
have xDebug turned off on them.

## Example usage

The following command will expose the current working directory on port 8080, running the image
generated from this branch:

```shell
docker run --name web0 -p 8080:80  -v $PWD:/var/www/html uonlearningtech/examsys-php-apache:latest
```

## Features

* Preconfigured php extensions required for ExamSys
* Serves wwwroot configured at /var/www/html
* Xdebug is installed and enabled
    * idekey: examsys
* Will automatically map command line paths to a server configured with the name examsys in PhpStorm 

## Directories

We have the following directories created and configured to be owned by www-data by default:

* /rogodata
* /rogodataunit
* /rogodatabehat
* /faildump

## Also see

This container is used by:

* [examsys-docker](https://bitbucket.org/examsys/examsys-docker) a docker composer based set of tools that setup a full ExamSys development environment.
