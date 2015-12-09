" leader mapped to , -------------{{{
" see if this is useful
let mapleader=','
" to go backwards when using f, F, t, T
nnoremap <C-Q> ,
"}}}

" avoid function key problems when using tmux -----------{{{
if !has("gui_running")
  set term=xterm
endif
"}}}

" typo --------------------------------{{{
command! WQ wq
command! Wq wq
command! W w
command! Q q
command! QA qa
" }}}

" settings ----------------------------{{{
" enable pathogen
if !exists("g:colors_set")
  execute pathogen#infect()
  filetype indent on
  syntax enable
  " opens new split on right/bottom instead of left/top
  set splitbelow
  set splitright
  set nocompatible "keine vi-Kompatibilitaet
  " search treats capital letters as capital, small case as either small or capital
  set ignorecase
  set smartcase
  set smarttab
  set expandtab
  set mouse=nvi "mouse active in normal, visual and insert-mode, alternative: a for 'all'
  set number "line numbering
  set ruler "show position
  set display=lastline
  set scrolloff=2 "scroll when reaching 2 lines before end
  set sidescrolloff=5
  set foldmethod=syntax
  " folds are displayed on margin of width 'foldcolumn'
  set foldcolumn=4
  "set nofoldenable "deactivate folding on startup
  set cmdheight=2 "set height of cmd line to 2
  set cursorline "show cursor position
  set cursorcolumn "set highlighting of cursor column
  set hlsearch "highlight matches of search
  set incsearch "search incrementally while typing
  set backspace=indent,eol,start "mightier backspace
  set laststatus=2 "always show statusline
  set showmatch "hightlight matching parens
  set matchtime=2 "flash for 2 tenths of a second
  set tabstop=4
  set showcmd
  set background=dark
  set wildmenu
  set fileformats+=mac
  set history=1000
  set shiftwidth=4 " sets width for shifting with << or >>
  "and change highlight color
  "highlight CursorColumn ctermbg=Green
  set breakindent " indented lines are wrapped wrt their indentation
endif
" }}}

" git ------------------{{{
command! Gadd !fish -c gitadd
" }}}

" settings for solarized colorscheme (do not move before "settings") ----{{{
let g:colors_set = 1
let g:solarized_termtrans = 1
set t_Co=256 " either t_Co = 256 = g:solarized_termcolors or both set to 16 (default for solarized_termcolors)
"set t_Co=16
"set t_Co=-2
set t_ut=
silent! colorscheme solarized
"let g:solarized_termcolors = 256
" }}}

"" airline settings -------------------------{{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1
"let g:airline_left_sep = ''
"let g:airline_left_sep='▶'
"let g:airline_right_sep='◀'
"" }}}

"" NerdCommenter customization ----------{{{
let g:NERDCustomDelimiters = {
    \ 'fish': { 'left' : '#' },
    \ 'tex': { 'left': '%', 'leftAlt': '\\begin{comment}\r', 'rightAlt': '\r\\end{comment}' },
    \ 'haskell': { 'leftAlt': '{-','rightAlt': '-}', 'left': '-- ', 'right': '' },
\ }
"" make comment env alternate comment for nerdcommenter in tex
"let g:NERDCustomDelimiters = {
            "\ }
"let g:NERDCustomDelimiters
" sexily comment out whole paragraph
nnoremap <leader>cp vip:call NERDComment("x", "Sexy")<CR>
"" }}}

"" Tabularize script for tables, not working -------------------------{{{
"" doesn't work?
"inoremap <silent> &   &<Esc>:call <SID>align()<CR>a

"function! s:align()
    "let p = '^[^&]*\s&\s.*\s&\s[^&]*$'
    "if exists(':Tabularize') && getline('.') =~# '^[^&]*\s&' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        "let column = strlen(substitute(getline('.')[0:col('.')],'[^&]','','g'))
        "let position = strlen(matchstr(getline('.')[0:col('.')],'.*&\s*\zs.*'))
        "Tabularize/&/l1
        "normal! 0
        "call search(repeat('[^&]*&',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    "endif
"endfunction
"" }}}

" make vim use marker folding in vim-files --------------------------{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd BufNew,BufRead *.latexmain set filetype=vim
augroup END
" }}}

"" make gitcommit messages non-folding -------------------------------{{{
"augroup filetype_gitcommit
    "autocmd!
    "autocmd FileType gitcommit setlocal nofoldenable
"augroup END
"" }}}

