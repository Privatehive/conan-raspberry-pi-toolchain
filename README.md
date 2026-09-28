# conan-raspberry-pi-toolchain

[![Conan Remote Recipe](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fapi.github.com%2Frepos%2FPrivatehive%2Fconan-raspberry-pi-toolchain%2Fproperties%2Fvalues&query=%24%5B0%5D.value&style=flat&logo=conan&label=conan&color=%232980b9)](https://conan.privatehive.de/ui/repos/tree/General/public-conan/de.privatehive/raspberry-pi-toolchain) 

### A conan package that provides a recent cross compiler and a minimal sysroot for Raspberry Pi OS

---

| os      | arch     | CI Status                                                                                                                                                                                                                                                                                         |
| ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Linux` | `x86_64` | [![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Privatehive/conan-raspberry-pi-toolchain/main.yml?branch=master&style=flat&logo=github&label=create+package)](https://github.com/Privatehive/conan-raspberry-pi-toolchain/actions?query=branch%3Amaster) |

The package contains either the 32 bit (`armv6-rpi-linux-gnueabihf`) or the 64 bit (`aarch64-rpi3-linux-gnu`) cross compiler, together with a matching sysroot. When used as a `tool_requires` the target architecture is taken from the `arch` setting of the host profile (`armv8` selects the 64 bit toolchain, everything else the 32 bit one). It can also be set explicitly with the option `raspberry-pi-toolchain/*:target_arch=armv6|armv8`. Without a host profile (e.g. a plain `conan create`) the 32 bit toolchain is built.

### Updating the sysroot packages

To populate `conandata.yml` with the Raspberry Pi OS packages that make up the sysroot run the provided Docker container. Each run replaces only the package list (`packages-<version>-<debian arch>`) of the architecture it was built for.

Install qemu and binfmt-support and register the executable types on the host with a this command:

```
$ docker run --privileged --rm tonistiigi/binfmt --install all
```

Then run the following image for the 32 bit (`armhf`) sysroot

```
$ docker build ./docker -f docker/Dockerfile --build-arg VERSION=bullseye -t raspberrypi-chroot && docker run --rm -it --privileged -v $(pwd):/out raspberrypi-chroot
```

and for the 64 bit (`arm64`) sysroot. Raspberry Pi OS 64 bit is based on the regular Debian arm64 repository.

```
$ docker build ./docker -f docker/Dockerfile --build-arg VERSION=bullseye --build-arg CHROOT_ARCH=arm64 --build-arg MIRROR=http://deb.debian.org/debian -t raspberrypi-chroot-arm64 && docker run --rm -it --privileged -v $(pwd):/out raspberrypi-chroot-arm64
```
