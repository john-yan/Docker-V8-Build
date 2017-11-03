FROM ubuntu:16.04

COPY install-deps.sh /install-deps.sh

RUN /install-deps.sh

# buildtools has to be ahead of depot_tools.
ENV PATH=$PATH:/buildtools:/depot_tools

WORKDIR /workdir

COPY ./src/* /srcdir/
COPY ./build /workdir/build

