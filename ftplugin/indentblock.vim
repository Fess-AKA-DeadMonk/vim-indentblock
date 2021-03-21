augroup vim_indent
    autocmd!
    autocmd FileType yaml,yaml.ansible,yml,python let b:indent_lineafter = 0
augroup END
