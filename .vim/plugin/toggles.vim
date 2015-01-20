
nnoremap <leader>f :call <SID>FoldColumnToggle()<CR>
nnoremap <leader>q :call <SID>QuickFixToggle()<CR>

function! s:FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

let g:quickfix_is_open = 0
    
function! s:QuickFixToggle()
    if g:quickfix_is_open 
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

