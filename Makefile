SHELL := /bin/bash

# Dependency Versions
VERSION?=2.1.15
RELEASEVER?=1

# Bash data
SCRIPTPATH=$(shell pwd -P)
CORES=$(shell grep -c ^processor /proc/cpuinfo)
RELEASE=$(shell lsb_release --codename | cut -f2)

major=$(shell echo $(VERSION) | cut -d. -f1)
minor=$(shell echo $(VERSION) | cut -d. -f2)
micro=$(shell echo $(VERSION) | cut -d. -f3)

build: clean gnupg2

clean:
	rm -rf /tmp/gnupg-$(VERSION).tar.bz2
	rm -rf /tmp/gnupg-$(VERSION)
	rm -rf /tmp/gnupg-$(VERSION)-install

gnupg2:
	cd /tmp && \
	wget ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-$(VERSION).tar.bz2 && \
	tar -xf gnupg-$(VERSION).tar.bz2 && \
	cd gnupg-$(VERSION) && \
	./configure \
		--prefix=/usr \
		--bindir=/usr/local/bin \
		--sbindir=/usr/local/sbin \
		--enable-symcryptrun \
		--enable-large-secmem \
		--mandir=/usr/share/man/gnupg/$(VERSION) \
		--infodir=/usr/share/info/gnupg/$(VERSION) \
	    --docdir=/usr/share/doc/gnupg/$(VERSION) && \
	make -j$(CORES) && \
	make install

fpm_debian:
	echo "Packaging gnupg for Debian"

	cd /tmp/gnupg-$(VERSION) && make install DESTDIR=/tmp//tmp/gnupg-$(VERSION)

	mkdir -p /tmp/gnupg-$(VERSION)-install/etc/ld.so.conf.d
	echo "/usr/local/lib/" > /tmp/gnupg-$(VERSION)-install/etc/ld.so.conf.d/gpg2.conf

	fpm -s dir \
		-t deb \
		-n gnupg2 \
		-v $(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2) \
		-C /tmp/gnupg-$(VERSION)-install \
		-p gnupg2_$(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2)_$(shell arch).deb \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/gnupg-build \
		--description "Lua JIT 2.0" \
		--depends "libgpg-error > 0" \
		--depends "libgcrypt > 0" \
		--depends "libksba > 0" \
		--depends "libassuan > 0" \
		--depends "libpth > 0" \
		--depends "gnutls3 > 0" \
		--depends "libgmp10 > 0" \
		--depends "libunbound2  > 0" \
		--after-install=$(SCRIPTPATH)/debian/postinstall-pak \
		--deb-systemd-restart-after-upgrade

fpm_rpm:
	echo "Packaging gnupg for RPM"

	cd /tmp/gnupg-$(VERSION) && make install DESTDIR=/tmp/gnupg-$(VERSION)

	mkdir -p /tmp/gnupg-$(VERSION)-install/etc/ld.so.conf.d
	echo "/usr/local/lib/" > /tmp/gnupg-$(VERSION)-install/etc/ld.so.conf.d/gpg2.conf

	fpm -s dir \
		-t rpm \
		-n gnupg2 \
		-v $(VERSION)-$(RELEASEVER) \
		-C /tmp/gnupg-$(VERSION)-install \
		-p gnupg2_$(VERSION)-$(RELEASEVER)_$(shell arch).rpm \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/gnupg-build \
		--description "Lua JIT 2.0" \
		--vendor "Charles R. Portwood II" \
		--rpm-digest sha384 \
		--rpm-compression gzip