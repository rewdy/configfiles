#!/bin/bash

# user brew open SSL for python builds
export CPATH=$(brew --prefix openssl)/include:$CPATH
export LIBRARY_PATH=$(brew --prefix openssl)/lib:$LIBRARY_PATH