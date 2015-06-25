function ubcp
	set new (math 1+$argv)
cp uebung_0$argv/{makefile,*.{h,}tex{,.latexmain}} uebung_0$new
end
