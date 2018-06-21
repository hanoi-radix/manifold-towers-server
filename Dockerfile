# Docker builder for golang
FROM golang:1.10.3 as golangBuilder

EXPOSE 8080
RUN useradd --user-group --create-home --shell /bin/false go
ENV GOPATH=/go
ENV HOME=$GOPATH/src/github.com/hanoi-radix/manifold-towers-server

# Install common libraries
RUN apt-get update
RUN apt-get install -f unzip

# Install golang/dep
WORKDIR /go
RUN wget https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -O /go/bin/dep
RUN chmod +x /go/bin/dep
ENV PATH="/go/bin:${PATH}"

# Copy files & install dependencies with dep
COPY . $HOME
WORKDIR $HOME
RUN dep ensure

# Build // statically compile our app with all libraries built in
RUN chown -R go:go $GOPATH/*
USER go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o $HOME/main ./cmd
RUN chmod +x $HOME/main

# Statically compile fresh for development hot reload
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/fresh ./vendor/github.com/pilu/fresh
RUN chmod +x /go/bin/fresh

# Statically compile protoc-gen-go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/protoc-gen-go ./vendor/github.com/golang/protobuf/protoc-gen-go
RUN chmod +x /go/bin/protoc-gen-go

# Download prebuild protoc binary
# https://developers.google.com/protocol-buffers/docs/gotutorial#compiling-your-protocol-buffers
RUN wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip -O /tmp/protoc.zip && \
    unzip /tmp/protoc.zip -d /tmp/protoc && \
    mv /tmp/protoc/bin/protoc /go/bin/protoc && \
    rm -rf /tmp/protoc.zip && \
    rm -rf /tmp/protoc

# Run cmd
CMD [ "./main" ]