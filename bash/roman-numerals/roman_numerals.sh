#!/usr/bin/env bash

patterns="0    1I   2II  3III 4IV  5V   6VI  7VII 8VIII9IX  "
getromanpattern() {
  fd=$( expr index "$patterns" $1 ) 
  pattern=$( echo ${patterns:$fd:4}  | sed 's, ,,g' )
}
getpowdigits() {
   if [[ $1 == "V" ]]; then
      digits="VLD"
   else 
      if [[ $1 == "X" ]]; then
         digits="XCM"
      else
         digits="IXCM"
      fi
   fi
   digit=${digits:$2:1}
}
     

arabic=$1
pow=$(( ${#arabic} - 1 ))
output=""
for (( i = 0 ; i < ${#arabic} ; i++ )); do
   getromanpattern ${arabic:i:1}
   for (( k = 0; k < ${#pattern} ; k++ )); do
      getpowdigits ${pattern:k:1} $pow
      output=$output$digit
   done
   pow=$(( $pow - 1 ))
done
echo $output
