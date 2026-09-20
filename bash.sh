#!/bin/bash

for level in O0 O1 O2 O3 Os Ofast Og; do	
    for n in 5000000000 10000000000 15000000000 20000000000; do
        sync
        echo -n "N=$n -$level: "
        /usr/bin/time -f "%e s" ./pi2_$level $n > /dev/null
    done
    echo ""
done
