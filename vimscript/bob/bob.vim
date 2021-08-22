"
" This function takes any remark and returns Bob's response.
"
function! Response(remark) abort
   let remark = trim(a:remark)
   if remark == ""
     return  "Fine. Be that way!"
   endif
   let noLetters = toupper(a:remark) == tolower(a:remark)
   if remark[len(remark)-1] == "?"
      if remark == toupper(remark) && ! noLetters
         return("Calm down, I know what I'm doing!")
      endif
      return('Sure.')
   endif
   if remark == toupper(remark) && ! noLetters
      return('Whoa, chill out!')
   endif
   return 'Whatever.'
endfunction
