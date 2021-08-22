"
" This function takes a DNA strand and returns its RNA complement.
"
"   G -> C
"   C -> G
"   T -> A
"   A -> U
"
" If the input is invalid, return an empty string.
"
" Example:
"
"   :echo ToRna('ACGTGGTCTTAA')
"   UGCACCAGAAUU
"
function! ToRna(strand) abort
    let rnaMap = {"G":"C","C":"G","T":"A","A":"U"}
    let rna = ""
    for nuc in a:strand 
        let rnuc = get(rnaMap,nuc,"INV")
	if (rnuc == "INV")
           return ""
        endif
	let rna = rna . rnuc
    endfor
    return rna
endfunction
