# +-----------------------------------------------------------------+
# |                           ZSHRC                                 |
# +-----------------------------------------------------------------+
#
# +-----------------------------------------------------------------+
# | Variables                                                       |
# +-----------------------------------------------------------------+
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}

# +-----------------------------------------------------------------+
# | Zinit Plugin Manager                                            |
# +-----------------------------------------------------------------+
# | Loads plugins without the slowdown of other frameworks          |
# +-----------------------------------------------------------------+
# | Sub-commands:                                                   |
# | - load:    Loads plugin with reporting.                         |
# | - unload:  Unloads plugin.                                      |
# | - report:  View plugin report.                                  |
# | - light:   Loads plugin without reporting (much faster).        |
# | - snippet: Downloads and loads a single file.                   |
# | Ice Modifiers:                                                  |
# | - pick"file":         Selects the file to source.               |
# | - as"program":        Loads as command, but doesn't source.     |
# | - as"completion":     Loads as completion, but doesn't source.  |
# | - cp"file1 -> file2": Copies a file.                            |
# | - mv"file1 -> file2": Moves a file.                             |
# | - atclone:            Runs command on repo clone.               |
# | - atpull:             Runs command on repo pull.                |
# | - atinit:             Runs command after cloning & before loading. |
# | - atload:             Runs command after zsh load.              |
# | - blockf:             Block normal completion adding.           |
# | - wait:               Postpone loading until zshrc loaded.      |
# +-----------------------------------------------------------------+
# | Important Note!: You must either do one of the following:       |
# | 1. Source zinit BEFORE compinit                                 |
# | 2. Add the lines below AFTER sourcing zinit:                    |
# |    > autoload -Uz _zinit                                        |
# |    > (( ${+_comps} )) && _comps[zinit]=_zinit                   |
# +-----------------------------------------------------------------+
# Set Zinit variables
ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-$HOME}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-$ZPLG_BIN_DIR_NAME}:-bin}"

