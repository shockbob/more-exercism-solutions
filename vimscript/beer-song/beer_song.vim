"
" Produce the lyrics to that beloved classic, that field-trip favorite: 99
" Bottles of Beer on the Wall.
"
"   :echo Verse(99)
"   99 bottles of beer on the wall, 99 bottles of beer.
"   Take one down and pass it around, 98 bottles of beer on the wall.
"
"
"   :echo Verses(99, 98)
"   99 bottles of beer on the wall, 99 bottles of beer.
"   Take one down and pass it around, 98 bottles of beer on the wall.
"
"   98 bottles of beer on the wall, 98 bottles of beer.
"   Take one down and pass it around, 97 bottles of beer on the wall.
"


function! Bottle(num) abort
   if a:num == 0
      return "No more bottles"
   else 
      if a:num == 1
         return "1 bottle"
      else
         return string(a:num) . " bottles"
      endif
   endif
endfunction

function! It(num) abort
   if (a:num == 1)
      return "it"
   endif
   return "one"
endfunction

function! InnerBottle(num)
   if (a:num == 0)
      return "no more bottles"
   endif
   return Bottle(a:num)
endfunction

function! FirstLine(num)
   return Bottle(a:num) . " of beer on the wall, " . InnerBottle(a:num) . " of beer.\n" 
endfunction


function! Verse(num) abort
    if a:num == 0
      return FirstLine(0) . "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
   else
       return FirstLine(a:num) . "Take " . It(a:num) . " down and pass it around, " . InnerBottle(a:num-1) . " of beer on the wall.\n"
   endif
endfunction

function! Verses(start, end) abort
   let lines = "" 
   for verse in range(a:start,a:end,-1)
      if (lines != "")
         let lines = lines . "\n"
      endif
      let lines = lines . Verse(verse)
   endfor
   return lines
endfunction
