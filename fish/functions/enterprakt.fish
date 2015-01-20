function enterprakt
    if [ (count $argv) = 0 ]
       pushd $epc_p
    else if [ $argv[1] = '-x' ]
       x3270 &
       if [ (count $argv) = 2 ]
           pushd {$epc_p}UB{$argv[2]}
       end
    else if [ $argv[1] = '-d' ]
       if [ (count $argv) = 2 ]
           pushd {$epc_p}UB{$argv[2]}
       else
           echo "usage: no arguments enters main directory, -x to start x3270 as well, -d x just opens directory UBx"
       end
    else
       echo "usage: no arguments enters main directory, -x to start x3270 as well, -d x just opens directory UBx"
    end
end
