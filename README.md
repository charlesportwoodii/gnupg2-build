# gnupg2 build

This repository allows you to build and package gnupg2

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

You will also need to build the following packages:

```
https://github.com/charlesportwoodii/libassuan-build
https://github.com/charlesportwoodii/libksba-build
https://github.com/charlesportwoodii/libgpgcrypt-build
https://github.com/charlesportwoodii/libpth-build
https://github.com/charlesportwoodii/libgpgerror-build
https://github.com/charlesportwoodii/libnettle-build
https://github.com/charlesportwoodii/gnutls-build
```

Everything can be run using the following bash script:

```
apt-get install git build-essential libgmp-dev libunbound-dev libtasn1-6 libtasn1-6-dev m4 -y

for i in libassuan libksba libgpgcrypt libpth libgpgerror libnettle gnutls gnupg2
do
	echo $i
	git clone https://github.com/charlesportwoodii/$i-build
	cd ~/$i-build
	make build
	make package
	make clean
	cd ~
done
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/gnupg2-build
cd gnupg2-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```
