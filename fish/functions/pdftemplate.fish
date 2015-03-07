function pdftemplate
	if [ (count $argv) = 2 ]
		if begin ; [ $argv[1] = 'pic' ] ; and  [ $argv[2] = 'long' ] ; end
			cp {$HOME}/Desktop/pdf_template/long_content.tex .
			cp {$HOME}/Desktop/pdf_template/picture.tex .
		else if begin ; [ $argv[1] = 'long' ] ; and  [ $argv[2] = 'pic' ] ; end
			cp {$HOME}/Desktop/pdf_template/long_content.tex .
			cp {$HOME}/Desktop/pdf_template/picture.tex .
		else
			echo 'only \'long\' and \'pic\' allowed as parameters'
			echo 'arguments ignored'
		end
	else if [ (count $argv) = 1 ]
		if [ $argv[1] = 'long' ]
			cp {$HOME}/Desktop/pdf_template/long_content.tex .
		else if [ $argv[1] = 'pic' ]
			cp {$HOME}/Desktop/pdf_template/picture.tex .
        else if [ $argv[1] = 'int' ]
            echo "interactive mode"
            echo "use long content files? (y/n)"
            read answ
            if [ $answ = 'y' ]
                cp {$HOME}/Desktop/pdf_template/long_content.tex .
                echo "using long content files"
            else if [ $answ != 'n' ]
                echo "TODO: repeat"
            else
                echo "using long content files"
            end
		end
	else if [ (count $argv) != 0 ]
		echo 'only \'long\' and \'pic\' allowed as parameters'
		echo 'maximum of two parameters allowed'
	end
	if [ (count $argv) -le 2 ]
		cp {$HOME}/Desktop/pdf_template/main.tex .
		cp {$HOME}/Desktop/pdf_template/macros.tex .
		cp {$HOME}/Desktop/pdf_template/content.tex .
		cp {$HOME}/Desktop/pdf_template/main.tex.latexmain .
		cp {$HOME}/Desktop/pdf_template/makefile .
	end
end
