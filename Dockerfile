FROM ubuntu:16.04

ENV PATH=$PATH:/buildtools

COPY install-deps.sh /install-deps.sh

RUN /install-deps.sh

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /depot_tools
ENV PATH=$PATH:/depot_tools

WORKDIR /workdir

COPY ./src/* /srcdir/
COPY ./build /workdir/build

