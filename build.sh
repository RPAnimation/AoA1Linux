#!/bin/bash

if [ -z "$1" ]; then
    echo "No assembly file provided"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No c file provided"
    exit 1
fi

mkdir -p "./out"

gcc -c "${1}" -o "./out/test.out"

#gcc "./out/test.out" -fno-pie -no-pie "${2}" -o "./out/test" -lstdc++
gcc "./out/test.out" "${2}" -o "./out/test" -lstdc++
 
