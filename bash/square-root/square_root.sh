#!/usr/bin/env bash
if (( $1 == 1 )); then
   echo 1
   exit
fi
bottom=0
top=$1
guess=$(( $1 / 2 ))
while true; do
   ans=$(( $guess * $guess ))
   if (( $ans == $1 )); then
      echo $guess
      exit
   fi
   oldguess=$guess
   if (( $ans > $1 )); then
      newguess=$(( ($guess + $bottom) / 2 ))
      top=$guess
      guess=$newguess
   else
      newguess=$(( ($guess + $top) / 2 ))
      bottom=$guess
      guess=$newguess
   fi
   if (( $newguess == $oldguess )); then
       echo "failed to find "$newguess
       exit 0
   fi 
done

   
