function leist
    if [ (count $argv) = 0 ]
       pushd $leist
    else if [ (echo $argv | wc -c) = 2 ]
       pushd {$leist}uebung_0{$argv}
    else
       pushd {$leist}uebung_{$argv}
    end
end
