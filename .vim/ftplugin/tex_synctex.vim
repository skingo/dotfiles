"""""""""""""""""""""""""""""""""""""""""""""""""
" Default compiling format
let g:Tex_DefaultTargetFormat='pdf'


" Never Forget, To set the default viewer:: Very Important
let g:Tex_ViewRule_pdf = 'zathura'

" Trying to add same for pdfs, hoping that package SynTex is installed
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'


" Get the correct servername, which should be the filename of the tex file,
" without the extension.
" Using the filename, without the extension, not in uppercase though, but
" that's okay for a servername, it automatically get uppercased
"let theuniqueserv = expand("%:r")
"let theuniqueserv = "MAIN"
let theuniqueserv = v:servername

" Working!!!, when we run vim appropriately
let g:Tex_ViewRuleComplete_pdf = 'zathura -x "vim --servername '.theuniqueserv.' --remote +\%{line} \%{input}" "$*".pdf 2>/dev/null &'
"let g:Tex_ViewRuleComplete_pdf = 'zathura -x "vim --remote +\%{line} \%{input}" $*.pdf 2>/dev/null &'

" I like my sums and limits to have placeholders
"let g:Tex_Com_sum = "\\sum\\limits\_{<++>}\^{<++>}<++>"
"let g:Tex_Com_cap = "\\bigcap\\limits\_{<++>}\^{<++>}<++>"
"let g:Tex_Com_cup = "\\bigcup\\limits\_{<++>}\^{<++>}<++>"
"let g:Tex_Com_lim = "\\lim\\limits\_{<++>}\^{<++>}<++>"

" Forward search
" syntax for zathura: zathura --synctex-forward 193:1:paper.tex paper.pdf
function! SyncTexForward()
        let execstr = 'silent! !zathura --synctex-forward '.line('.').':1:"'.expand('%').'" "'.expand("%:p:h").'"/main.pdf 2>/dev/null'
        execute execstr
endfunction
nmap <silent> <Leader>f :call SyncTexForward()<CR>:redraw!<CR>

" To save and compile with one command \k (k=kompile) :)
" no need to launch the pdf along with this because zathura can refresh
" itself after every compilation produces a new pdf, so \k is enough
"nmap k :w ll

" I will just reamp this \lv thing to \v just to be consistent with \k and \f
"nmap v lv
