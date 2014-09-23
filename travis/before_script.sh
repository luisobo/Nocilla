#!/bin/sh
set -e

brew update
if brew outdated | grep -qx xctool; then brew upgrade xctool; fi
xctool --version
