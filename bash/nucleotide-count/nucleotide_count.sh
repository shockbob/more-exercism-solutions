#!/usr/bin/env bash

declare -A nucs
nucs=( ["G"]=0 ["C"]=0 ["A"]=0 ["T"]=0 )
str=$1
for (( i = 0; i < ${#str}; i++ )); do
   nuc=${str:$i:1}
   if [[ $nuc != "G" && $nuc != "C" && $nuc != "T" && $nuc != "A" ]]; then
      echo "Invalid nucleotide in strand"
      exit 1
   fi
   nucs[$nuc]=$(( nucs[$nuc] + 1 )) 
done    
for var in  "A" "C" "G" "T" ; do
   echo $var: ${nucs[$var]}
done
