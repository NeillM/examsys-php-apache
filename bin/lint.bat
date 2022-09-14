@echo off
SET dir=%~dp0
SET dockerfile=%dir:~0,-4%Dockerfile
docker run --rm -i hadolint/hadolint < "%dockerfile%"
