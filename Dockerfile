FROM golang:1.19.12
LABEL maintainer="Nedster1980"

# Define environment variables
ARG TERRAFORM_VERSION="1.1.9"
ARG TERRAFORM_OS_ARCH="linux_amd64"
ARG UID=1000
ARG GID=1000
ARG USER=tqterratest
ARG GROUP=tqterratest
ARG TERRATEST_HOME=/tqterratest

ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV TERRAFORM_OS_ARCH=${TERRAFORM_OS_ARCH}




# Update & Install tool
RUN apt-get update && apt-get install -y curl unzip openssh-client

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
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig

RUN mkdir -p ${TERRATEST_HOME} \
    && chown -R ${UID}:${GID} $TERRATEST_HOME \
    && groupadd -g ${GID} ${GROUP} \
    && useradd -d "$TERRATEST_HOME" -u ${UID} -g ${GID} -m -s /bin/bash ${USER}

USER ${USER}

WORKDIR $GOPATH/src/app/test/
