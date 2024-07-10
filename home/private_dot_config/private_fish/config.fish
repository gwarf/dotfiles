# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

set -U fish_term24bit 1

# if status is-login; and begin
# Login shell initialisation
# end

if status is-interactive
    # Commands to run in interactive sessions can go here

    set -g fish_greeting ""
    # XXX: to be checked
    # thefuck --alias | source

    # Use bat as pager
    set -gx PAGER bat
    # https://unix.stackexchange.com/questions/343168/can-i-prevent-service-foo-status-from-paging-its-output-through-less
    set -gx SYSTEMD_PAGER bat
    set -gx MANPAGER "nvim +Man!"

    # Disable cowsay for Ansible
    set -gx ANSIBLE_NOCOWS 1

    # Abbreviations
    abbr -a :q exit
    abbr -a g git

    #  Aliases
    alias cat="bat --paging=never"
    alias ls="lsd --group-directories-first"
    alias lsa="lsd --group-directories-first --almost-all"
    alias l="lsd --group-directories-first --long --date '+%F %T'"
    alias la="lsd --group-directories-first --long --date '+%F %T' --almost-all"
    alias ld="fd . --type d --max-depth 1 --strip-cwd-prefix --exec-batch lsd --directory-only"
    alias ..="cd .."
    alias rm="rm -i --preserve-root"
    alias mv="mv -i"
    alias cp="cp -i"
    alias chown="chown --preserve-root"
    alias chmod="chmod --preserve-root"
    alias chgrp="chgrp --preserve-root"

    if test (uname) = Darwin
        # Add path mainly used by brew
        fish_add_path /usr/local/bin

        # Add nix directories to path missing in current kitty config
        fish_add_path "~/.nix-profile/bin"
        fish_add_path "/etc/profiles/per-user/$USER/bin"
        fish_add_path /run/current-system/sw/bin
        fish_add_path /nix/var/nix/profiles/default/bin

        # https://spicetify.app
        if test -e ~/.spicetify
            fish_add_path ~/.spicetify/
        end

        if test -e ~/perl5/perlbrew/etc/perlbrew.fish
            . ~/perl5/perlbrew/etc/perlbrew.fish
        end

        # XXX: disabled
        # Favor using llvm stuff from homebrew
        # clang-15: unknown argument -02
        # set -gx CFLAGS "-02 -I/usr/local/opt/openssl/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
        # set -gx CFLAGS "-I/usr/local/opt/openssl/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
        # set -gx CPPFLAGS "-I/usr/local/opt/llvm/include"
        # set -gx LDFLAGS "-L/usr/local/opt/openssl/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++"
        # fish_add_path "/usr/local/opt/llvm/bin"

        # FIXME: not working for getting norg-treesitter to build
        # Use clang/llvm as main compiler
        # set -gx CC clang
        # set -gx CXX clang++
        # set -gx COMPILER clang++

        # Use gcc12 from homebrew to build neorg treesitter
        # set -gx CC /usr/local/bin/gcc-12

        # XXX: not working
        # Use clang++ from system with recent C++ version to build neorg treesitter
        # set -gx CC "/usr/bin/clang++ -std=c++17"

        # XXX: not working
        # Use clang++ from system with recent C++ version to build neorg treesitter
        # function nvim
        #   env CC="/usr/bin/clang++ -std=c++17" /etc/profiles/per-user/$USER/bin/nvim $argv
        # end

        # XXX: not working
        # function vim
        #   env CC="/usr/bin/clang++ -std=c++17" /etc/profiles/per-user/$USER/bin/nvim $argv
        # end

        # Load pyenv
        # https://github.com/pyenv/pyenv/wiki/Common-build-problems
        set -x PYENV_ROOT $HOME/.pyenv
        fish_add_path $PYENV_ROOT/bin
        pyenv init - | source

        # Load custon pytyon3 venv for mutt + ical
        function mutt
            source ~/.config/neomutt/.venv/bin/activate.fish
            /etc/profiles/per-user/baptiste/bin/mutt
        end

        # Start oidc-agent
        if type -q oidc-agent-service
            eval (oidc-agent-service use | awk '/^OIDC.*export/ {print $1}' | tr -d \; | awk -F'=' '{print "set -gx "$1" "$2";" }')
            # for fedcloudclient, once egi account got created
            # export OIDC_AGENT_ACCOUNT=egi
        end
    end

    # nvim!
    set EDITOR nvim
    fish_vi_key_bindings

    # Set color variables
    set emphasized_text brcyan # base1
    set normal_text brblue # base0
    set secondary_text brgreen # base01
    set background_light black # base02
    set background brblack # base03
    set -g fish_color_quote cyan # color of commands
    set -g fish_color_redirection brmagenta # color of IO redirections
    set -g fish_color_end blue # color of process separators like ';' and '&'
    set -g fish_color_error red # color of potential errors
    set -g fish_color_match --reverse # color of highlighted matching parenthesis
    set -g fish_color_search_match --background=yellow
    set -g fish_color_selection --reverse # color of selected text (vi mode)
    set -g fish_color_operator green # color of parameter expansion operators like '*' and '~'
    set -g fish_color_escape red # color of character escapes like '\n' and and '\x70'
    set -g fish_color_cancel red # color of the '^C' indicator on a canceled command
    set -g fish_color_command $emphasized_text --bold # color of commands
    set -g fish_color_param $normal_text # color of regular command parameters
    set -g fish_color_comment $secondary_text # color of comments
    set -g fish_color_autosuggestion $secondary_text # color of autosuggestions
    set -g fish_pager_color_prefix $emphasized_text --bold # color of the pager prefix string
    set -g fish_pager_color_description $selection_text # color of the completion description
    set -g fish_pager_color_selected_prefix $background
    set -g fish_pager_color_selected_completion $background
    set -g fish_pager_color_selected_description $background

    # Set LS_COLORS
    set -xg LS_COLORS (vivid generate dracula)

    [ -e $HOME/.fish.env ]; and source $HOME/.fish.env

    if test "$TERM" != dumb
        starship init fish | source
    end
    zoxide init fish | source
    direnv hook fish | source
end
