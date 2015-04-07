#!/bin/sh
set -e

xctool -workspace Nocilla.xcworkspace -scheme Nocilla build test -sdk iphoneos
xctool -workspace Nocilla.xcworkspace -scheme Nocilla build test -test-sdk iphoneos -sdk iphoneos
