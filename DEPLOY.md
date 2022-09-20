# examsys-php-apache: How to deploy to DockerHub

The images are stored in the [uonlearningtech/examsys-php-apache](https://hub.docker.com/r/uonlearningtech/examsys-php-apache) repository on DockerHub

To be able to deploy you must be a collaborator on the repository on your main Docker account.

## Linting

To test the syntax of the Docker file in this project you may use the following command:

```bash
./bin/lint
```

## Build for local testing

This will build the image so that you can start it for local testing.

It will have a tag that matches your branch name that can be used in the [rogo-docker](https://bitbucket.org/rogoOOS/rogo-docker) as the PHP version number

```bash
./bin/build
```

## Deploy to DockerHub

When deploying to docker hub the name of the branch will be used to determine the tag that will be used.

It will normally be used exactly except for develop which will be changed to latest.

**You should only deploy code to docker hub that has been fully code reviewed and passes all the automatic tests.**

```bash
./bin/deploy
```
