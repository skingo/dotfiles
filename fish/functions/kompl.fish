function kompl
    if [ (count $argv) = 0 ]
       pushd $kompl
    else if [ (echo $argv | wc -c) = 2 ]
       pushd {$kompl}uebung_0{$argv}
    else
       pushd {$kompl}uebung_{$argv}
    end
end
