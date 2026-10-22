function rv -d "Start a PAI session reviewing the given MR/PR URL(s)"
    if test (count $argv) -eq 0
        echo "usage: rv <mr-or-pr-url>..." >&2
        return 1
    end
    pai -i "Review $argv"
end
