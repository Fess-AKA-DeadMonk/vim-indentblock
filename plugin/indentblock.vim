" TODO: pass stop_on_empty var.
" possibly unite high-level functions into one?
" extend range for yaml lists-like strings

" MAPPINGS
" visual
vnoremap ii :<c-u>call indentblock#tools#Inside()<CR>
vnoremap ai :<c-u>call indentblock#tools#Around()<CR>
vnoremap ij :<c-u>call indentblock#tools#Down()<CR>
vnoremap ik :<c-u>call indentblock#tools#Up()<CR>

" operator-pending
onoremap ii :<c-u>call indentblock#tools#Inside()<CR>
onoremap ai :<c-u>call indentblock#tools#Around()<CR>
onoremap ij :<c-u>call indentblock#tools#Down()<CR>
onoremap ik :<c-u>call indentblock#tools#Up()<CR>

" SETTINGS
let g:indentblock_stop_on_empty = 0
" variables for around mode. extends range from indent#GetRange
" always 1 IMHO
let g:indentblock_linebefore = 1
" set to 0 for python and ansible
let g:indentblock_lineafter = 1
