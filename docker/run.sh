#!/bin/bash

# Define your main package list
packages=(libgbm-dev libdrm-dev libegl-dev libgles-dev libinput-dev libinput10 libudev-dev libxkbcommon-dev libsecret-1-dev)

# Define your blacklist (wildcards allowed, e.g., libc* will match libc6, libc-dev, etc.)
blacklist=(gcc-*-base libc-dev-bin libc6* libatomic? libllvm* libgcc-* libstdc++* python3* zlib1g* libz3* linux-libc* binutils* debconf* dpkg* libpkgconf* libpython3* perl* pkg-config)

# Collect all dependencies
all_packages=()

for pkg in "${packages[@]}"; do
    all_packages+=("$pkg")
    deps=$(apt-cache depends -i --recurse "$pkg" 2>/dev/null | \
           awk '/^  Depends:|^  PreDepends:/ {print $2}' | grep -v '^<.*>$')
    all_packages+=($deps)
done

# Deduplicate and filter using blacklist with wildcards
final_packages=()
for pkg in $(printf "%s\n" "${all_packages[@]}" | sort -u); do
    skip=false
    for blk in "${blacklist[@]}"; do
        if [[ "$pkg" == $blk ]]; then
            skip=true
            break
        fi
    done
    if ! $skip; then
        final_packages+=("$pkg")
    fi
done

# Output the final list
printf "%s\n" "${final_packages[@]}"

printf "packages-${VERSION}:\n" > /out/conandata.yml

apt-get -qq --print-uris download "${final_packages[@]}" | \
awk '
{
    gsub(/'\''/, "", $1);  # Remove single quotes from URL
    if ($4 ~ /^SHA256:/) {
        sha256 = substr($4, 8);  # Remove "SHA256:" prefix
        printf("  - name: %s\n", $1);
        printf("    sha256: %s\n", sha256);
    }
}' >> /out/conandata.yml
