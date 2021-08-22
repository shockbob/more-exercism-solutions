#!/usr/bin/env bash
#!/usr/bin/env bash

found=""
a=$1
a=`echo "$a" | tr A-Z a-z | sed 's,[^a-z],,g'`
for (( i=0; i < ${#a} ; i++ )); do
   fd=`expr index "$found" "${a:$i:1}"`
   if [[ $fd == 0 ]] 
      then
      found=$found${a:$i:1}
      else
         echo "false"
         exit 
   fi
done
echo "true"
