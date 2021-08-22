"
" Write a function to convert Arabic numbers to Roman numerals.
"
" Examples:
"
"   :echo ToRoman(1990)
"   MCMXC
"
"   :echo ToRoman(2008)
"   MMVIII
"
function! ToRoman(number) abort
   let arabicToRoman = {1 : {0: "I", 1 : "X", 2: "C", 3: "M"}, 5 : {0:"V",1:"L",2:"D"}, 10 : {0: "X", 1: "C", 2: "M"}}
   let romanDigits =  [[],[1],[1,1],[1,1,1],[1,5],[5],[5,1],[5,1,1],[5,1,1,1],[1,10]]
   let arabic = string(a:number)
   let powers = range(len(arabic)-1,0,-1)
   let index = 0
   let result = ""
   for power in powers
      let arabicDigit = str2nr(arabic[index])
      let index = index + 1
      let romanDigs = romanDigits[arabicDigit]
      for romanDig in romanDigs
         let result = result . arabicToRoman[romanDig][power]
      endfor
   endfor   
   return result
endfunction
