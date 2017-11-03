#!/bin/bash -x

export VPYTHON_BYPASS="manually managed python not supported by chrome operations"
BUILD_ARCHES=
MACHINE=$(uname -m)
V8="v8"
BUILD=/workdir/build 
NPROC=$(nproc)

build_and_test() {
  BUILD_DIR=$1
  script -c "gn gen $BUILD_DIR && ninja -C $BUILD_DIR all &&
             tools/run-tests.py -j $NPROC --progress=dots --timeout=120 --no-presubmit --junitout /result/v8tests-$arch-junit.xml --outdir=$BUILD_DIR --exhaustive-variants" \
    /result/build-and-test-$arch.log
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

