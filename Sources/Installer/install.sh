#!/bin/sh

# TODO: Create SwiftUI app to do this
set -eo pipefail

if [[ $UID != 0 ]]; then
    echo "run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

