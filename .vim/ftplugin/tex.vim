" this is mostly a matter of taste. but LaTeX looks good with just a bit
" " of indentation.
set shiftwidth=2
set tabstop=2
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

" stop miniBufExpl from opening while editing
let g:miniBufExplAutoStart=0

let g:Tex_DefaultTargetFormat = 'pdf'
" syntastic ignores Warnings generated by use of german quotes
let g:syntastic_quiet_messages = {"regex": 'Use either ``' }

let g:Tex_ViewRuleComplete_pdf = 'xdg-open $*.pdf >/dev/null 2>&1 &'

" "untab" two spaces
inoremap <S-Tab> <BS><BS>

nnoremap <silent> <Leader>no mX/xxfoobarxx<CR>`X:nohlsearch

" `w makes \omega instead of \wedge
call IMAP('`w', '\omega', 'tex')

" get item easily
call IMAP('II', '\item <++>', 'tex')

" easy align* environment
call IMAP('EAG', "\\begin{align*}\n<++>\n\\end{align*}", 'tex')

" change section commands to use starred version
call IMAP('SSE', '\section*{<++>}', 'tex')
call IMAP('SSS', '\subsection*{<++>}', 'tex')
call IMAP('SS2', '\subsubsection*{<++>}', 'tex')

call IMAP('~~', '\approx ', 'tex')
call IMAP('`°', '^\circ ', 'tex')
call IMAP('`0', '\emptyset ', 'tex')
call IMAP('`(', '\subseteq ', 'tex')
call IMAP('`)', '\supseteq ', 'tex')
call IMAP('`E', '\exists ', 'tex')
call IMAP('`A', '\forall ', 'tex')
call IMAP('=>', '\implies ', 'tex')
call IMAP('<=>', '\iff ', 'tex')


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

