function gitadd --description 'add all files in gitadd file'
	
		#set gitadd ""
	#else if [ (count (ls ../.git ^/dev/null)) -ge 1 ]
		#set gitadd ../
	#else if [ (count (ls ../../.git ^/dev/null)) -ge 1 ]
		#set gitadd ../../
	#end
	#for file in (cat {$gitaddpref}.gitadd) 
		#git add {$gitaddpref}{$file}
	#end
	if [ (count (ls .git ^/dev/null)) -ge 1 ]
		set count 0
	else if [ (count (ls ../.git ^/dev/null)) -ge 1 ]
		set count 1
		pushd ../
	else if [ (count (ls ../../.git ^/dev/null)) -ge 1 ]
		set count 1
		pushd ../../
	end
	git add (cat .gitadd)
	git status
	if [ $count -ge 1 ]
		popd
	end
end
