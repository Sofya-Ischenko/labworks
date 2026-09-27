#!/bin/bash

for level in O0 O1 O2 O3 Os Ofast Og; do	
    for n in 5000000000 10000000000 15000000000 20000000000; do
        echo -n "N=$n -$level: "    
        for i in 1 2 3; do
	    sync
            /usr/bin/time -f "%e" ./pi2_$level $n 2>&1 > /dev/null
        done | sort -n | head -1
    done
    echo ""
done
