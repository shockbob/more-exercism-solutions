#!/usr/bin/env bash

output=""

if  ! (( $1 % 3 )) 
   then
   output=$output"Pling" 
fi
if  ! (( $1 % 5 )) 
   then
   output=$output"Plang" 
fi
if  ! (( $1 % 7 )) 
   then
   output=$output"Plong" 
fi

if [[ $output == "" ]]
   then
   echo $1
else
   echo $output
fi
