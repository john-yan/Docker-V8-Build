#!/bin/bash -x

echo "umask 0" >> $HOME/.bashrc
chmod +x $HOME/.bashrc
umask 0

BUILD_ARCHES=
MACHINE=$(uname -m)
V8="v8"
BUILD=/workdir/build 
NPROC=$(nproc)
FAILED=0

build_and_test() {
  BUILD_DIR=$1
  rm -f /result/$arch-*
  script -e -c "gn gen $BUILD_DIR && ninja -C $BUILD_DIR all && \
             tools/run-tests.py -j $NPROC --time --progress=dots --timeout=240 --no-presubmit \
                                --json-test-results=/result/$arch-test-result.json \
                                --junitout=/result/$arch-junit.xml \
                                --outdir=$BUILD_DIR --variants=exhaustive" \
    /result/$arch-script.log
  if [[ $? -ne 0 ]] ; then
    echo "Build and Test for $arch failed."
    FAILED=1
  fi
}

if [[ $MACHINE == "s390x" ]] ; then
  BUILD_ARCHES=("s390" "s390x")
elif [[ $MACHINE == "ppc64le" ]] ; then
  BUILD_ARCHES=("ppc64")
elif [[ $MACHINE == "x86_64" ]] ; then
  BUILD_ARCHES=("s390" "s390x" "ppc64")
else
  echo "Unsupported arch $MACHINE !!!"
  exit 1;
fi

fetch --no-history $V8
cd $V8

for arch in ${BUILD_ARCHES[@]} ; do 
  build_and_test $BUILD/$arch.release
done

if [[ $FAILED -eq 1 ]] ; then
  exit 1
fi

