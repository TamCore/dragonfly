.PHONY: default

configure:
	./helio/blaze.sh -release -DBoost_USE_STATIC_LIBS=ON -DOPENSSL_USE_STATIC_LIBS=ON \
	      -DENABLE_GIT_VERSION=ON -DWITH_UNWIND=OFF -DHELIO_RELEASE_FLAGS="-flto"

build:
	cd build-opt; \
	ninja dragonfly; \
	ldd dragonfly

package:
	ARCH=`uname -m`
	NAME="dragonfly-${ARCH}"

	cd build-opt; \
	mv dragonfly $NAME; \
	tar cvfz $NAME.unstripped.tar.gz $NAME ../LICENSE.md; \
	strip $NAME; \
	tar cvfz $NAME.tar.gz $NAME ../LICENSE.md

release: configure build

default: release
