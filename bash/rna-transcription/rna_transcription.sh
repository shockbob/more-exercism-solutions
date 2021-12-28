#!/usr/bin/env bash

DNA=$1
declare -A DNA2RNA
DNA2RNA=( ["G"]="C" ["C"]="G" ["T"]="A" ["A"]="U" )
RNA=""
for (( i = 0; i < ${#DNA}; i++ )); do
  nuc=${DNA:$i:1} 
  if [[ $nuc != "G" && $nuc != "C" && $nuc != "T" && $nuc != "A" ]]; then
     echo  "Invalid nucleotide detected."
     exit 1
  fi 
  RNA="${RNA}""${DNA2RNA[${DNA:$i:1}]}" 
done

echo $RNA
