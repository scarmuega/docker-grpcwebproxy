FROM golang:alpine AS builder

RUN apk --no-cache add git curl

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    mkdir -p $GOPATH/src/github.com/improbable-eng/grpc-web && \
    cd $GOPATH/src/github.com/improbable-eng && \
    git clone https://github.com/improbable-eng/grpc-web && \
    cd grpc-web && \
    dep ensure

RUN go get -u github.com/improbable-eng/grpc-web/go/grpcwebproxy

FROM alpine

RUN apk --no-cache add ca-certificates

WORKDIR /

COPY --from=builder /go/bin/grpcwebproxy /usr/bin/grpcwebproxy

RUN chmod +x /usr/bin/grpcwebproxy

EXPOSE 8080 8443

ENTRYPOINT ["grpcwebproxy"]