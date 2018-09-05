function! s:check_python()
    if did_filetype()
        return
    endif
    if getline(1) =~# '^#!.*python'
        setfiletype python
    endif
endfunction

call s:check_python()
