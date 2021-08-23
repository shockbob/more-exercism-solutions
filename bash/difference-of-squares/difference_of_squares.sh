#!/usr/bin/env bash

which=$1
shift
sum=$(( ($1 * ( $1 + 1 )) / 2 ))
sqofsum=$(( $sum * $sum ))
sumofsq=$(( ($1 *($1 +1 )*(($1 * 2)+ 1))/ 6 )) 
diff=$(( $sqofsum - $sumofsq ))
case $which in
"square_of_sum") 
   echo $sqofsum
   ;;
"sum_of_squares")
   echo $sumofsq
;;
"difference") 
   echo $diff
;;
esac

