#!/usr/bin/env bash
   if [[ $# == 0 ]]
      then
      exit 0
   fi
   a=$1
   rev=""
   start=$(( ${#a} -1 ))
   for (( i=$start; i> -1 ; i-- )); do
       rev=${rev}${a:i:1}
   done
   echo "$rev"
   exit 0
