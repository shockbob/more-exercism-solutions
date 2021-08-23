#!/usr/bin/env bash
if (( $1 <= 0 )); then
   echo "Error: Only positive numbers are allowed"
   exit 1
fi
steps=0
value=$1
while (( $value != 1 )); do
   if (( $value % 2 == 0 )); then
      value=$(( $value / 2 ))
   else
      value=$(( $value * 3 + 1 ))
   fi
   steps=$(( $steps + 1 ))
done
echo $steps
