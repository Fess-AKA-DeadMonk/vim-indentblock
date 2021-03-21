function! indentblock#tools#VarPrecedence(varname)
    " local -> buffer -> global -> script
    " ignore window scope
    for scope in ['l', 'b', 'g', 's']
        if exists(scope .. ":" .. a:varname)
            execute "let returnval = " .. scope .. ":" .. a:varname
            return returnval
        endif
    endfor
    throw a:varname .. " undefined"
endfunction

function! indentblock#tools#CheckLine(linenum, regex, stop_on_empty)
    let line_contents = getline(a:linenum)
    if line_contents =~ a:regex
        return 1
    elseif ! a:stop_on_empty && line_contents =~ '^$'
        return 1
    endif
    return 0
endfunction

function! indentblock#tools#LookUp(indent_regex, stop_on_empty)
    let curline = line('.')
    while curline > 1
        if ! indentblock#tools#CheckLine(curline - 1, a:indent_regex, a:stop_on_empty)
            break
        endif
        let curline -= 1
    endwhile
    return curline
endfunction

function! indentblock#tools#LookDown(indent_regex, stop_on_empty)
    let curline = line('.')
    while curline < line('$')
        if ! indentblock#tools#CheckLine(curline + 1, a:indent_regex, a:stop_on_empty)
            break
        endif
        let curline += 1
    endwhile
    return curline
endfunction

function! indentblock#tools#GetRange(look_up, look_down, ...)
    if a:0 > 0
        let stop_on_empty = a:1
    else
        let stop_on_empty = indentblock#tools#VarPrecedence('indentblock_stop_on_empty')
    endif

    normal! ^
    let indentsize = col('.') - 1
    let indentregex = '^' .. repeat(' ', indentsize) .. '.*'
    let startline = line('.')

    if a:look_up
        let rangestart = indentblock#tools#LookUp(indentregex, stop_on_empty)
    else
        let rangestart = startline
    endif

    if a:look_down
        let rangestop = indentblock#tools#LookDown(indentregex, stop_on_empty)
    else
        let rangestop = startline
    endif

    return [rangestart, rangestop, indentsize, startline]
endfunction

function! indentblock#tools#Select(start, end)
    execute a:start
    execute "normal! vV"
    execute a:end
endfunction

function! indentblock#tools#Inside()
    let [rangestart, rangestop, indentsize, startline] = indentblock#tools#GetRange(1, 1)
    call indentblock#tools#Select(rangestart, rangestop)
endfunction

function! indentblock#tools#Around()
    let [rangestart, rangestop, indentsize, startline] = indentblock#tools#GetRange(1, 1)
    let indent_lineafter = indentblock#tools#VarPrecedence('indentblock_lineafter')
    let indent_linebefore = indentblock#tools#VarPrecedence('indentblock_linebefore')
    call indentblock#tools#Select(rangestart - indent_linebefore, rangestop + indent_lineafter)
endfunction

function! indentblock#tools#Down()
    let [rangestart, rangestop, indentsize, startline] = indentblock#tools#GetRange(0, 1)
    call indentblock#tools#Select(rangestart, rangestop)
endfunction

function! indentblock#tools#Up()
    let [rangestart, rangestop, indentsize, startline] = indentblock#tools#GetRange(1, 0)
    call indentblock#tools#Select(rangestart, rangestop)
endfunction

