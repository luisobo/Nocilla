#!/bin/sh
set -e

xctool -workspace Nocilla.xcworkspace -scheme Nocilla build test -sdk iphonesimulator
xctool -workspace Nocilla.xcworkspace -scheme Nocilla build test -test-sdk iphonesimulator6.1 -sdk iphonesimulator
