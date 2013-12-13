# https://github.com/gwarf zsh theme
# Mostly adapted from
# https://github.com/blinks zsh theme
# Command error return from
# Sunrise theme for oh-my-zsh by Adam Lindberg (eproxus@gmail.com)
# Remote git status from
# ZSH theme by James Smith (http://loopj.com)

function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}±%{%f%k%b%}"
  else
    echo ' '
  fi
}

# This theme works with both the "dark" and "light" variants of the
# Solarized color schema.  Set the SOLARIZED_THEME variable to one of
# these two values to choose.  If you don't specify, we'll assume you're
# using the "dark" variant.

case ${SOLARIZED_THEME:-dark} in
    light) bkg=white;;
    *)     bkg=black;;
esac

git_remote_changes() {
  local -a remote
  remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]] ; then
    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    if [ $ahead -eq 0 ] && [ $behind -gt 0 ]; then
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg_bold[magenta]%}${ahead} ↑%{$reset_color%}"
    elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]; then
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg_bold[magenta]%}${ahead} ↑%{$reset_color%}"
    elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg_bold[magenta]%}$ahead ↑%{$reset_color%}"
    fi
    fi
}

# Show count of non tracked files
function _untracked() {
  if [[ ! -z $(/usr/bin/git ls-files --other --exclude-standard 2> /dev/null) ]] then
    untracked=$(/usr/bin/git ls-files --other --exclude-standard 2>/dev/null | wc -l)
  if [ $untracked -gt 0 ]; then
    echo " (${untracked} untracked)"
  else
    echo "*"
  fi
  fi
}


ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%k%b%K{${bkg}}%B%F{green}%}]"
#ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}$(_untracked)%{%f%k%b%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" %{$fg_bold[magenta]%}↕%{$reset_color%}"

PROMPT='%{%f%k%b%}
%{%K{${bkg}}%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{${bkg}}%}%3c%{%B%F{green}%}$(git_prompt_info)$(git_remote_status)%E%{%f%k%b%}
%{%K{${bkg}}%}$(_prompt_char)%{%K{${bkg}}%} %#%{%f%k%b%} '

local return_code="%{$reset_color%}%(?..%{$fg_no_bold[red]%}%? ↵%{$reset_color%})"
RPROMPT='!%{%B%F{cyan}%}%!%{%f%k%b%} ${return_code}'

# vim:set ft=zsh ts=2 sw=2 expandtab:
