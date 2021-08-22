#!/usr/bin/env bash

scores="A1B3C3D2E1F4G2H4I1J8K5L1M3N1O1P3Q0R1S1T1U1V4W4X8Y4Z0"

letter-score() {
   fd=$( expr index $scores $1 )
   score=${scores:$fd:1}
   if (( $score == 0 )); then
      score=10
   fi
} 

a=$( echo $1 | tr a-z A-Z )
size=${#a}
sum=0
for (( i=0; i< size; i++ )); do
  letter-score ${a:$i:1}
  sum=$(( $sum + $score )) 
done
echo $sum
