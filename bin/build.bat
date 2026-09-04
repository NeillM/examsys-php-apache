@echo off
SET dir=%~dp0
SET dockerfile=%dir:~0,-4%Dockerfile
@SET branch=
FOR /F %%I IN ('git branch --show-current') DO @SET "branch=%%I"

if "%branch%" == "develop" SET branch=latest

SET tag=examsys-php-apache:%branch%
SET repo=uonlearningtech/%tag%

echo Building %repo%
docker build . --file "%dockerfile%" --tag "%repo%"
echo Finished building %repo%

SET tag=examsys-php-apache:%branch%-nodebug
SET repo=uonlearningtech/%tag%

echo Building %repo%
docker build --build-arg PHP_CONF=rogo-nodebug.ini . --file "%dockerfile%" --tag "%repo%"
echo Finished building %repo%
