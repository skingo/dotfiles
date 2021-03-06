" this is mostly a matter of taste. but LaTeX looks good with just a bit
" " of indentation.
set shiftwidth=2
set tabstop=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
" additionally, this allows to treat \commands as whole words
set iskeyword+=:,\

" hightlight todos in tex code
match ErrorMsg /\v\c(\\)?todo/
2match pandocDefinitionTerm /\\todo\(\[[^]]*]\)\?{\zs[^}]*\ze}/

" use K to access Tex documentations
"set keywordprg=tex-keywordprg
set keywordprg=texdoc

"let g:neocomplcache_keyword_patterns.tex='\\\a{\a\{1,2}}\|\\[[:alpha:]äöüÜÄÖß@][[:alnum:]äöüÜÄÖß@]*\%({\%([[:alnum:]äöüÜÄÖß:_]\+\*\?}\?\)\?\)\?\|\a[[:alnum:]äöüÜÄÖß:_]*\*\?'
"let g:neocomplcache_keyword_patterns.tex='\\\a{\a\{1,2}}\|\\[[:alpha:]äöüÜÄÖß@][[:alnum:]äöüÜÄÖß@]*\%({\%([[:alnum:]äöüÜÄÖß:_]\+\*\?}\?\)\?\)\?\|[[:alpha:]äöüÜÖÄß][[:alnum:]äöüÜÄÖß:_]*\*\?'
"let g:neocomplete#keyword_patterns.tex='\\\a{\a\{1,2}}\|\\[[:alpha:]äöüÜÄÖß@][[:alnum:]äöüÜÄÖß@]*\%({\%([[:alnum:]äöüÜÄÖß:_]\+\*\?}\?\)\?\)\?\|[[:alpha:]äöüÜÖÄß][[:alnum:]äöüÜÄÖß:_]*\*\?'

"" stop miniBufExpl from opening while editing
"let g:miniBufExplAutoStart=0

"removes ] and } from indentkeys (set by "indent/tex.vim") to get rid of
"annoying reindenting after using } or ]
let &indentkeys=substitute(&indentkeys, ',},', ',', 'g')
let &indentkeys=substitute(&indentkeys, ',],', ',', 'g')
"execute "setlocal indentkeys=" . &indentkeys

let g:Tex_DefaultTargetFormat = 'pdf'
" syntastic ignores Warnings generated by use of german quotes
"let g:syntastic_quiet_messages = {"regex": 'Use either ``',
                                  "\ "regex": 'You should enclose',
                                  "\ "regex": 'possible unwanted space at',
                                  "\  }
let g:syntastic_quiet_messages = {"regex": 'Use either ``\|possible unwanted space at', }
" might want to use 'You should enclose\|' as well...

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

"let g:Tex_ViewRuleComplete_pdf = 'xdg-open $*.pdf >/dev/null 2>&1 &'

" highlighting sometimes)
nnoremap <silent> <leader>no :let @/='@@'<CR>
"nnoremap <silent> <leader>no :execute ":silent! normal! mX/xx[f]oobarxx\r`X"<CR>
"nnoremap <silent> <Leader>no mX/xxfoobarxx<CR>`X:nohlsearch

function! Clear_highlighting()
    let l:search_backup=@/
    execute ":silent! normal! mX/xx[f]oobarxx\r`X"
    let @/=l:search_backup
endfunction

"----------------------------------------
" macros that overwrite plugin          "
" defaults need to be stored in         "
" $VIMDIR/after/ftplugin/tex_macros.vim "
"----------------------------------------

" now moved to plugin vim-textobj-user in conjuction with vim-textobj-latex plugin
" useful for yi$, da$ etc
"onoremap a$ :<c-u>normal! F$vf$<cr>
"onoremap i$ :<c-u>normal! T$vt$<cr>
"cnoremap w w | Errors

" get item easily
call IMAP('II', '\item<++>', 'tex')

" easy align* environment
call IMAP('EAG', "\\begin{align*}\n<++>\n\\end{align*}", 'tex')
call IMAP('todo', "\\todo[<++>]{<++>}", 'tex')

call IMAP('~~', '\approx', 'tex')
call IMAP('`°', '^\circ', 'tex')
call IMAP('`E', '\exists ', 'tex')
call IMAP('`A', '\forall ', 'tex')
call IMAP('=>', '\implies ', 'tex')
call IMAP('<=>', '\iff ', 'tex')
"call IMAP('->', '\to ', 'tex')
call IMAP('-->', '\mapsto ', 'tex')
call IMAP('<->', '\leftrightarrow ', 'tex')

call IMAP('m|', '\midd ', 'tex')

call IMAP('||', '\left\lvert <++> \right\rvert<++>', 'tex')
call IMAP('<<', '\left\langle <++> \right\rangle<++>', 'tex')

" use german quotation marks instead of english ones:
"let g:Tex_SmartQuoteOpen = ",,"
"let g:Tex_SmartQuoteClose = "``"
let g:Tex_SmartQuoteOpen = "\"`"
let g:Tex_SmartQuoteClose = "\"'"
" to explicitly set english quotation marks use
"let g:Tex_SmartQuoteOpen = "``"
"let g:Tex_SmartQuoteClose = "''"

inoremap <F6> <Esc>:TMacro<CR>
nnoremap <F6> :TMacro<CR>


" enables the "conceal" feature
set cole=2
let g:tex_conceal="agmbs"
hi clear Conceal
hi link Conceal texMath
hi Conceal ctermfg=blue
" renew colorscheme to get correct color of conceal characters (ctemfg=blue)
set background=dark
"" alternative that induces prompt of "solarized\nsolarized" every time a tex
"" file is opened
"redir @x
"colorscheme
"redir END
"if @x =~? 'solarized'
    "silent colorscheme solarized
"endif
"colorscheme g:colors_name

" to add symbols to one of the groups Greek, Accent (ä etc), Delimiter,
" MathSymbol or Superscript (I hope these names are right) do this:
"syn match texMathSymbol '\\arr\>' contained conceal cchar=←

"inoremap <silent> &   &<Esc>:call <SID>align()<CR>a

"function! s:align()
    "let p = '^\s*&\s.*\s&\s*$'
    "if exists(':Tabularize') && getline('.') =~# '^\s*&' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        "let column = strlen(substitute(getline('.')[0:col('.')],'[^&]','','g'))
        "let position = strlen(matchstr(getline('.')[0:col('.')],'.*&\s*\zs.*'))
        "Tabularize/&/l1
        "normal! 0
        "call search(repeat('[^&]*&',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    "endif
"endfunction

"inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

"function! s:align()
    "let p = '^\s*|\s.*\s|\s*$'
    "if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        "let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        "let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        "Tabularize/|/l1
        "normal! 0
        "call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    "endif
"endfunction

