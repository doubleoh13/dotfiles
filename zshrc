if grep -q "microsoft" /proc/version 2>/dev/null; then
  # We are in WSL. Lets set some things up
  export IS_WSL=true
  # Make git use the Windows ssh client in WSL
  export GIT_SSH_COMMAND="ssh.exe"
else
  export IS_WSL=false
fi

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="/opt/mssql-tools18/bin:$PATH"
export PATH

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

export NVM_COMPLETION=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('vim','nvim','vi')
export NVM_AUTO_USE=true
export NVM_LAZY_LOAD=true
export NVM_SILENT=true
export EDITOR=nvim

# Add in zsh plugins
zinit light gentslava/zsh-nvm
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zpm-zsh/clipboard
zinit light doubleoh13/zsh-artisan

# Load completions
autoload -U compinit #&& compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt histignorespace
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons --long --no-permissions --no-user --no-time --no-filesize $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons --long --no-permissions --no-user --no-time --no-filesize $realpath'

# Aliases
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --git"
  alias ll="eza -l --icons --git -a"
  alias la="eza -la --icons --git"
  alias lt="eza --tree --level=2 --long --icons --git"
fi
if command -v nvim >/dev/null 2>&1; then
  alias vi="nvim"
  alias vim="nvim"
fi
if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

alias ip.all="ip addr | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Ea '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ip.http="curl -s http://wtfismyip.com/text"
alias ports="netstat -tulnp"
alias wip="git add . && git commit -m 'wip'"
alias nah="git reset --hard && git clean -df"

# Use the Windows ssh client in WSL
if [ "$IS_WSL" = true ]; then
  alias ssh-add="ssh-add.exe"
  alias ssh='ssh-add.exe -l > /dev/null || ssh-add.exe && ssh.exe'
fi

# If fzf is installed, source it
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

eval "$(zoxide init --cmd cd zsh)"

eval "$(oh-my-posh init zsh --config ~/.omp.json)"
