# Yay! High voltage and arrows!

prompt_setup_pygmalion(){
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  base_prompt='%{$fg[magenta]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}%{$fg[red]%}:%{$reset_color%}%{$fg[cyan]%}%0~%{$reset_color%}%{$fg[red]%}|%{$reset_color%}'
  post_prompt='%{$fg[cyan]%}⇒%{$reset_color%}  '

  base_prompt_nocolor=$(echo "$base_prompt" | perl -pe "s/%\{[^}]+\}//g")
  post_prompt_nocolor=$(echo "$post_prompt" | perl -pe "s/%\{[^}]+\}//g")

  precmd_functions+=(prompt_pygmalion_precmd)
}

# add kubernetes context to the terminal prompt
kube_prompt_info()
{
  hash kubectl >/dev/null 2>&1 || {
    return
  }
  # Get current context
  local context=$(kubectl config view | grep current-context | awk '{ print $NF }' | awk -F '.' '{ print $1 }')
  local namespace=$(kubectl config get-contexts $context | tail -1 | awk '{print $(NF)}')
  if [ -n "$context" ]; then
      local display="(k8s: [${context}][${namespace}])"
      echo "%{$fg[cyan]%}${display}%{$reset_color%}"
  fi
}

prompt_pygmalion_precmd(){
  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  local prompt_length=${#exp_nocolor}

  local nl=""

  if [[ $prompt_length -gt 40 ]]; then
    nl=$'\n%{\r%}';
  fi
#  PROMPT="$base_prompt$gitinfo$nl$post_prompt"
  PROMPT="$base_prompt$gitinfo$(kube_prompt_info)$nl$post_prompt"
}

prompt_setup_pygmalion


