#!/usr/bin/env bash

tobase10() {
   inbase=$1
   values=$2
   sum=0
   for value in "${values[@]}"; do 
      if (( $value < 0 || $value >= $inbase )); then
         echo "Invalid digit " $value
         exit 1
      fi
      sum=$(( $sum * $inbase + $value )) 
   done;
}

frombase10() {
   outbase=$1
   val=$2
   output=()
   while (( $val > 0 )); do
      rem=$(( $val % $outbase ))
      output=("$rem" "${output[@]}")
      val=$(( $val / $outbase ))
   done;
}
if (( $3 <= 1  || $1 <= 1 )); then
   echo "Bad base"
   exit 1
fi
values=($2)
if (( ${#values[@]} == 0 )); then
   export "Too short"
   exit 0
fi
tobase10 $1 $values     
frombase10 $3 $sum
echo ${output[@]}
