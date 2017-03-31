:: ##############################################
:: Build WebRTC

set DEPOT_TOOLS_WIN_TOOLCHAIN=0

cd src

call gn gen out/x86/Debug --args="is_debug=true rtc_include_tests=false target_cpu=\"x86\""
call gn gen out/x86/Release --args="is_debug=false rtc_include_tests=false target_cpu=\"x86\" is_component_build=true symbol_level=0 enable_nacl=false"
call gn gen out/x64/Debug --args="is_debug=true rtc_include_tests=false target_cpu=\"x64\""
call gn gen out/x64/Release --args="is_debug=false rtc_include_tests=false target_cpu=\"x64\" is_component_build=true symbol_level=0 enable_nacl=false"

call ninja -C out/x86/Debug
call ninja -C out/x86/Release
call ninja -C out/x64/Debug
call ninja -C out/x64/Release

cd ..