# gnupg2 build

This repository allows you to build and package gnupg2

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

You will also need to install the other build packages for gnupg2 outlined below:

```
https://github.com/charlesportwoodii/libassuan-build
https://github.com/charlesportwoodii/libksba-build
https://github.com/charlesportwoodii/libgpgcrypt-build
https://github.com/charlesportwoodii/libpth-build
https://github.com/charlesportwoodii/libgpgerror-build
https://github.com/charlesportwoodii/libnettle-build
https://github.com/charlesportwoodii/gnutls-build
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/gnupg2-build
cd gnupg2-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```
