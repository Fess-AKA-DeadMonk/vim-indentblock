function! Selectsome(line_before, line_after)
    let [ start, end ] = [ 3, 4 ]
    execute start - a:line_before
    normal! V
    execute end + a:line_after
endfunction

function! TestReturn()
    return 0
endfunction

function! ComplexConditions(...)
    if a:0 > 0 && a:1
        echo a:1 "true"
        return 1
    elseif a:0 > 0 && ! a:1
        echo a:1 "false"
        return 1
    else
        echom "no args"
        return 1
    endif
endfunction

let s:somelocalvar = "in file script"
let g:somelocalvar = "in file global"
let b:somelocalvar = "in file buffer"
let w:somelocalvar = "in file window"
function! Scoping(...)
    if a:0 > 0
        let varinfunc = a:1
    else
        let varinfunc = VarPrecedence('somelocalvar')
    endif
    echo varinfunc
endfunction

function! VarPrecedence(varname)
    for scope in ['l', 'b', 'g', 's']
        if exists(scope .. ":" .. a:varname)
            execute "let returnval = " .. scope .. ":" .. a:varname
            return returnval
        endif
    endfor
endfunction
