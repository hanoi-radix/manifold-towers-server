# Docker builder for golang
FROM golang:1.10.3 as golangBuilder

EXPOSE 8080
RUN useradd --user-group --create-home --shell /bin/false go
ENV GOPATH=/go
ENV HOME=$GOPATH/src/app

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
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o $HOME/main .
RUN chmod +x $HOME/main

# Statically compile fresh for development hot reload
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/fresh ./vendor/github.com/pilu/fresh
RUN chmod +x /go/bin/fresh

# Run cmd
CMD [ "./main" ]
