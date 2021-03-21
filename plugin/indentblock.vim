" TODO: pass stop_on_empty var.
" possibly unite high-level functions into one?
" extend range for yaml lists-like strings

" MAPPINGS
" visual
vnoremap ii :<c-u>call indent#Inside()<CR>
vnoremap ai :<c-u>call indent#Around()<CR>
vnoremap ij :<c-u>call indent#Down()<CR>
vnoremap ik :<c-u>call indent#Up()<CR>

" operator-pending
onoremap ii :<c-u>call indent#Inside()<CR>
onoremap ai :<c-u>call indent#Around()<CR>
onoremap ij :<c-u>call indent#Down()<CR>
onoremap ik :<c-u>call indent#Up()<CR>

" SETTINGS
let s:indent_stop_on_empty = 0
" variables for around mode. extends range from indent#GetRange
" always 1 IMHO
let s:indent_linebefore = 1
" set to 0 for python and ansible
let s:indent_lineafter = 1
