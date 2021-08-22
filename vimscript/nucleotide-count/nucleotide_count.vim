"
" Given a DNA string, compute how many times each nucleotide occurs in the
" string.
"
" Examples:
"
"   :echo NucleotideCounts('ACGTACGT')
"   {'A': 2, 'C': 2, 'T': 2, 'G': 2}
"
"   :echo NucleotideCounts('ACGTXACGT')
"   E605: Exception not caught: Invalid nucleotide in strand
"

function! NucleotideCounts(strand) abort
  let nucmap =  {"A": 0, "C": 0, "T": 0, "G": 0}
  for nuc in a:strand
     let value = get(nucmap,nuc,-1)
     if (value == -1)
        throw "Invalid nucleotide in strand"
     endif
     let nucmap[nuc] = value + 1
  endfor
  return(nucmap)
endfunction
