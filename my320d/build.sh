#!/usr/bin/env bash
# Build the Pi package from app.html (the same file that is published as the artifact).
#   ./build.sh           writes build/my320d/ and my320d-pi.tar.gz
#   ./build.sh deploy    also copies it to the Pi and installs it (needs SSH key login)
set -euo pipefail
cd "$(dirname "$0")"

# The Pi's address lives in pi.env (git-ignored): PI=user@address
[[ -f pi.env ]] && source pi.env

rm -rf build && mkdir -p build/my320d
{
  printf '<!DOCTYPE html>\n<html lang="en">\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  cat app.html
} > build/my320d/index.html
cp pi/install.sh build/my320d/install.sh
COPYFILE_DISABLE=1 tar --no-xattrs -czf my320d-pi.tar.gz -C build my320d
echo "Built my320d-pi.tar.gz"

if [[ ${1:-} == deploy ]]; then
  : "${PI:?Copy pi.env.example to pi.env and set PI=user@address}"
  scp -q my320d-pi.tar.gz "$PI":~
  ssh -t "$PI" 'tar xzf my320d-pi.tar.gz && sudo sh my320d/install.sh'
fi
