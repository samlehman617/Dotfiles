# +-----------------------------------------------------------------+
# | Variables                                                       |
# +-----------------------------------------------------------------+
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}

# +-----------------------------------------------------------------+
# | Zinit Plugin Manager                                            |
# +-----------------------------------------------------------------+
# | Loads plugins without the slowdown of other frameworks          |
# +-----------------------------------------------------------------+
# |                                                                 |
# | Sub-commands:                                                   |
# | - load:    Loads plugin with reporting.                         |
# | - unload:  Unloads plugin.                                      |
# | - report:  View plugin report.                                  |
# | - light:   Loads plugin without reporting (much faster).        |
# | - snippet: Downloads and loads a single file.                   |
# |                                                                 |
# | Ice Modifiers:                                                  |
# | - pick"file":         Selects the file to source.               |
# | - as"program":        Loads as command, but doesn't source.     |
# | - as"completion":     Loads as completion, but doesn't source.  |
# | - cp"file1 -> file2": Copies a file.                            |
# | - mv"file1 -> file2": Moves a file.                             |
# | - atclone:            Runs command on repo clone.               |
# | - atpull:             Runs command on repo pull.                |
# | - atinit:             Runs command before loading.              |
# | - atload:             Runs command after zsh load.              |
# | - blockf:             Block normal completion adding.           |
# | - wait:               Postpone loading until zshrc loaded.      |
# |                                                                 |
# +-----------------------------------------------------------------+
# | Important Note!: You must either do one of the following:       |
# | 1. Source zinit BEFORE compinit                                 |
# | 2. Add the lines below AFTER sourcing zinit:                    |
# |    > autoload -Uz _zinit                                        |
# |    > (( ${+_comps} )) && _comps[zinit]=_zinit                   |
# +-----------------------------------------------------------------+
source ~/.zinit/bin/zinit.zsh

# +-----------------------------------------------------------------+
# | Meta Plugins                                                    |
# +-----------------------------------------------------------------+
# | Installs groups of plugins. Supports Turbo Mode.                |
# +-----------------------------------------------------------------+
# | annexes+con:   unscope, as-monitor, patch-dl, rust, submods,    |
# |                bin-gem-node                                     |
# | console-tools: dircolors-material, exa, ripgrep, tig,           |
# |                sharkdp/(fd, bat, hexyl, hyperfine, vivid)       |
# | developer:     github-issues, github-issues-srv, gitignore, tig |
# |                molovo/(color, revolver, zunit)                  |
# | ext-git:       git-open, git-recall, git-recent, git-extras,    |
# |                git-my, git-now, git-quick-stats, forgit         |
# | prezto:        archive, directory, utility                      |
# | rust-utils:    rust-toolchain, cargo-extensions                 |
# | zsh-users:     fast-syntax-highlighting, zsh-autosuggestions,   |
# |                zsg-completions                                  |
# +-----------------------------------------------------------------+
zinit for z-a-meta-plugins
zinit for annexes+con \
  console-tools \
  developer \
  ext-git \
  fuzzy \
  prezto \
  rust-utils \
  zsh-users+fast

# +-----------------------------------------------------------------+
# | Curses-based plugin management interface                        |
# +-----------------------------------------------------------------+
# | - Installs a patch downloader                                   |
# | - Patches Zsh to install zsh module: zsh/curses                 |
# | - Reloads Zsh & Allows updating Zsh within shell                |
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
# zinit light zinit-zsh/z-a-patch-dl
zinit ice id-as"zsh" atclone"./.preconfig
        CFLAGS='-I/usr/include -I/usr/local/include -g -O2 -Wall' \
        LDFLAGS='-L/usr/lib -L/usr/local/lib' ./configure --prefix='$ZPFX'" \
    dl"https://gist.githubusercontent.com/psprint/2373494c71cb6d1529344a2ed1a64b03/raw -> curses.patch" \
    patch'curses.patch' atpull"%atclone" reset \
    run-atpull make"install" pick"/dev/null"
