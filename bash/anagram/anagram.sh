#!/usr/bin/env bash

anagram () {
   a=$( echo $1 | tr A-Z a-z )
   b=$( echo $2 | tr A-Z a-z )
   if [[ ${a} == ${b} ]]; then
       return 0 
   fi
   if [[ ${#a} != ${#b} ]]; then
       return 0 
   fi
   for (( i=0; i < ${#a} ; i++ )); do
      c=$( echo $b | sed "s,${a:$i:1},," ) 
      if [[ $c == $b ]]; then
         return 0
      fi
      b=$c
   done
   return 1 
}
candidates=($2)

word=$1
output=""
for  candidate in ${candidates[*]}; do
   anagram $word $candidate
   if [[ $? == 1 ]]; then
      output="$output $candidate"
   fi 
done
echo $output | sed 's,^ ,,'
