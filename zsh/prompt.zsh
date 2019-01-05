autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}
 ``
git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

# This assumes that you always have an origin named `origin`, and that you only
# care about one specific origin. If this is not the case, you might want to use
# `$git cherry -v @{upstream}` instead.
need_push () {
  if [ $($git rev-parse --is-inside-work-tree 2>/dev/null) ]
  then
    number=$($git cherry -v origin/$(git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]
    then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

battery_status() {
  if [[ $(sysctl -n hw.model) == *"Book"* ]]
  then
    $ZSH/bin/battery-status
  fi
}

# export PROMPT=$'\n$(battery_status)in $(directory_name) $(git_disrty)$(need_push)\n› '
export PROMPT=$'\n $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}


# Set Pure ZSH as a prompt
 # DISABLE_UNTRACKED_FILES_DIRTY="true"
  # PURE_CMD_MAX_EXEC_TIME=10s
  # prompt pure

# Set Spaceship ZSH as a prompt
#   SPACESHIP_PROMPT_ORDER=(
#   time          # Time stamps section
#   user          # Username section
#   dir           # Current directory section
#   host          # Hostname section
#   git           # Git section (git_branch + git_status)
#   package       # Package version
#   node          # Node.js section
#   golang        # Go section
#   docker        # Docker section
#   aws           # Amazon Web Services section
#   kubecontext   # Kubectl context section
#   exec_time     # Execution time
#   line_sep      # Line break
#   jobs          # Background jobs indicator
#   exit_code     # Exit code section
#   char          # Prompt character
# )
#  SPACESHIP_TIME_SHOW=false
#  SPACESHIP_TIME_12HR=false
#  SPACESHIP_HOST_SHOW=true
#  SPACESHIP_DIR_SHOW=true
#  SPACESHIP_GIT_BRANCH_SHOW=true
#  SPACESHIP_GIT_STATUS_SHOW=true
#  SPACESHIP_NODE_SHOW=false

#  prompt spaceships

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
