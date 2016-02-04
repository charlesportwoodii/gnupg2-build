SHELL := /bin/bash

# Dependency Versions
VERSION?=2.1.11
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
		--mandir=/usr/share/man/gnupg-$(VERSION) \
		--infodir=/usr/share/info/gnupg-$(VERSION) \
	    --docdir=/usr/share/doc/gnupg-$(VERSION) && \
	make -j$(CORES) && \
	make install

package:
	cd /tmp/gnupg-$(VERSION) && \
	checkinstall \
	    -D \
	    --fstrans \
	    -pkgrelease "$(RELEASEVER)"-"$(RELEASE)" \
	    -pkgrelease "$(RELEASEVER)"~"$(RELEASE)" \
	    -pkgname "gnupg2" \
	    -pkglicense GPLv3 \
	    -pkggroup GPG \
	    -maintainer charlesportwoodii@ethreal.net \
	    -provides "gpg2, dirmngr" \
	    -requires "libgpg-error, libgcrypt, libksba, libassuan, libpth, gnutls3, libgmp10, libunbound2" \
		-nodoc \
	    -pakdir /tmp \
	    -y