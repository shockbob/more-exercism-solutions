"
" Given a phrase, return a dictionary containing the count of occurrences of
" each word.
"
" Example:
"
"   :echo WordCount('olly olly in come free')
"   {'olly': 2, 'come': 1, 'in': 1, 'free': 1}
"
function! WordCount(phrase) abort
  let words = split(substitute(a:phrase,"[,\n\.|:&!&@$%^&]", " ","g"),' ')
  let map = {}
  for word in words
      if word != ''
         let word = trim(tolower(word),"'")
         let map[word] = get(map,word,0) + 1 
      end
  endfor      
  return(map)
endfunction
