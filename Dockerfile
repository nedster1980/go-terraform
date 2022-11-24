FROM golang:1.14.4

# Define environment variables
ARG TERRAFORM_VERSION="0.13.6"

ENV TERRAFORM_VERSION=${TERRAFORM_VERSION}

# Update & Install tool
RUN apt-get update && apt-get install -y unzip openssh-client

# Install dep.
ENV GOPATH /go
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH


# Install Terraform
RUN curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    curl -Os https://keybase.io/hashicorp/pgp_keys.asc && \
    gpg --import pgp_keys.asc && \
    curl -Os https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    shasum -a 256 -c terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1 | grep "${TERRAFORM_VERSION}_linux_amd64.zip:\sOK" && \
    unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

# Cleanup
RUN rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    rm terraform_${TERRAFORM_VERSION}_SHA256SUMS.72D7468F.sig

RUN useradd -m tquser