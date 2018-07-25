#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
OUTPUT="dist/getSynchronizer.js"
cd $DIR
echo "Building Synchronizer..."
lsc -bcp index.ls > $OUTPUT
echo "...build succeeded in $OUTPUT"
