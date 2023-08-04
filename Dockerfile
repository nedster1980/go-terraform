FROM golang:1.19.10

# Define environment variables
ARG TERRAFORM_VERSION="1.1.9"
ARG TERRAFORM_OS_ARCH="linux_amd64"
ARG ARG_MODULE_NAME="terratest"

ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}
ENV TERRAFORM_OS_ARCH=${TERRAFORM_OS_ARCH}



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
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig

# Set work directory and install terratest stuff to docker image
RUN mkdir /go/src/${ARG_MODULE_NAME}
WORKDIR /go/src/${MODULE_NAME}

RUN go mod init ${MODULE_NAME}
RUN go mod tidy
go get -v -u github.com/gruntwork-io/terratest/modules/terraform@v0.41.3
go install github.com/gruntwork-io/terratest/cmd/terratest_log_parser@v0.41.3

RUN useradd -m tquser