#!/usr/bin/env bash

name=$1
if [[ $# == 0 ]]
then
  name="you"
fi

echo "One for $name, one for me."
exit 0
