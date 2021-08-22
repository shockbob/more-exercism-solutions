#!/usr/bin/env bash
   if ((  $# < 2 )) 
     then
       echo "Usage: hamming.sh <string1> <string2>" 
       exit 1
   fi
   a=$1
   b=$2
   let dist=0
   if (( ${#a} != ${#b} )) 
     then
     echo "left and right strands must be of equal length"
     exit 1
   fi
   let dist=0
   for (( i=0; i<${#a}; i++ )); do
       if [[ ${a:$i:1} != "${b:$i:1}" ]]
          then
          let dist=$(( $dist + 1 ))
       fi
   done
   echo $dist
   exit 0
