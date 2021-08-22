#!/usr/bin/env bash

if (( $# == 0 || $# > 1 ));then
   echo "Usage: leap.sh <year>"
   exit 1
fi

arg=$1
remove_dots=$( echo $arg | sed 's,\.,,' )
if (( ${#arg} != ${#remove_dots} )) ; then
   echo "Usage: leap.sh <year>"
   exit 1
fi
remove_alphas=$( echo $arg | sed 's,[a-zA-Z],,' )
if (( ${#arg} != ${#remove_alphas} )) ; then
   echo "Usage: leap.sh <year>"
   exit 1
fi
    

if (( ($1 % 400) == 0));then
   echo "true"
   exit
fi

if (( ($1 % 4) == 0 && ($1 % 100) != 0 )); then
   echo "true"
   exit
fi

echo "false"

