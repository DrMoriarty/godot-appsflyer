#!/bin/sh

scons platform=ios || exit 1
scons platform=ios ios_arch=x86_64 || exit 1

lipo -create -output bin/libappsflyer.fat.a bin/libappsflyer_arm64.a bin/libappsflyer_x86_64.a

rm bin/libappsflyer_arm64.a
rm bin/libappsflyer_x86_64.a
