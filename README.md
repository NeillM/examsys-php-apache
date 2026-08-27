# examsys-php-apache: A development webserver for ExamSys

A PHP environment configured for ExamSys development.

## Versions

| PHP Version | Tags | Has nodebug version |
|-------------|------|---------------------|
| PHP 8.3     | 8.3  | Yes                 |
| PHP 8.2     | 8.2  | No                  |
| PHP 8.1     | 8.1  | No                  |
| PHP 8.0     | 8.0  | No                  |
| PHP 7.4     | 7.4  | No                  |

We also now have versions of the images that do not have Xdebug enabled they have the `-nodebug` suffix,
for example `8.3-nodebug`.

## Example useage

The following command will expose the current working directory on port 8080:

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
