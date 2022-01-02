#!/bin/bash

set -x

# We do want -O3 (the default CXXFLAGS imposes -O2)
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include -std=c++17 -O3"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

export BOOST_ROOT="${PREFIX}"

# Explicitly set this, which is used in configure.
# (We patched away the auto-detection of this variable.)
export BOOST_PYTHON_LIB=boost_python${CONDA_PY}

# Note about PYTHON_LIBS:
# If left unset, the configure script will set PYTHON_LIBS as follows:
#
#   PYTHON_LIBS="-L${PREFIX}/lib -lpython3.7m"
#
# ...but we never want to link against libpython in a conda environment.
# That's because conda's python executable is STATICALLY linked.
# It does not link against libpython3.7.dylib and therefore no
# python extension modules should link against libpython3.7, either!
# In fact, if we link against libpython, we'll end up with segfaults.
# Instead, all python symbols will be loaded by python executable itself.
#
# So, we don't want to set PYTHON_LIBS, but we can't leave it empty.
# This is a suitable no-op.
PYTHON_LIBS=" "

if [[ $target_platform == osx* ]]; then
    # Don't resolve python symbols until runtime.
    # See note above about PYTHON_LIBS.
    export LDFLAGS="${LDFLAGS} -undefined dynamic_lookup"

    if [[ "$CI" == "azure" ]]; then
        # https://github.com/conda-forge/conda-forge-ci-setup-feedstock/issues/53#issuecomment-490314561
        export CPU_COUNT=4
    fi
fi

echo "Building with CPU_COUNT=${CPU_COUNT}"

./autogen.sh

./configure \
    --prefix="${PREFIX}" \
    --with-boost="${BOOST_ROOT}" \
    --with-boost-libdir="${BOOST_ROOT}/lib" \
    --with-expat="${PREFIX}" \
    --with-cgal="${PREFIX}" \
    --disable-debug \
    --disable-dependency-tracking \
    PYTHON_LIBS="${PYTHON_LIBS}"

echo "[all] Starting make"
make -j2

# Test
#LD_LIBRARY_PATH=${PREFIX}/lib make check
#DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib make check

make install
