#!/bin/sh
set -e

xctool -workspace Nocilla.xcworkspace -scheme Nocilla build test -sdk iphonesimulator
