#!/bin/sh

# TODO: Create SwiftUI app to do this
set -eo pipefail

if [[ $UID != 0 ]]; then
    echo "run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

killall -HUP AquaSKK || true
rm -rf "/Library/Input Methods/AquaSKK.app" || true
sleep 1
cp -r AquaSKK.app "/Library/Input Methods/"

# FIXME: reload without logout
echo "You may need logout to enable AquaSKK"
