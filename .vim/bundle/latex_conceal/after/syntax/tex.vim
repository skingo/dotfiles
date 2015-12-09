
" copied from 'references' (to avoid lag while editing)
syn match texMathSymbol '\\oplus\>' contained conceal cchar=⊕
syn match texMathSymbol '\\ominus\>' contained conceal cchar=⊖
syn match texMathSymbol '\\otimes\>' contained conceal cchar=⊗

syn match texMathSymbol '\\leftarrow\>' contained conceal cchar=←
syn match texMathSymbol '\\uparrow\>' contained conceal cchar=↑
syn match texMathSymbol '\\rightarrow\>' contained conceal cchar=→
syn match texMathSymbol '\\downarrow\>' contained conceal cchar=↓

syn match texMathSymbol '\\Leftarrow\>' contained conceal cchar=⇐
syn match texMathSymbol '\\Uparrow\>' contained conceal cchar=⇑
syn match texMathSymbol '\\Rightarrow\>' contained conceal cchar=⇒
syn match texMathSymbol '\\Downarrow\>' contained conceal cchar=⇓
syn match texMathSymbol '\\Leftrightarrow\>' contained conceal cchar=⇔

"syn match texMathSymbol '\\Longleftarrow\>' contained conceal cchar=⟸
"syn match texMathSymbol '\\Longrightarrow\>' contained conceal cchar=⟹
"syn match texMathSymbol '\\Longleftrightarrow\>' contained conceal cchar=⟺
"syn match texMathSymbol '\\implies\>' contained conceal cchar=⟹
"syn match texMathSymbol '\\iff\>' contained conceal cchar=⟺

syn match texMathSymbol '\\Longleftarrow\>' contained conceal cchar=⇐
syn match texMathSymbol '\\Longrightarrow\>' contained conceal cchar=⇒
syn match texMathSymbol '\\Longleftrightarrow\>' contained conceal cchar=⇔
syn match texMathSymbol '\\implies\>' contained conceal cchar=⇒
syn match texMathSymbol '\\iff\>' contained conceal cchar=⇔

syn match texMathSymbol '\\land\>' contained conceal cchar=∧
syn match texMathSymbol '\\lor\>' contained conceal cchar=∨

syn match texMathSymbol '\\left\\lvert\>' contained conceal cchar=|
syn match texMathSymbol '\\right\\rvert\>' contained conceal cchar=|
syn match texMathSymbol '\\lvert\>' contained conceal cchar=|
syn match texMathSymbol '\\rvert\>' contained conceal cchar=|

" my own contributions:

syn match texMathSymbol '\\N\>' contained conceal cchar=ℕ
syn match texMathSymbol '\\Z\>' contained conceal cchar=ℤ
syn match texMathSymbol '\\R\>' contained conceal cchar=ℝ
syn match texMathSymbol '\\F\>' contained conceal cchar=ℱ
syn match texMathSymbol '\\Aa\>' contained conceal cchar=𝔄
syn match texMathSymbol '\\A\>' contained conceal cchar=𝒜

syn match texMathSymbol '\\colon\>' contained conceal cchar=:
