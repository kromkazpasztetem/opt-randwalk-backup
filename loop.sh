#!/bin/bash

output0="ipc0.txt"
output1="ipc1.txt"
#matrix_size=7
steps=14
walks=12

rm $output0 $output1 2>/dev/null

for version in 0 1
do
    echo "V$version:"
    for matrix_size in {4..15}
    do
        sum_ipc=0
        sum_time=0
        for i in {0..5}
        do
            result=`echo $(./randwalk -p ipc -S 0xea3495cc76b34acc -n $matrix_size -s $steps -t $walks -v $version)`
            ipc=`echo $(echo $result |grep -o "cycle:\ [[:digit:]].[[:digit:]]*" |grep -o [[:digit:]].[[:digit:]]*) |bc`
            time=`echo $(echo $result |grep -o "Time elapsed:\ [[:digit:]].[[:digit:]]*" |grep -o [[:digit:]].[[:digit:]]*) |bc`
            sum_ipc=`echo $sum_ipc + $ipc |bc`
            sum_time=`echo $sum_time + $time |bc`
        done

        if [ $version == 0 ]
        then
            echo "$matrix_size  `echo $sum_ipc/6 |bc -l`    `echo $sum_time/6 |bc -l`">>$output0
        else
            echo "$matrix_size  `echo $sum_ipc/6 |bc -l`    `echo $sum_time/6 |bc -l`">>$output1
        fi
        
        echo "Size: $matrix_size"
    done
done
