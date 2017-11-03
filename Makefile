
IMAGE := v8-build-env
RESULT := $(PWD)/result

ifeq ($(V), 1)
  BASH := bash -x
else
  BASH := bash
endif

build-image:
	$(BASH) $(PWD)/update-image.sh

build-and-test-v8: build-image
	mkdir -p "$(RESULT)"
	docker run --rm -v "$(RESULT):/result" $(IMAGE) $(BASH) /srcdir/build-and-test-v8.sh

run:
	mkdir -p "$(RESULT)"
	docker run -it --rm -v "$(RESULT):/result" $(IMAGE) bash || true

.PHONY: build-images build-and-test-v8 run

