
# Disable AddressSanitizer leak detection;
# we're only interested in finding segfaults.
export ASAN_OPTIONS="detect_leaks=false"

# Enable AddressSanitizer
if [[ $(uname) == "Darwin" ]]; then
    export DYLD_INSERT_LIBRARIES=${PREFIX}/lib/clang/*/lib/darwin/libclang_rt.asan_osx_dynamic.dylib
else
    export LD_PRELOAD=${PREFIX}/lib/libasan.so.5
fi

${PYTHON} _run_test.sh
