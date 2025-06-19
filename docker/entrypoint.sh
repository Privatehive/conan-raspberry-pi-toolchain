#!/bin/bash
mount proc ${CHROOT_DIR}/proc -t proc
mount sysfs ${CHROOT_DIR}/sys -t sysfs
mkdir ${CHROOT_DIR}/out
mount --bind /out ${CHROOT_DIR}/out
cp /etc/hosts ${CHROOT_DIR}/etc/hosts
cp /proc/mounts ${CHROOT_DIR}/etc/mtab
exec chroot ${CHROOT_DIR} /bin/bash "$@"
