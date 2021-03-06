FROM golang:1.18.1 as builder
COPY --from=hairyhenderson/gomplate:v3.11.1-alpine /bin/gomplate /usr/local/bin/gomplate
ADD . /build
WORKDIR /build
RUN go vet ./...
RUN go test ./...
RUN go build -buildvcs=false -o build/crumblecog-plugin

FROM alpine as putter
COPY --from=builder /build/build/crumblecog-plugin .
COPY --from=builder /usr/local/bin/gomplate .
USER 999
ENTRYPOINT [ "cp", "crumblecog-plugin", "gomplate", "/custom-tools/" ]
