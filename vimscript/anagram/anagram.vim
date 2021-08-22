"
" Given a word and a list of possible anagrams, select the correct sublist.
"
" Example:
"
"   :echo FindAnagrams(['foo', 'bar', 'oof', 'Ofo'], 'foo')
"   ['Ofo', 'oof']
"
function Normalize(word)
     let arr = []
     for var in tolower(a:word)
        call add(arr,var)
     endfor
    return sort(arr)
endfunction

function! FindAnagrams(candidates, subject) 

  " your solution goes here
    let matches = []
    let normalized = Normalize(a:subject)
    for candidate in a:candidates
       if tolower(candidate) != tolower(a:subject) && Normalize(candidate) == normalized
         call add(matches,candidate)
       endif
    endfor 
    return matches
endfunction    

