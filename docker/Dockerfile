ARG VERSION=bullseye
# The host image only runs debootstrap, it does not need to match the chroot version
FROM debian:bookworm AS build
ARG VERSION
ARG CHROOT_ARCH=armhf
ARG MIRROR=http://raspbian.raspberrypi.org/raspbian
ENV CHROOT_DIR=/media/chroot/raspberry-pi-os
ENV VERSION=${VERSION}
RUN apt-get update && apt-get install -y debootstrap
RUN mkdir -p $CHROOT_DIR
RUN debootstrap --no-check-gpg --variant=minbase --arch=${CHROOT_ARCH} ${VERSION} ${CHROOT_DIR} ${MIRROR}
COPY --chmod=766 "./run.sh" "${CHROOT_DIR}/run.sh"
COPY --chmod=766 "./entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
