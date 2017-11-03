
ARCH := $(shell uname -m | tr '[:upper:]' '[:lower:]')
BUILDTOOLS := $(PWD)/deps/buildtools
V8 := $(PWD)/deps/v8
IMAGE := v8-build-env
RESULT := $(PWD)/result

build-image:
	docker build -t $(IMAGE) .

download-deps: .deps-downloaded

.deps-downloaded:
	git clone https://github.com/john-yan/ibm-buildtools-for-v8.git deps/buildtools
	touch .deps-downloaded

update-deps: download-deps
	cd "$(BUILDTOOLS)" && git remote update && git reset --hard origin/master

update-image:
	bash $(PWD)/update-image.sh

build-and-test-v8: update-image
	docker run --rm -v "$(BUILDTOOLS):/buildtools" \
					-v "$(RESULT):/result" $(IMAGE) bash -x /srcdir/build-and-test-v8.sh

run:
	docker run -it --rm -v "$(BUILDTOOLS):/buildtools" \
					-v "$(RESULT):/result" $(IMAGE) bash || true

.PHONY: build-images download-deps update-deps build-and-test-v8 run update-image

