
if [[ $1 == "total" ]]; then
   echo 18446744073709551615
   exit
fi

if (( $1 > 64 || $1 <= 0 )); then
  echo  "Error: invalid input"
  exit 1
fi

if (( $1 == 64 )); then
   echo 9223372036854775808
   exit
fi 


count=1
for (( i = 1; i < $1; i++ )); do
  count=$(( $count + $count ))
done;
echo $count
