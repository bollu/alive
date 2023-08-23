#!/usr/bin/env sh
set -e
set -o xtrace

# for f in "addsub/*.fst"; do fstar.exe $f --lax; done
find ./addsub -type f -name "*.fst" | parallel  -j8 -replace='{}' 'fstar.exe {} --lax'