zinit load zsh-users/zsh


# +-----------------------------------------------------------------+
# | Powerlevel10K Prompt Theme                                      |
# +-----------------------------------------------------------------+
# | A line exists at the end of this file to source the             |
# | Powerlevel10k configuration file.                               |
# +-----------------------------------------------------------------+
# Enable the plugin
zinit ice depth=1; zinit light romkatv/powerlevel10k
# Enable the instant-prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# +-----------------------------------------------------------------+
# | Colors                                                          |
# +-----------------------------------------------------------------+
# | Uses trapd00r/LS_COLORS for color definitions. This command     |
# | prevents needing to re-evaluate dircolors at every shell startup|
# +-----------------------------------------------------------------+
# zinit pack for dircolors-material

# Instead of eval "$(dircolors -b $HOME/LS_COLORS):
# zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
#     atpull'%atclone' pick"clrs.zsh" nocompile'!' \
#     atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
# zinit light trapd00r/LS_COLORS

# if (( $+commands[vivid] )); then
#   export VIVID_DATABASE=${XDG_CONFIG_HOME:-$HOME/.config}/vivid/config/filetypes.yml
#   export LS_COLORS="$(vivid generate snazzy)"
#   export ZLS_COLORS=$LS_COLORS
#   export LESS="-R"
#   export CLICOLOR=1
#   export CLICOLOR_FORCE=1
# fi


# +-----------------------------------------------------------------+
# | History                                                         |
# +-----------------------------------------------------------------+
HISTSIZE=10000                   # Big history
SAVEHIST=${HISTSIZE:-5000}       # Save more entries to history
setopt HistIgnoreAllDups         # Ignore duplicate history entries
setopt HistReduceBlanks          # Remove whitespace from history lines
setopt IncAppendHistory          # Save history entries incrementally
setopt ShareHistory              # Share history between shell instances

# +-----------------------------------------------------------------+
# | Keybindings                                                     |
# +-----------------------------------------------------------------+
# Use emacs keybindings even if our EDITOR is set to vi/vim.
bindkey -e

# +-----------------------------------------------------------------+
# | Completions                                                     |
# +-----------------------------------------------------------------+
# Generic completions (from Oh-My-Zsh)
# zinit ice blockf
# zinit light zsh-users/zsh-completions
# NPM completions (as"completion" OR blockf???)
# zinit ice as"completion"
# zinit ice blockf
# zinit light lukechilds/zsh-nvm
# Docker completions
# zinit ice as"completion"
# zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# +-----------------------------------------------------------------+
# | Auto-Completion                                                 |
# +-----------------------------------------------------------------+
# | - Fast syntax highlighting                                      |
# | - Basic auto-completions                                        |
# | Using marlonrichert's autosuggestions instead of:               |
# | zsh-users/zsh-autosuggestions \                                 |
# +-----------------------------------------------------------------+
# zinit wait lucid light-mode for \
#
# zinit wait lucid for \
#   atinit"zicompinit; zicdreplay" \
#       zdharma/fast-syntax-highlighting \
#       OMZP::colored-man-pages \
#   atload"_zsh_autosuggest_start" \
#     marlonrichert/zsh-autocomplete \
#   blockf atpull'zinit creinstall -q .' \
#       zsh-users/zsh-completions

# Basic auto suggestions
# (syntax prevents auto-completing before first prompt)
# zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
#     zsh-users/zsh-autosuggestions \
#     marlonrichert/zsh-autocomplete

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="spaceship"

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder



# +-----------------------------------------------------------------+
# | USER CONFIGURATION                                              |
# +-----------------------------------------------------------------+
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh" for \
        direnv/direnv

# Use asdf to manage programming environments
. $HOME/.asdf/asdf.sh
# Append asdf completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

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
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if [[ -r "$HOME/.aliases" ]]; then
  source $HOME/.aliases
fi

# +-----------------------------------------------------------------+
# | Powerlevel10K Prompt Theme                                      |
# +-----------------------------------------------------------------+
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
