#!/usr/bin/env bash

input="$1"
input=$( echo $input | sed 's, *$,,' )
inputtrimmed=$( echo "$input" | sed 's,[\n\r\t ],,g' | sed 's,[^A-Za-z?!0-9],,g' )
allspaces=0
if (( ${#inputtrimmed} == 0 )) ; then
   allspaces=1
fi
withoutuppers=$( echo $input | sed 's,[A-Z],,' )
hasuppers=1
if [[ $withoutuppers == $input ]]; then
   hasuppers=0
fi 
touppers=$( echo $input | tr a-z A-Z )
alluppers=0  
if [[ $touppers == $input && $hasuppers == 1 ]]; then
   alluppers=1
fi
last=$(( ${#input} - 1 ))
question=0
if [[ "${input:$last:1}" == "?" ]]; then
   question=1
fi 

exclaim=0
if [[ ${input:$last:1} == "!" ]]; then
   exclaim=1
fi 

if (( $allspaces == 1 )); then
   echo "Fine. Be that way!"
elif (( $alluppers == 1 && $question == 1 )); then
   echo "Calm down, I know what I'm doing!"
elif (( $question == 1 )); then
   echo "Sure."
elif (( $exclaim == 1 && $alluppers == 1 )); then
   echo "Whoa, chill out!"
elif (( $alluppers == 1 )); then
   echo "Whoa, chill out!"
elif (( ${#inputtrimmed} == 0 )); then
   echo "Fine. Be that way!"
else
   echo "Whatever."
fi



