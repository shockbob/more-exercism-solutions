"
" Determine if a triangle is equilateral, isosceles, or scalene.
"
" An equilateral triangle has all three sides the same length.
"
" An isosceles triangle has at least two sides the same length.
" (It is sometimes specified as having exactly two sides the
" same length, but for the purposes of this exercise we'll say
" at least two.)
"
" A scalene triangle has all sides of different lengths.
"
"
function! LengthsOK(triangle) abort
   let a = a:triangle[0]
   let b = a:triangle[1]
   let c = a:triangle[2]
   return (a+b) > c && (b+c) > a && a+c > b
endfunction

function! ValidTriangle(triangle) abort
   let a = a:triangle[0]
   let b = a:triangle[1]
   let c = a:triangle[2]
   if a == 0 || b == 0 || c == 0
      return 0
   endif
   return LengthsOK(a:triangle)
endfunction

function! GetUniqueSideCount(triangle) abort
   let map = {}
   for tri in a:triangle
      let map[tri] = 1
   endfor
   return len(map)
endfunction

function! Equilateral(triangle) abort
  if (! ValidTriangle(a:triangle))
    return 0
  endif
  return GetUniqueSideCount(a:triangle) == 1 
endfunction

function! Isosceles(triangle) abort
  if (! ValidTriangle(a:triangle))
    return 0
  endif
  let sides = GetUniqueSideCount(a:triangle)
  return sides == 1 || sides == 2 
endfunction

function! Scalene(triangle) abort
  if (! ValidTriangle(a:triangle))
    return 0
  endif
  return GetUniqueSideCount(a:triangle) == 3 
endfunction
