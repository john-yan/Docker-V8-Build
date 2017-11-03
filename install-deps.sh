#!/bin/bash -x


apt-get update && \
apt-get install -y python \
                   pkg-config \
                   libnss3-dev \
                   libcups2-dev \
                   git \
                   vim \
                   libglib2.0-dev \
                   libpango1.0-dev \
                   libgconf2-dev \
                   libgnome-keyring-dev \
                   libatk1.0-dev \
                   libgtk-3-dev \
                   wget

if [[ $(uname -m) == "s390x" ]] ; then
  apt-get install -y gcc-multilib g++-multilib
fi


git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /depot_tools
git clone https://github.com/john-yan/ibm-buildtools-for-v8.git /buildtools

