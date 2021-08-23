#!/usr/bin/env bash

max=$1
shift
sum=0
for (( k = 1; k < $max; k++ )); do
   div=0
   for i in $*; do
      if (( $i != 0 && ($k % $i) == 0 )); then
         div=1 
      fi 
   done
   if (( $div == 1 )); then
      sum=$(( $sum+$k ))
   fi
done
echo $sum
