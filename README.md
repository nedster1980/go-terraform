test# Introduction 
Base image for Terratest based on a go image which installs Terraform with all dependencies.

The image creates a non-root user called **tquser**


# Getting Started
Install Docker I would recommend that Docker is set up to take advantage of WSL 2 (see https://docs.microsoft.com/en-us/windows/wsl/install-win10)
1.	Set up WSL 2
2.	Install Ubuntu from Microsoft Store
3.	Install Docker
4.	Configure Docker to use WSL2

# Build and Test
Issue the following command to build the base image:
```
docker build . -t <IMAGE_NAME>
```

For example:
```
docker build . -t tq-go-terraform/go-terraform:0.13.6-go.1.14.4 
```

# Users
The docker image built creates the following arguments to create a tqterratest user:
ARG UID=1000
ARG GID=1000
ARG USER=tqterratest
ARG GROUP=tqterratest
ARG TERRATEST_HOME=/tqterratest

# Working Directory
The working directory of the docker image is

$GOPATH/src/app/test/


