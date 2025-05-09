PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="/opt/mssql-tools18/bin:$PATH"
PATH="$HOME/.phpenv/bin:$PATH"
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

# Load completions
autoload -U compinit && compinit

# Add in zsh plugins
zinit light mafredri/zsh-async
zinit light allanjamesvestal/fast-zsh-nvm
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zpm-zsh/clipboard
zinit light doubleoh13/zsh-artisan

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
  alias ll="eza -l --icons --git"
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

# If fzf is installed, source it
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi

eval "$(oh-my-posh init zsh --config ~/.omp.yaml)"
if command -v step >/dev/null 2>&1; then
  eval "$(phpenv init -)"
fi

if command -v step >/dev/null 2>&1; then
  eval "$(step completion zsh)"
fi

zinit light zsh-users/zsh-syntax-highlighting
