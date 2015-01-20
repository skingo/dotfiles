" used for complection with neco-ghc
setlocal omnifunc=necoghc#omnifunc
let g:neocomplcache_force_overwrite_completefunc = 1

" used to set up haskellmode
let g:haddock_browser="/usr/bin/firefox"
let g:haddock_docdir="/usr/share/doc/ghc-doc/"

set foldmethod=syntax

" make "sexy" comments look (and behave) better
let NERDSpaceDelims = 1


AddTabularPattern larr /<-
AddTabularPattern arr /->
AddTabularPattern eq /=

