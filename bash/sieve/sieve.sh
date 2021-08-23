#!/usr/bin/env bash

if (( $1 <= 1 )); then
   echo ""
   exit
fi
primes=( 0 0 )
for (( i = 2; i <= $1 ; i++ )); do
  primes[i]=1
done

for (( i = 2; i <= $1 / 2; i++ )); do
   start=$(( $i + $i ))
   for (( k = start; k <= $1; k+= $i )); do
      primes[k]=0
   done 
done

allprimes=()
for (( i = 2; i <= $1; i++ )); do
     if (( ${primes[$i]} == 1 )); then
        allprimes+=($i)
     fi
done 
echo "${allprimes[@]}"
