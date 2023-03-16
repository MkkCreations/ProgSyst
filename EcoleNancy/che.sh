#! /bin/bash

function serch {

    d=$(sort -n data.txt)
    max=$(sort -n data.txt | tail -n 1)

    range=$(seq 0 $max)
    nums=($d)
    for i in ${range[@]}; do
        found=0
        for j in ${nums[@]}; do
            if [ $i -eq $j ]; then
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            echo "$i"
        fi
    done
}
serch