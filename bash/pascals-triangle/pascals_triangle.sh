#!/usr/bin/env bash

spaces() {
  str=""
  for (( kk = 0; kk < $1; kk++ )); do
    str="$str"" "
  done
}

spacecount=$(( $1 - 1 ))
results=( 1 )
for (( i = 0; i < $1; i++ )); do
   spaces $spacecount
   spacecount=$(( $spacecount - 1 ))
   echo "$str"${results[@]}
   values=( ${results[@]} )
   sum=0
   results=()
   for value in "${values[@]}"; do
      sum=$(( $sum + $value ))
      results=( ${results[@]} $sum )
      sum=$value
   done
   results=( ${results[@]} 1 )
done;