" use cool ghci shortcuts when in xmonad tmux session ----------------{{{
augroup xmonad
    autocmd!
    autocmd BufRead xmonad.hs nnoremap <leader>ghci :execute '!tmux send-keys -t bottom-left "'@t'" Enter &'<CR><CR>
    autocmd BufRead xmonad.hs vnoremap <leader>ghci "ty:execute '!tmux send-keys -t bottom-left "'escape(@t,'"')'" Enter &'<CR><CR>
augroup END
" }}}

"" statusline -----------------{{{
"" from https://github.com/spf13/spf13-vim/blob/master/.vimrc
"" not used due to usage of airline
"if has('statusline')
    "set laststatus=2
    "" Broken down into easily includeable segments
    "set statusline=[%n]%M " buffer number and modified flag
    "set statusline+=\ %f\ " Filename
    "set statusline+=%<%w%h%m%r " Options
    "set statusline+=-\ Filetype:[%{&ff}/%Y] " filetype
    "set statusline+=\ [%.100{getcwd()}] " current dir
    "set statusline+=%=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    "set statusline+=%*
    "let g:syntastic_enable_signs=1
    "set statusline+=\ line:%l/%L\ col:%-4c\ \ %p%% " Right aligned file nav info
    ""set statusline+=\ line:%l/%L\ col:%c\ \ \ \ \ \ %p%% " Right aligned file nav info
"endif
"" }}}

" gundo -------------------{{{
nnoremap <F4> :GundoToggle<CR>
" }}}

" shortcuts for changing vimrc and for help files -----------{{{
" source $MYVIMRC reloads the saved $MYVIMRC
 nnoremap <Leader>ss :source $MYVIMRC<CR>
 " opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
 nnoremap <Leader>v :vsplit $MYVIMRC<CR>
 nnoremap <Leader>tag <C-]>
 " <Leader> is \ by default, so those commands can be invoked by doing \v and \s
" }}}

