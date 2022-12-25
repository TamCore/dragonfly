BUILD_ARCH := $(shell uname -m)
RELEASE_NAME := "dragonfly-${BUILD_ARCH}"

.PHONY: default

configure:
	./helio/blaze.sh -release -DBoost_USE_STATIC_LIBS=ON -DOPENSSL_USE_STATIC_LIBS=ON \
	      -DENABLE_GIT_VERSION=ON -DWITH_UNWIND=OFF -DHELIO_RELEASE_FLAGS="-flto"

build:
	cd build-opt; \
	ninja dragonfly; \
	ldd dragonfly

package:
	cd build-opt; \
	mv dragonfly $(RELEASE_NAME); \
	tar cvfz $(RELEASE_NAME).unstripped.tar.gz $(RELEASE_NAME) ../LICENSE.md; \
	strip $(RELEASE_NAME); \
	tar cvfz $(RELEASE_NAME).tar.gz $(RELEASE_NAME) ../LICENSE.md

release: configure build

default: release
