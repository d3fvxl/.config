# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

 alias kubeprod="gcloud container clusters get-credentials prod-us-east4 --region us-east4 --project production-198611"
 alias kubeinfra="gcloud container clusters get-credentials prod-infra-us-east4 --region us-east4 --project production-198611"
 alias kubeinfradev="gcloud container clusters get-credentials infra-dev-europe-west2 --region europe-west2 --project efg-infra-dev"
 alias kubeinfraprod="gcloud container clusters get-credentials infra-prod-us-east4 --region us-east4 --project efg-infra-prod"
 alias kubestage="gcloud container clusters get-credentials stage-europe-west2 --region europe-west2 --project stage-198611"
 alias kubesandbox="gcloud container clusters get-credentials sandbox-europe-west2 --region europe-west2 --project sandbox-195916"

# Cleanup TMUX Sessions
alias tmuxcleanup="tmux list-sessions | grep -v attached | awk 'BEGIN{FS=":"}{print $1}' | xargs -n 1 tmux kill-session -t || echo No sessions to kill"

# Open NVIM
alias nv="nvim ."

plugins=(
  aliases
  git
  docker
  docker-compose
  iterm2
  golang
  kubectl
  kubectx
  macos
  history
)

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export ZK_NOTEBOOK_DIR="$HOME/ZK"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
PATH=$(pyenv root)/shims:$PATH

source $ZSH/oh-my-zsh.sh

zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 13
zstyle :omz:plugins:iterm2 shell-integration yes

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


clog() {
  if [[ -n "$2" ]]; then
    # If the second argument is provided, use grep
    stern -o raw "$1" -c "$1" | grep "$2" | jq -R '. as $line | try (fromjson) catch $line'
  else
    # If the second argument is not provided, bypass grep
    stern -o raw "$1" -c "$1" | jq -R '. as $line | try (fromjson) catch $line'
  fi
}

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.5

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"
alias cd="z"
