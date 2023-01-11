FROM golang:1.18.8
LABEL maintainer="nedster1980"

# Define environment variables
ARG TERRAFORM_VERSION="1.3.5"
ARG TERRAFORM_OS_ARCH="linux_amd64"
ARG TERRATEST_LOG_PARSER_VERSION="v0.41.3"
ARG TERRATEST_VERSION="v0.41.3"
ARG uid=1000
ARG gid=1000
ARG user=tqterratest
ARG group=tqterratest
ARG terratest_home=tqterratest

ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV TERRAFORM_OS_ARCH=${TERRAFORM_OS_ARCH}
ENV TERRATEST_LOG_PARSER_VERSION=${TERRATEST_LOG_PARSER_VERSION}
ENV TERRATEST_VERSION=${TERRATEST_VERSION}

# Update & Install tool
RUN apt-get update && apt-get install -y unzip openssh-client

# Install dep.
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH

# Install Terraform
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    curl -Os https://keybase.io/hashicorp/pgp_keys.asc && \
    gpg --import pgp_keys.asc && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    shasum -a 256 -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep "${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip:\sOK" && \
    unzip -o terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip -d /usr/local/bin

# Cleanup
RUN rm terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS_ARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig && \
    rm SHA256SUMS


USER -m ${user}
WORKDIR $GOPATH/src/terratest