# Check if Zinit exists & install zinit otherwise
if [[ ! -f $ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
# Load Zinit
source "$ZINIT_HOME/$ZINIT_BIN_DIR_NAME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# +-----------------------------------------------------------------+
# | Powerlevel10k Prompt                                            |
# +-----------------------------------------------------------------+
if [[ ! -f ~/.p10k.zsh ]]; then
  zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd
else
  zinit ice lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
fi
zinit light romkatv/powerlevel10k

# Install meta-plugins plugin
zinit for zinit-zsh/z-a-meta-plugins

# +-----------------------------------------------------------------+
# | Curses-based plugin management interface                        |
# +-----------------------------------------------------------------+
# | - Installs a patch downloader                                   |
# | - Patches Zsh to install zsh module: zsh/curses                 |
# | - Reloads Zsh & Allows updating Zsh within shell                |
# | - Requires zinit-zsh/z-a-patch-dl (installed via meta-plugin)   |
# +-----------------------------------------------------------------+
# | Keyboard shortcuts: (open by running `ziconsole`)               |
# | - Launch consolette:             CTRL-O CTRL-J                  |
# | - Half page up/down:             CTRL-U/D                       |
# | - Previous/next line:            CTRL-P/N                       |
# | - Redraw display:                CTRL-L                         |
# | - Jump to next/previous section: [/]                            |
# | - Jump to beginning/end:         g/G                            |
# | - Scroll left/right:             <,> OR {,}                     |
# | - Incremental search:            /                              |
# | - Jump to search result & back:  F1                             |
# | - Exit search:                   Esc                            |
# | - Delete whole word/line:        CTRL-W/K                       |
# +-----------------------------------------------------------------+
# Load our ZUI plugin management interface
zinit lucid light-mode for zdharma/zui

# Load the zinit extensions (annexes)
zinit for annexes+con

# Install Zsh with Ncurses support (required for ZUI plugin)
zinit ice id-as"zsh" atclone"./.preconfig
  CFLAGS='-I/usr/include -I/usr/local/include -g -O2 -Wall' \
  LDFLAGS='-L/usr/lib -L/usr/local/lib' ./configure --prefix='$ZPFX'" \
  dl"https://gist.githubusercontent.com/psprint/2373494c71cb6d1529344a2ed1a64b03/raw -> curses.patch" \
  patch'curses.patch' atpull"%atclone" reset \
  run-atpull make"install" pick"/dev/null"
zinit load zsh-users/zsh

# +---------------------------------------------------------------------------+
# | Meta Plugins (https://github.com/zinit-zsh/z-a-meta-plugins)              |
# | - Installs plugins, groups of plugins, other meta-plugins, zinit packages,|
# |   zinit annexes (needed to install our other plugins) & binary packages.  |
# | - Supports zinit Turbo Mode                                               |
# +---------------+-----------------------------------------------------------+
# |       annexes | zinit-zsh/z-a-unscope,  zinit-zsh/z-a-as-monitor,         |
# |               | zinit-zsh/z-a-patch-dl, zinit-zsh/z-a-rust,               |
# |               | zinit-zsh/z-a-submods,  zinit-zsh/z-a-bin-gem-node        |
# +---------------+-----------------------------------------------------------+
# |   annexes+con | annexes (meta-plugin),  zsh-init/zinit-console            | 
# +---------------+-----------------------------------------------------------+
# | console-tools | dircolors-material (package), sharkdp (meta-plugin),      |
# |               | ogham/exa, BurntSushi/ripgrep, jonas/tig                  |
# +---------------+-----------------------------------------------------------+
# |     developer | github-issues (package), github-issues-srv (package),     |
# |               | molovo (meta-plugin), voronkovich/gitignore, jonas/tig    |
# +---------------+-----------------------------------------------------------+
# |         fuzzy | fzy (package), fzf (package), lotabout/skim, peco/peco    |
# +---------------+-----------------------------------------------------------+
# |     fuzzy-src | fzy (package), fzf-go, skim-cargo, peco-go                |
# +---------------+-----------------------------------------------------------+
# |       ext-git | Fakerr/git-recall,      davidosomething/git-my,           |
# |               | paulirish/git-open,     arzzen/git-quick-stats,           |
# |               | paulirish/git-recent,   wfxr/forgit,                      |
# |               | iwata/git-now,          tj/git-extras                     |
# +---------------+-----------------------------------------------------------+
# |        molovo | molovo/color,       molovo/revolver,  molovo/zunit        |
# +---------------+-----------------------------------------------------------+
# |        prezto | PZTM::archive,      PZTM::directory,  PZTM::utility       |
# +---------------+-----------------------------------------------------------+
# |       sharkdp | sharkdp/fd,         sharkdp/bat,      sharkdp/hexyl,      |
# |               | sharkdp/hyperfine,  sharkdp/vivid                         |
# +---------------+-----------------------------------------------------------+
# |    rust-utils | rust-toolchain,     cargo-extensions                      |
# +---------------+-----------------------------------------------------------+
# |       zdharma | zdharma/fast-syntax-highlighting,                         |
# |               | zdharma/history-search-multi-word,                        |
# |               | zdharma/zsh-diff-so-fancy                                 |
# +---------------+-----------------------------------------------------------+
# |      zdharma2 | zdharma/zconvey,    zdharma/zui,      zdharma/zflai       |
# +---------------+-----------------------------------------------------------+
# |     zsh-users | zsh-users/zsh-syntax-highlighting,                        |
# |               | zsh-users/zsh-autosuggestions,                            |
# |               | zsh-users/zsh-completions                                 |
# +---------------+-----------------------------------------------------------+
# | zsh-users+fast| zdharma/fast-syntax-highlighting,                         |
# |               | zsh-users/zsh-autosuggestions,                            |
# |               | zsh-users/zsh-completions                                 |
# +---------------+-----------------------------------------------------------+

# +-----------------------------------------------------------------+
# | Auto-Completion                                                 |
# +-----------------------------------------------------------------+
# | - Fast syntax highlighting                                      |
# | - Basic auto-completions                                        |
# | Using marlonrichert's autosuggestions instead of:               |
# | zsh-users/zsh-autosuggestions \                                 |
# +-----------------------------------------------------------------+
zinit for \
  atinit"zstyle ':autocomplete:tab:*' insert-unambiguous yes" \
    marlonrichert/zsh-autocomplete \

zinit wait lucid light-mode for \
  compile'{hsmw-*,test/*}' \
    zdharma/history-search-multi-word

zinit wait lucid light-mode for \
  OMZP::command-not-found/command-not-found.plugin.zsh

zinit wait lucid light-mode for \
  atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down' \
    zsh-users/zsh-history-substring-search

zinit wait lucid light-mode for \
  atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
    zdharma/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
    OMZL::completion.zsh \
  blockf as"completion" \
    lukechilds/zsh-nvm \
  blockf as"completion" \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
  # atload"!_zsh_autosuggest_start" \
  #   zsh-users/zsh-autosuggestions

# Show more help text
zstyle ':completion:*' extra-verbose yes
# Insert common substring first
# zstyle ':autocomplete:tab:*' insert-unambiguous yes
# zstyle ':autocomplete:tab:*' widget-style menu-select
# zstyle ':autocomplete:tab:*' widget-style menu-complete
# zstyle ':autocomplete:tab:*' fzf-completion yes

# Install the rest of our meta-plugins
zinit for \
  console-tools \
  developer \
  ext-git \
  fuzzy \
  prezto \
  rust-utils \
  @sharkdp

# +-----------------------------------------------------------------+
# | History                                                         |
# +-----------------------------------------------------------------+
# Set history file & load Oh-My-Zsh's history library
zinit depth'3' lucid light-mode atinit'HISTFILE="${HOME}/.histfile"' for \
  OMZL::history.zsh

HISTSIZE=10000                   # Big history
SAVEHIST=${HISTSIZE:-5000}       # Save more entries to history
setopt HistIgnoreAllDups         # Ignore duplicate history entries
setopt HistReduceBlanks          # Remove whitespace from history lines
setopt IncAppendHistory          # Save history entries incrementally
setopt ShareHistory              # Share history between shell instances

# +-----------------------------------------------------------------+
# | Colors                                                          |
# +-----------------------------------------------------------------+
# | Uses trapd00r/LS_COLORS for color definitions. This command     |
# | prevents needing to re-evaluate dircolors at every shell startup|
# +-----------------------------------------------------------------+
# Colored manpages
zinit wait lucid for OMZP::colored-man-pages

# +-----------------------------------------------------------------+
# | Keybindings                                                     |
# +-----------------------------------------------------------------+
# Use emacs keybindings even if our EDITOR is set to vi/vim.
bindkey -e

# Extract Files
  # trigger-load'!x' \
  #   OMZ::plugins/extract/extract.plugin.zsh \

# Git: Update repos and show changes
# zinit depth'3' lucid light-mode for \
#   trigger-load'!updatelocal' blockf \
#     nicholas85/updatelocal
  # trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' blockf \
  # atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atlooad\"zinit creinstall -q _local/config-files; zicompinit\" for /dev/null; gencomp"' \
  #   RobSis/zsh-completion-generator

# zinit depth'3' lucid wait'0' light-mode for \
#   has'systemctl' \
#     OMZP::systemd/systemd.plugin.zsh \
#     OMZP::sudo/sudo.plugin.zsh

# zinit depth'3' lucid wait'0' light-mode for \
#   pick'autopair.zsh' nocompletions atload'bindkey "^H" backward-kill-word; ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
#     hlissner/zsh-autopair


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# +-----------------------------------------------------------------+
# | USER CONFIGURATION                                              |
# +-----------------------------------------------------------------+
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# +-----------------------------------------------------------------+
# | SSH                                                             |
# +-----------------------------------------------------------------+
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# +-----------------------------------------------------------------+
# | ENVIRONMENT                                                     |
# +-----------------------------------------------------------------+
# | Uses direnv to modify environment on directory change.          |
# +-----------------------------------------------------------------+
# zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
#     atpull'%atclone' pick"direnv" src"zhook.zsh" for \
#         direnv/direnv

# Use asdf to manage programming environments
# . $HOME/.asdf/asdf.sh
# Append asdf completions to fpath
# fpath=(${ASDF_DIR}/completions $fpath)

# +-----------------------------------------------------------------+
# | ALIASES                                                         |
# +-----------------------------------------------------------------+
# | - Set personal aliases, overriding those provided by oh-my-zsh  |
# |   libs, plugins, and themes. Aliases can be placed here, though |
# |   oh-my-zsh                                                     |
# | - Users are encouraged to define aliases within the ZSH_CUSTOM  |
# |   folder.                                                       |
# | - For a full list of active aliases, run `alias`.               |
# +-----------------------------------------------------------------+
if [[ -r "$HOME/.aliases" ]]; then
  source $HOME/.aliases
fi

# +-----------------------------------------------------------------+
# | Powerlevel10K Prompt Theme                                      |
# +-----------------------------------------------------------------+
# (( ! ${+functions[p10k]} )) || p10k finalize
