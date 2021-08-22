"
" Given a word, return the scrabble score for that word.
"
"    Letter                           Value
"    A, E, I, O, U, L, N, R, S, T     1
"    D, G                             2
"    B, C, M, P                       3
"    F, H, V, W, Y                    4
"    K                                5
"    J, X                             8
"    Q, Z                             10
"

function! Score(word) abort
    let ones = "aeioulnrst"
    let twos = "dg"
    let threes = "bcmp"
    let fours = "fhvwy"
    let fives = "k"
    let eights = "jx"
    let tens = "qz"
    let score = 0
    for letter in tolower(a:word)
       if (stridx(ones,letter) != -1)
          let score = score + 1
       endif
       if (stridx(twos,letter) != -1)
          let score = score + 2
       endif
       if (stridx(threes,letter) != -1)
          let score = score + 3
       endif
       if (stridx(fours,letter) != -1)
          let score = score + 4
       endif
       if (stridx(fives,letter) != -1)
          let score = score + 5
       endif
       if (stridx(eights,letter) != -1)
          let score = score + 8
       endif
       if (stridx(tens,letter) != -1)
          let score = score + 10
       endif
    endfor
    return(score)
endfunction
