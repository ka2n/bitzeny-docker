FROM alpine:3.6 AS builder

RUN apk add --update build-base jansson-dev curl-dev autoconf automake
RUN mkdir -p /work /output && cd /work
ADD ./cpuminer /work/cpuminer
RUN cd /work/cpuminer && ./autogen.sh && ./configure CFLAGS="-O3 -march=native -funroll-loops -fomit-frame-pointer" && make && cp ./minerd /output

FROM alpine:3.6
RUN apk add --no-cache jansson curl
COPY --from=builder /output/minerd /usr/bin/minerd
ENTRYPOINT ["/usr/bin/minerd"]
