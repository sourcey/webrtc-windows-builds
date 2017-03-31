:: ##############################################
:: Make Package
::
:: Need to run: `npm install copyfiles -g`
:: Build dependencies not included: gflags, ffmpeg, openh264, openmax_dl, winsdk_samples, yasm

set APP_DIR=%CD%
set OUTPUT_DIR=releases\%version%
set PACKAGE_DIR=packages
set ZIP="C:\Program Files\7-Zip\7z"

echo Generating WebRTC release %version% to %OUTPUT_DIR%

:: Install `copyfiles` package
:: call npm install copyfiles -g

cd /D src

for /f "delims=" %%a in ('git rev-parse --short HEAD') do @set version=%%a
call git log -1 > "..\%PACKAGE_DIR%\webrtc-master-%version%.txt"

:: Core
call copyfiles README.md LICENSE ../%OUTPUT_DIR%
call copyfiles webrtc/**/*.h webrtc/LICENSE ../%OUTPUT_DIR%

:: Dependencies
call copyfiles third_party/boringssl/**/*.h third_party/boringssl/README.md third_party/boringssl/LICENSE ../%OUTPUT_DIR%
call copyfiles third_party/expat/files/**/*.h third_party/expat/files/README third_party/expat/files/COPYING ../%OUTPUT_DIR%
:: call copyfiles third_party/ffmpeg/lib*/**/*.h third_party/ffmpeg/LICENSE.md third_party/ffmpeg/README.md ../%OUTPUT_DIR%
call copyfiles third_party/jsoncpp/source/json/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/jsoncpp/source/LICENSE third_party/jsoncpp/source/README.txt ../%OUTPUT_DIR%
call copyfiles third_party/libjpeg/**/*.h third_party/libjpeg/LICENSE third_party/libjpeg/README ../%OUTPUT_DIR%
call copyfiles third_party/libjpeg_turbo/**/*.h third_party/libjpeg_turbo/LICENSE.md third_party/libjpeg_turbo/README.md ../%OUTPUT_DIR%
call copyfiles third_party/libsrtp/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/libsrtp/LICENSE third_party/libsrtp/README ../%OUTPUT_DIR%
call copyfiles third_party/libvpx/source/libvpx/LICENSE third_party/libvpx/source/libvpx/README ../%OUTPUT_DIR%
call copyfiles third_party/libvpx/source/libvpx/vp*/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/libyuv/LICENSE third_party/libyuvREADME.md ../%OUTPUT_DIR%
call copyfiles third_party/libyuv/**/*.h ../%OUTPUT_DIR%
:: call copyfiles third_party/openh264/LICENSE third_party/openh264/README.md ../%OUTPUT_DIR%
:: call copyfiles third_party/openh264/codec/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/opus/README third_party/opus/COPYING ../%OUTPUT_DIR%
call copyfiles third_party/opus/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/protobuf/LICENSE third_party/protobuf/README.md ../%OUTPUT_DIR%
call copyfiles third_party/protobuf/**/*.h ../%OUTPUT_DIR%
call copyfiles third_party/usrsctp/usrsctpout/LICENSE.md third_party/usrsctp/usrsctpout/README.md ../%OUTPUT_DIR%
call copyfiles third_party/usrsctp/usrsctpout/usrsctpout/**/*.h ../%OUTPUT_DIR%

:: Libraries
call copyfiles -e out/x86/Debug/protobuf_full.lib -f out/x86/Debug/**/*.lib -f out/x86/Debug/**/*.dll ../%OUTPUT_DIR%/out/x86/Debug
call copyfiles -e out/x86/Release/protobuf_full.lib -f out/x86/Release/**/*.lib -f out/x86/Release/**/*.dll ../%OUTPUT_DIR%/out/x86/Release
call copyfiles -e out/x64/Debug/protobuf_full.lib -f out/x64/Debug/**/*.lib -f out/x64/Debug/**/*.dll ../%OUTPUT_DIR%/out/x64/Debug
call copyfiles -e out/x64/Release/protobuf_full.lib -f out/x64/Release/**/*.lib -f out/x64/Release/**/*.dll ../%OUTPUT_DIR%/out/x64/Release
cd /D ..

:: Archives
cd /D %OUTPUT_DIR%
call %ZIP% a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -up1q1r2x1y1z1w1 -xr!out -r "%APP_DIR%\%PACKAGE_DIR%\webrtc-master-%version%-headers.7z" .
call %ZIP% a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -up1q1r2x1y1z1w1 "%APP_DIR%\%PACKAGE_DIR%\webrtc-master-%version%-vs2015-x86.7z" out/x86
call %ZIP% a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -up1q1r2x1y1z1w1 "%APP_DIR%\%PACKAGE_DIR%\webrtc-master-%version%-vs2015-x64.7z" out/x64
cd /D %APP_DIR%

:: Symlinks
call rmdir "webrtc-latest"
call del "webrtc-latest-headers.7z"
call del "webrtc-latest-vs2015-x86.7z"
call del "webrtc-latest-vs2015-x64.7z"
call mklink /d "webrtc-latest" "%OUTPUT_DIR%"
call mklink "webrtc-latest-headers.7z" "%PACKAGE_DIR%\webrtc-master-%version%-headers.7z"
call mklink "webrtc-latest-vs2015-x86.7z" "%PACKAGE_DIR%\webrtc-master-%version%-vs2015-x86.7z"
call mklink "webrtc-latest-vs2015-x64.7z" "%PACKAGE_DIR%\webrtc-master-%version%-vs2015-x64.7z"