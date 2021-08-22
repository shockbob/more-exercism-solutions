function Normalize(word)
     let arr = []
     for var in tolower(a:word)
        call add(arr,var)
     endfor
    return sort(arr)
endfunction

function FindMatches(target,sources)
    let matches = []
    let normalized = Normalize(a:target)
    for source in a:sources
       if source != a:target && Normalize(source) == normalized
         call add(matches,source)
       endif
    endfor 
    return matches
endfunction    

echo FindMatches("abc",["Cab","abc","dac","ghi","bac"])
