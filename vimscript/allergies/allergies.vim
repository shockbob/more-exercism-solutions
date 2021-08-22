"
" Given a person's allergy score, determine whether or not they're allergic to
" a given item, and their full list of allergies.
"
"   eggs          1
"   peanuts       2
"   shellfish     4
"   strawberries  8
"   tomatoes      16
"   chocolate     32
"   pollen        64
"   cats          128
"
" Examples:
"
"   :echo AllergicTo(5, 'shellfish')
"   1
"
"   :echo List(5)
"   ['eggs', 'shellfish']
"
let numToAllergyMap = {1:"eggs",2:"peanuts",4:"shellfish",8:"strawberries",16:"tomatoes",32:"chocolate",64:"pollen",128:"cats"}

let allergyToNumMap = {"eggs":1,"peanuts":2,"shellfish":4,"strawberries":8,"tomatoes":16,"chocolate":32,"pollen":64,"cats":128}

function! AllergicTo(score, allergy) abort
   let num = get(g:allergyToNumMap,a:allergy,-1)
   if (num == -1)
      return 0
   endif
   return and(num,a:score) != 0 
endfunction

function! List(score) abort
   let num = 1
   let allergies = []
   while num <= a:score
     if and(a:score,num) != 0
        let allergy = get(g:numToAllergyMap,num,"INV")
        if allergy != "INV"
           let allergies = allergies + [allergy]
        endif
     endif
     let num = num * 2 
   endwhile
   return allergies
endfunction
