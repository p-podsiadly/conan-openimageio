#!/bin/bash

set -e
set -x

if [[ "$(uname -s)" == 'Darwin' ]]; then
    brew update || brew update
    brew install python3 cmake || true

    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
    fi
fi

pip3 install conan --upgrade
pip3 install conan_package_tools bincrafters_package_tools

conan user