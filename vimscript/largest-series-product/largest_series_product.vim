"
" Given a string of digits, calculate the largest product for a contiguous
" substring of digits of length n.
"
"   :echo LargestProduct('1234', 1)
"   4
"   :echo LargestProduct('1234', 2)
"   12
"   :echo LargestProduct('1234', 3)
"   24
"   :echo LargestProduct('1234', 4)
"   24
"

function! LargestProduct(digits, span) abort
  if len(a:digits) == 0 && a:span > 0
     return -1
  end
  if len(a:digits) == 0
     return 1
  endif
  if len(a:digits) > 0 && a:span == 0
     return 1
  end
  if a:span <= 0 || a:span > len(a:digits)
     return -1
  end
  let nums = []
  for digit in a:digits
     if (digit > "9" || digit < "0")
        throw "invalid input"
     endif
     let nums = nums + [str2nr(digit)]
  endfor
  let max = 0
  let start = 0
  let end = start + a:span-1 
  while end < len(nums) 
     let mult = 1
     for index in range(start,end)
        let mult = mult * nums[index]
     endfor
     if mult > max
        let max = mult
     endif
     let start = start + 1
     let end = end + 1
  endwhile
  return(max)
endfunction
