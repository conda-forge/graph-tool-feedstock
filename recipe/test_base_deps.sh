#!/bin/bash

if (conda list | grep cairo); then
    1>&2 echo "graph-tool-base should not install cairo"
    exit 1
fi

if (conda list | grep glib); then
    1>&2 echo "graph-tool-base should not install glib"
    exit 1
fi
