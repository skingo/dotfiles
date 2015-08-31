function ubcp
	set new (math 1+$argv)
cp uebung_$argv/{makefile,*.{h,}tex{,.latexmain}} uebung_$new
end
