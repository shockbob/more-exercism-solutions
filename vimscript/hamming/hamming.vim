"
" This function takes two strings which represent strands and returns
" their Hamming distance.
"
" If the lengths of the strands don't match, throw this exception:
"
"     'left and right strands must be of equal length'
"
function! Distance(strand1, strand2)
   let distance = 0
   if (len(a:strand1) != len(a:strand2))
      throw 'left and right strands must be of equal length'
   endif
   for i in range(0,len(a:strand1)-1)
      if (a:strand1[i] != a:strand2[i])
         let distance = distance + 1
      endif
   endfor
   return(distance)
endfunction
