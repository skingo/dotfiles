" vim-rplugin does not work with fish
set shell=/bin/bash
augroup shell
    autocmd!
    autocmd BufEnter *.r set shell=/bin/bash
augroup END

