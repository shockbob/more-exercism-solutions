"
" Determine if a sentence is a pangram.
"
" A pangram is a sentence using every letter of the alphabet at least once.
"
" The alphabet used consists of ASCII letters a to z, inclusive, and is case
" insensitive. Input will not contain non-ASCII symbols.
"
" Example:
"
"     :echo IsPangram('The quick brown fox jumps over the lazy dog')
"     1
"     :echo IsPangram('The quick brown fox jumps over the lazy do')
"     0
"

function! IsPangram(sentence) abort
   let map = {}
   for letter in tolower(a:sentence)
      if (letter <= 'z' && letter >= 'a')
         let map[letter] = get(map,letter,0)+1
      endif
   endfor
   return len(map) == 26
endfunction
