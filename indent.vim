" mappings
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

augroup vim_indent
    autocmd!
    autocmd FileType yaml,yaml.ansible,yml,python let b:indent_lineafter = 0

augroup END

" settings
let s:indent_stop_on_empty = 0
" variables for around mode. extends range from indent#GetRange
" always 1 IMHO
let s:indent_linebefore = 1
" set to 0 for python and ansible
let s:indent_lineafter = 1


function! indent#VarPrecedence(varname)
    " local -> buffer -> global -> script
    " ignore window scope
    for scope in ['l', 'b', 'g', 's']
        if exists(scope .. ":" .. a:varname)
            execute "let returnval = " .. scope .. ":" .. a:varname
            return returnval
        endif
    endfor
    throw varname .. " undefined"
endfunction

function! indent#CheckLine(linenum, regex, stop_on_empty)
    let line_contents = getline(a:linenum)
    if line_contents =~ a:regex
        return 1
    elseif ! a:stop_on_empty && line_contents =~ '^$'
        return 1
    endif
    return 0
endfunction

function! indent#LookUp(indent_regex, stop_on_empty)
    let curline = line('.')
    let rangestart = curline
    while curline > 0
        if ! indent#CheckLine(curline - 1, a:indent_regex, a:stop_on_empty)
            let rangestart = curline
            break
        endif
        let curline -= 1
    endwhile
    return rangestart
endfunction

function! indent#LookDown(indent_regex, stop_on_empty)
    let curline = line('.')
    let rangestop = curline
    while curline <= line('$')
        if ! indent#CheckLine(curline + 1, a:indent_regex, a:stop_on_empty)
            let rangestop = curline
            break
        endif
        let curline += 1
    endwhile
    return rangestop
endfunction

function! indent#GetRange(look_up, look_down, ...)
    if a:0 > 0
        let stop_on_empty = a:1
    else
        let stop_on_empty = indent#VarPrecedence('indent_stop_on_empty')
    endif

    normal! ^
    let indentsize = col('.') - 1
    let indentregex = '^' .. repeat(' ', indentsize) .. '.*'
    let startline = line('.')

    if a:look_up
        let rangestart = indent#LookUp(indentregex, stop_on_empty)
    else
        let rangestart = startline
    endif

    if a:look_down
        let rangestop = indent#LookDown(indentregex, stop_on_empty)
    else
        let rangestop = startline
    endif

    return [rangestart, rangestop, indentsize, startline]
endfunction

function! indent#Select(start, end)
    execute a:start
    normal! V
    execute a:end
endfunction

function! indent#Inside()
    let [rangestart, rangestop, indentsize, startline] = indent#GetRange(1, 1)
    call indent#Select(rangestart, rangestop)
endfunction

function! indent#Around()
    let [rangestart, rangestop, indentsize, startline] = indent#GetRange(1, 1)
    let indent_lineafter = indent#VarPrecedence('indent_lineafter')
    let indent_linebefore = indent#VarPrecedence('indent_linebefore')
    call indent#Select(rangestart - indent_linebefore, rangestop + indent_lineafter)
endfunction

function! indent#Down()
    let [rangestart, rangestop, indentsize, startline] = indent#GetRange(0, 1)
    call indent#Select(rangestart, rangestop)
endfunction

function! indent#Up()
    let [rangestart, rangestop, indentsize, startline] = indent#GetRange(1, 0)
    call indent#Select(rangestart, rangestop)
endfunction

