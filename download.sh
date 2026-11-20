#!/bin/bash

set -euo pipefail

base=https://github.com/cpmech/matrix-market/releases/latest/download
dest=${1:-$PWD}

mkdir -p "$dest"
dest=$(cd "$dest" && pwd)
cd "$dest"

for n in 01 02 03 04 05 06 07; do
    echo "Downloading ${n}.tar.xz"
    curl -fLO --retry 3 "${base}/${n}.tar.xz"

    tar xf "${n}.tar.xz"
    mv "${n}"/*.mtx .
    rmdir "${n}"
    rm "${n}.tar.xz"
done

echo "Matrices are in ${dest}"
