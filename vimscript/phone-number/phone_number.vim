"
" Clean up user-entered phone numbers so that they can be sent SMS messages.
"
" Example:
"
"   :echo ToNANP('+1 (613)-995-0253')
"   6139950253
"
function! ToNANP(number) abort
   let number = substitute(a:number,"[^0-9]","","g")
   let number = substitute(number,"^1","","")
   if (len(number) != 10 || number[0] == "0" || number[0] == "1" || number[3] == "0" || number[3] == "1")
      return ""
   endif
   return number
endfunction