" movement additions (operator pending mappings) --------------------{{{
" new movements ('din(' deletes inside next parenthees)
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap in) :<c-u>normal! f(vi(<cr>
onoremap il) :<c-u>normal! F)vi(<cr>
onoremap in} :<c-u>normal! f{vi{<cr>
onoremap il} :<c-u>normal! F}vi{<cr>
" using '[' interferes with native mappings
onoremap in] :<c-u>normal! f[vi[<cr>
onoremap il] :<c-u>normal! F]vi[<cr>
" }}}

" miscellaneous ----------------{{{
" grep for word under cursor in current dir
" moved to ~/.vim/plugin/grep-operator.vim with additional functionality
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>:redraw!<CR>

" change visual mode to not include EOL (default is 'inclusive')
set selection=old

" cool shortcut for fast global search
nnoremap <leader>/ :%s//g<Left><Left>

" use ctrl j and k to scroll through command history (mind that q: is a good
" option too)
cnoremap <C-K> <Up>
cnoremap <C-J> <Down>
cnoremap <C-L> <Right>
cnoremap <C-H> <Left>

" use Y to yank text of line instead of whole line
nnoremap Y ^y$

" use . in normal mode (does this not work normally?)
vnoremap . :normal! .<CR>

let g:bufferline_echo=0

" patterns not expanded by wildcards
set wildignore=*.o,*.pdf,*.exe,*.png

" make minibufexpl appear on top instead of bottom (bottom is induced by splitbelow option)
let g:miniBufExplBRSplit=0
nnoremap <F8> :MBEToggle<CR>:MBEFocus<CR>

"nnoremap <Leader>vv :!clear<CR>
" redraw screen
nnoremap <Leader>red :redraw!<CR>

" move line up or down
nnoremap - ddp
nnoremap _ ddkP
" move to next/previous buffer
nnoremap <b :bprevious<CR>
nnoremap <B :bnext<CR>
nnoremap >B :bnext<CR>
" move to next/previous match in quickfix
nnoremap <c :cprevious<CR>
nnoremap <C :cnext<CR>
nnoremap >C :cnext<CR>

" folding with f9 key
inoremap <F10> <C-O>za
nnoremap <F10> za
onoremap <F10> <C-C>za
vnoremap <F10> zf

"alternate way to quit insert mode
inoremap jj <Esc>jj
inoremap kk <Esc>kk

"copy to clipboard in visual mode
vnoremap <C-C> "+y
"paste from clipboard in visual or normal mode
" does not work due to missing +clipboard option in current vim version
" uncommenting these will lead to conflict with window maximazation command
"nnoremap <C-P> "+P
"vnoremap <C-P> "+P

""change tabs
""noremap <C-H> gT
""noremap <C-L> gt
"" change splits instead
"nnoremap <C-H> :wincmd h<CR>
"nnoremap <C-L> :wincmd l<CR>
"" no more clash with latex IMAP_JumpForward, since other mapping was set in
"" plugin/imaps.vim
""nnoremap <C-F> :wincmd j<CR>
"nnoremap <C-J> :wincmd j<CR>
"nnoremap <C-K> :wincmd k<CR>
"nnoremap <C-P> :wincmd _ <bar> wincmd <bar><CR>

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-H> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent> <C-K> :TmuxNavigateUp<CR>
nnoremap <silent> <C-J> :TmuxNavigateDown<CR>
inoremap <silent> <C-H> <Esc>:TmuxNavigateLeft<CR>
inoremap <silent> <C-L> <Esc>:TmuxNavigateRight<CR>
inoremap <silent> <C-K> <Esc>:TmuxNavigateUp<CR>
inoremap <silent> <C-J> <Esc>:TmuxNavigateDown<CR>

" ctrl k switches splitted windows
" nnoremap <C-K> :wincmd w<CR>
" ctrl a closes quickfix and locations
nnoremap <C-A> :ccl<bar>:lcl<CR>
" let ctrl s do ctrl a's old job instead (increment numbers)
nnoremap <C-S> <C-A>


"highlight parentheses etc
nnoremap <C-Y>9 m[va(:sleep 450m<CR>`[
inoremap <C-Y>9 <Esc>m[va(:sleep 450m<CR>`[a
nnoremap <C-Y>0 m[va{:sleep 450m<CR>`[
inoremap <C-Y>0 <Esc>m[va{:sleep 450m<CR>`[a
nnoremap <C-Y>[ m[va[:sleep 450m<CR>`[
inoremap <C-Y>[ <Esc>m[va[:sleep 450m<CR>`[a

"make ![cmd] work (doesn't work with fish)
"set shell=bash
function! ToggleShell()
  if &shell ==? "/usr/bin/fish"
    let l:shell="/bin/bash"
  else
    let l:shell="/usr/bin/fish"
  endif
  execute 'echom "shell set to ' . l:shell . '"'
  execute 'set shell=' . l:shell
endfunction
nnoremap <leader>aa :call ToggleShell()<CR>
nnoremap <leader>sh :shell<CR>

" }}}

" set options for using gvim -----------------{{{
if has("gui_running")
    " GUI is running or is about to start.
    " Maximize gvim window.
    set lines=55 columns=180
    "colorscheme koehler
    colorscheme solarized
    set guifont=Liberation\ Mono\ for\ Powerline\ 10
endif
" }}}

" Tabularize shortcuts ----------{{{
if exists(":Tabularize")
    nnoremap <Leader>w= :Tabularize /=<CR>
    vnoremap <Leader>w= :Tabularize /=<CR>
    nnoremap <Leader>w. :Tabularize /:\zs<CR>
    vnoremap <Leader>w. :Tabularize /:\zs<CR>
    nnoremap <Leader>w-> :Tabularize /->\zs<CR>
    vnoremap <Leader>w-> :Tabularize /->\zs<CR>
    nnoremap <Leader>w<- :Tabularize /<-\zs<CR>
    nnoremap <Leader>w<- :Tabularize /<-\zs<CR>
    vnoremap <Leader>w, :Tabularize /,\zs<CR>
    vnoremap <Leader>w, :Tabularize /,\zs<CR>
endif
" }}}

" NERDtree customization ----------------{{{
" toggle the NERDTree
nnoremap <F3> :NERDTreeToggle<CR>
" bookmarks are always shown
let NERDTreeShowBookmarks=1
" }}}

" haskell autocommands ---------{{{
augroup haskell
    autocmd Bufenter *.hs compiler ghc
augroup END
" }}}

" tslime config ------------------{{{
vmap <C-C><C-C> <Plug>SendSelectionToTmux
" does not work this way, needs fixing:
"vmap <C-C><C-x> <Plug>SendSelectionToTmux :call SendToTmux("\r")<CR>
nmap <C-C><C-C> <Plug>NormalModeSendToTmux
nmap <C-C>r <Plug>SetTmuxVars
" }}}

" function to set cwd to filepath ----{{{
function! SetCwd()
    execute "cd " . expand('%:p:h')
endfunction
" }}}

" hack: let vim realize the alt key in bash ------------------{{{
"let c='a'
"while c <= 'z'
    "exec "set <m-".c.">=\e".c
    "exec "imap \e".c." <m-".c.">"
    "let c = nr2char(1+char2nr(c))
"endw
"set timeout ttimeoutlen=50
"noremap <m-h> <g>
"noremap <m-l> <Right>
" }}}

" NERDTress File highlighting --------------------------------{{{
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('tex', 'red', 'none', 'green', '#151515')
call NERDTreeHighlightFile('pdf', 'DarkMagenta', 'none', 'green', '#151515')
call NERDTreeHighlightFile('png', 'DarkGreen', 'none', 'green', '#151515')
call NERDTreeHighlightFile('jpg', 'DarkGreen', 'none', 'green', '#151515')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('makefile', 'White', 'none', '#686868', '#151515')
"}}}

" customize devicons ----------------{{{
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pdf']=''

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tex']=''
"}}}

" adapt vim-detach to fish ---{{{
function! s:MMake(bang, args)
    set shell=/bin/bash
    execute "Make" . a:bang . " " . a:args
    set shell=/usr/bin/fish
endfunction
command! -bang -nargs=* -complete=custom,s:MMake_complete MMake call s:MMake("<bang>", "<args>")

function! s:MMake_complete(ArgLead, CmdLine, CurserPos)
  "let l:targets=split(system("cut -d':' makefile"), "\n")
  if filereadable("makefile")
    let l:targets=system("cut -d':' -f1 -s makefile | grep -v -E '^\\.|^\\$'")
  else
    let l:targets=""
  endif
  return l:targets
endfunction

function! s:DDispatch(bang, args)
    set shell=/bin/bash
    execute "Dispatch" . a:bang . " " . a:args
    set shell=/usr/bin/fish
endfunction
command! -bang -nargs=* DDispatch call s:DDispatch("<bang>", "<args>")

function! s:FFocusDispatch(bang, args)
    set shell=/bin/bash
    execute "Dispatch" . a:bang . " " . a:args
    set shell=/usr/bin/fish
endfunction
command! -bang -nargs=* FFocusDispatch call s:FFocusDispatch("<bang>", "<args>")

function! s:SStart(bang, args)
    set shell=/bin/bash
    execute "Dispatch" . a:bang . " " . a:args
    set shell=/usr/bin/fish
endfunction
command! -bang -nargs=* SStart call s:SStart("<bang>", "<args>")

function! s:SSpawn(bang, args)
    set shell=/bin/bash
    execute "Dispatch" . a:bang . " " . a:args
    set shell=/usr/bin/fish
endfunction
command! -bang -nargs=* SSpawn call s:SSpawn("<bang>", "<args>")
"}}}

"================use mkview to save folds etc================================

" use mkview to save folds etc ------------{{{
" mainly saves folds to ~/.vim/view/
"autocmd BufWinLeave * mkview
"autocmd BufWinEnter * silent loadview

"instead (to avoid error messages in quickfix and such)

let g:skipview_files = [
            \ '[EXAMPLE PLUGIN BUFFER]'
            \ ]
function! MakeViewCheck()
    if has('quickfix') && &buftype =~ 'nofile'
        " Buffer is marked as not a file
        return 0
    endif
    if empty(glob(expand('%:p')))
        " File does not exist on disk
        return 0
    endif
    if len($TEMP) && expand('%:p:h') == $TEMP
        " We're in a temp dir
        return 0
    endif
    if len($TMP) && expand('%:p:h') == $TMP
        " Also in temp dir
        return 0
    endif
    if expand('%:p:h') == '/usr/share/vim/vim74/doc'
        " help files should be skipped
        return 0
    endif
    "if expand('%:p:h:h') == '/home/skinge/.vim' || expand('%:p:h:h:h') == '/home/skinge/.vim' || expand('%:t') == '.vimrc'
    if expand('%:t') == '.vimrc'
        " so should vim files
        return 0
    endif
    if &filetype == 'gitcommit' || &filetype == 'nerdtree'
        " git commit messages should also be skipped
        return 0
    endif
    if index(g:skipview_files, expand('%')) >= 0
        " File is in skip list
        return 0
    endif
    if expand('%:p') == '/home/skinge/.xmonad/xmonad.hs' || expand('%:p') == '/home/skinge/dotfiles/.xmonad/xmonad.hs'
        " we are in a xmonad config file
        return 0
    endif
    return 1
endfunction
augroup vimrcAutoView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePost,BufLeave,WinLeave ?* if MakeViewCheck() | mkview | endif
    autocmd BufWinEnter ?* if MakeViewCheck() | silent loadview | endif
augroup end
" }}}

"================Vim-Latex===================================================

" Vim-Latex -------------------------{{{
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
"set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" }}}

"================NeoComplCache===============================================

" NeoComplCache ---------------------{{{
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
"" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ?
    neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><g> neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up> neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down> neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre =
1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
augroup neocompl
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^.
            \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" }}}

"============================================================================



