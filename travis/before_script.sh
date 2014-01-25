#!/bin/sh
set -e

brew update
brew upgrade xctool
xctool --version
