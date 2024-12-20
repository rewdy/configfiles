#!/bin/bash

# user brew open SSL for python builds
# Note: this path comes from the output of `brew --prefix openssl`. That takes like
# 50ms to run so I'm not going to run it every time I open a shell. This is instant.
ssl_path=$HOMEBREW_PREFIX/opt/openssl@3
export CPATH=$ssl_path/include:$CPATH
export LIBRARY_PATH=$ssl_path/lib:$LIBRARY_PATH