"
" Create an implementation of the atbash cipher, an ancient encryption system
" created in the Middle East.
"
" Examples:
"
"   :echo AtbashEncode('test')
"   gvhg
"
"   :echo AtbashDecode('gvhg')
"   test
"
"   :echo AtbashDecode('gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt')
"   thequickbrownfoxjumpsoverthelazydog
"

function! AtbashDecode(cipher) abort
   let alphabet = "abcdefghijklmnopqrstuvwxyz"
   let decoded = ""
   for letter in tolower(a:cipher)
      let index = stridx(alphabet,letter)
      if (index != -1)
        let decoded = decoded . alphabet[25-index]
      endif
      if (letter <= "9" && letter >= "0")
         let decoded = decoded . letter
      endif
   endfor
   return decoded
endfunction

function! AtbashEncode(plaintext) abort
   let alphabet = "abcdefghijklmnopqrstuvwxyz"
   let encoded = ""
   let numletters = 0
   for letter in tolower(a:plaintext)
      let index = stridx(alphabet,letter)
      if (index != -1)
        let numletters = numletters + 1
        let encoded = encoded . alphabet[25-index]
      endif
      if (letter <= "9" && letter >= "0")
         let numletters = numletters + 1
         let encoded = encoded . letter
      endif
      if numletters == 5
         let numletters = 0
	 let encoded = encoded . " "
      endif
   endfor
   return trim(encoded)
endfunction
