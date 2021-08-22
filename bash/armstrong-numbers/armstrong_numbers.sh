#!/usr/bin/env bash

pow () {
   a=$1
   b=$2
   mult=$a
   for (( i=1; i < ${b} ; i++ )); do
       mult=$(( $a * $mult ))
   done
   answer=$mult
}

num=$1
size=${#num}
sum=0
for (( k = 0; k < $size; k++ )); do
   dig=${1:k:1}
   pow $dig $size
   sum=$(( $sum + $answer ))
done
if (( $sum == $1 )); then
   echo "true"
else
   echo "false"
fi
