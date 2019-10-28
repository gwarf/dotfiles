function! mailcomplete#Complete(findstart, base)
    if a:findstart == 1
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx]
            " break on header and previous email
            if c == ':' || c == '>'
                return idx + 2
            else
                continue
            endif
        endwhile
        return idx
    else
        let trim="sed '/^$/d' | cut -f1,2"
        let fmt='awk ''BEGIN{FS=OFS="\t"}{printf "%s <%s>\n", $2, $1}'''
        " Using lbdq
        " return split(system('lbdbq ' .  a:base . '|' . trim . '|' . fmt ), '\n')
        " Using mu
        return split(system('mu cfind --format=mutt-ab ' .  a:base . '|' . trim . '|' . fmt ), '\n')
    endif
endfunc
