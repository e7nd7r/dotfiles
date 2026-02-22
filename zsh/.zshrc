# >>> Setup oh my zsh >>>
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
)

source $ZSH/oh-my-zsh.sh

#Include untracked secret environment variables.
source $HOME/secrets_env.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source $HOME/aliases.sh

# >>> Path Setup >>>
# export PATH='/Users/esteban/.luarocks/bin:/Users/esteban/.pyenv/shims:/Users/esteban/.nvm/versions/node/v20.17.0/bin:/Users/esteban/miniforge3/condabin:/Users/esteban/bin:/usr/local/bin:/Users/esteban/go/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Library/TeX/texbin:/usr/local/go/bin:/Users/esteban/.cargo/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/esteban/.local/bin:/Users/esteban/flutter/bin:/Users/esteban/.pub-cache/bin'
export PATH="$HOME/.cargo/bin:$PATH"

# >>> Conda Setup >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/esteban/miniforge3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/esteban/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/esteban/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/esteban/miniforge3/bin:$PATH"
    fi
fi

unset __conda_setup

# >>> Node NVM Setup >>>
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# >>> Lua Rocks Setup >>>
export LUA_PATH='/opt/homebrew/lib/luarocks/rocks-5.4/?.lua;/opt/homebrew/Cellar/luarocks/3.11.1/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;/opt/homebrew/lib/lua/5.4/?.lua;/opt/homebrew/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/Users/esteban/.luarocks/share/lua/5.4/?.lua;/Users/esteban/.luarocks/share/lua/5.4/?/init.lua'
export LUA_CPATH='/opt/homebrew/lib/lua/5.4/?.so;/opt/homebrew/lib/lua/5.4/loadall.so;./?.so;/Users/esteban/.luarocks/lib/lua/5.4/?.so'

# For neo vim the version must matched.
eval "$(luarocks --lua-version=5.1 path --bin)"

# >>> Pyenv Setup >>>
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# >>> Tmuxifier Setup >>>
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
export EDITOR="nvim"
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux-layouts"

# >>> Golang Setup >>>
export PATH="$HOME/go/bin/bin:$PATH"
export GOPATH=$HOME/go/bin

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$GOPATH:$PATH

# >>> Flutter Setup >>>
export PATH="$PATH:/Users/esteban/flutter/bin"

# >>> Enable vim mode >>>
bindkey -v

# >>> fzf Setup >>>
source <(fzf --zsh)

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --no-ignore"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :500 {}'"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --strip-cwd-prefix --no-ignore'
export FZF_COMPLETION_TRIGGER='**'

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# >>> Bat Setup >>>
if [ ! -d "$(bat --config-dir)/themes" ]; then
    mkdir -p "$(bat --config-dir)/themes"
fi

if [ ! -f "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme" ]; then
    wget -q -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme >/dev/null

    bat cache --build >/dev/null
fi

alias bat="bat --color=always"

# >>> Eza Setup >>>
alias ls="eza --color=always --long --git"
alias lst="eza --color=always --tree --level=2 --long --git"

# >>> Yazy wrapper >>>
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# >>> Curl Setup >>>
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

# >>> Docker auto completion setup >>>
# fzf_kubectl_namespaces() {
#     namespace=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | fzf)

#     if [[ -n "$namespace" ]]; then
#         LBUFFER+="-n $namespace"
#     fi
# }

# fzf_kubectl_contexts() {
#     context = $(kubectl config get-contexts -o name | fzf)

#     if [[ -n "$context" ]]; then
#         kubectl config use-context $context
#         LBUFFER+="$context"
#     fi
# }

kubectl_pods() {
    namespace=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name" | fzf)

    if [[ -z "$namespace" ]]; then
        return
    fi

    local pod

    pod=$(kubectl get pods -n "$namespace" --no-headers -o custom-columns=":metadata.name" | fzf)

    if [[ -n "$pod" ]]; then
        LBUFFER+="-n $namespace $pod"
    fi
}

zle -N kubectl_pods

bindkey '^p' kubectl_pods

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

. "$HOME/.local/bin/env"

export DIGITALOCEAN_ACCESS_TOKEN="$(yq e '.access-token' ~/Library/Application\ Support/doctl/config.yaml)"
export DIGITALOCEAN_TOKEN="$(yq e '.access-token' ~/Library/Application\ Support/doctl/config.yaml)"
export TF_VAR_digitalocean_token="$(yq e '.access-token' ~/Library/Application\ Support/doctl/config.yaml)"

fpat=h(~/.zsh.d/ $fpath)
fpath=(~/.zsh.d/ $fpath)

for widget in ~/.config/fzf/widgets/*.zsh; do
    [[ -f "$widget" ]] && source "$widget"
done

eval "$(starship init zsh)"



# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/esteban/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
