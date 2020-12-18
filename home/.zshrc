# +-----------------------------------------------------------------+
# |                           ZSHRC                                 |
# +-----------------------------------------------------------------+
# | About:                                                          |
# |                                                                 |
# | Plugin Manager:                                                 |
# | - Zinit (https://github.com/zdharma/zinit)                      |
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
# | - atinit:             Runs command after cloning & before loading. |
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

# +-----------------------------------------------------------------+
# | Powerlevel10k: Instant Prompt                                   |
# +-----------------------------------------------------------------+
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# +-----------------------------------------------------------------+
# | Zinit                                                           |
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
# | Async Shell                                                     |
# +-----------------------------------------------------------------+
zinit depth'1' lucid light-mode for \
  pick'async.zsh' \
    mafredri/zsh-async

# +-----------------------------------------------------------------+
# | Initial Prompt
# | - Powerlevel10k
# +-----------------------------------------------------------------+
if [[ ! -f ~/.p10k.zsh ]]; then
  zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd
else
  zinit ice lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
fi
zinit light romkatv/powerlevel10k

# +---------------------------------------------------------------------------+
# | Meta Plugins (https://github.com/zinit-zsh/z-a-meta-plugins)              |
# | - Installs other meta-plugins                                             |
# | - Installs groups of plugins                                              |
# | - Installs zinit packages                                                 |
# | - Installs binary packages                                                |
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
# Add the meta-plugins plugin
zinit for zinit-zsh/z-a-meta-plugins
# Load the zinit extensions (annexes)
zinit for \
  annexes+con \
  console-tools \
  developer \
  ext-git \
  fuzzy \
  prezto \
  rust-utils \
  sharkdp \
  zdharma \
  zdharma2 \
  zsh-users+fast


# +-----------------------------------------------------------------+
# | History                                                         |
# +-----------------------------------------------------------------+
# Set history file & load Oh-My-Zsh's history library
zinit depth'3' lucid atinit'HISTFILE="${HOME}/.histfile"' for \
  OMZL::history.zsh

HISTSIZE=10000                   # Big history
SAVEHIST=${HISTSIZE:-5000}       # Save more entries to history
setopt HistIgnoreAllDups         # Ignore duplicate history entries
setopt HistReduceBlanks          # Remove whitespace from history lines
setopt IncAppendHistory          # Save history entries incrementally
setopt ShareHistory              # Share history between shell instances

# +-----------------------------------------------------------------+
# | Trigger loading                                                 |
# +-----------------------------------------------------------------+

# Extract Files
  # trigger-load'!x' \
  #   OMZ::plugins/extract/extract.plugin.zsh \

# Git: Update repos and show changes
# zinit depth'3' lucid light-mode for \
#   trigger-load'!updatelocal' blockf \
#     nicholas85/updatelocal

  # trigger-load'!man' \
  #   ael-code/zsh-colored-man-pages \
  # trigger-load'!gencomp' pick'zsh-completion-generator.plugin.zsh' blockf \
  # atload'alias gencomp="zinit silent nocd as\"null\" wait\"2\" atlooad\"zinit creinstall -q _local/config-files; zicompinit\" for /dev/null; gencomp"' \
  #   RobSis/zsh-completion-generator

# +-----------------------------------------------------------------+
# | Wait 0 Seconds                                                  |
# +-----------------------------------------------------------------+
# zinit depth'3' lucid wait'0' light-mode for \
#   has'systemctl' \
#     OMZP::systemd/systemd.plugin.zsh \
#     OMZP::sudo/sudo.plugin.zsh

  # if'false' ver'dev' \
    # marlonrichert/zsh-autocomplete \
  #   OMZL::completion.zsh \
  # blockf \
  #   zsh-users/zsh-completions \
  # compile'{src/*.zsh,src/strategies/*}' pick'zsh-autosuggestions.zsh' \
  # atload'_zsh_autosuggest_start' \
  #   zsh-users/zsh-autosuggestions \
  # pick'fz.sh' atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert __fz_zsh_completion)' \  
  #   changyuheng/fz

# zinit depth'3' lucid wait'0' light-mode for \
#   pick'autopair.zsh' nocompletions atload'bindkey "^H" backward-kill-word; ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
#     hlissner/zsh-autopair

  # pack'no-dir-color-swap' patch"$pchf/%PLUGIN%.patch" reset \
  #   trapd00r/LS_COLORS \
  # compile'{hsmw-*,test/*}' \
  #   zdharma/history-search-multi-word \
  #   OMZP::command-not-found/command-not-found.plugin.zsh \
  # trackbinds bindmap'\e[1\;6D -> ^[[1\;5A' patch"$pchf/%PLUGIN%.patch" \
  # reset pick'dircycle.zsh' \
  #   michaelxmcbride/zsh-dircycle \
  # autoload'#manydots-magic' \
  #   knu/zsh-manydots-magic \
  # pick'autoenv.zsh' nocompletions \
  #   Tarrasch/zsh-autoenv \
  # atinit'zicompinit_fast; zicdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
  #   zdharma/fast-syntax-highlighting \
  # atload'bindkey "$terminfo[kcuu1]" history-substring-search-up;
  # bindkey "$terminfo[kcud1]" history-substring-search-down' \
  #   zsh-users/zsh-history-substring-search \
  # as'completion' mv'*.zsh -> _git' \
  #   felipec/git-completion \

# zinit depth'3' lucid wait'0' light-mode from'gh-r' as'program' for \

  # sbin from 'gh-r' submods'sei40kr/zsh-fast-alias-tips -> plugin' pick'plugin/*.zsh' \
  # pack'bgn-binary' \
  #   junegunn/fzf \
  

# zinit depth'3' lucid wait'0' light-mode binary for \
  # sbin'bin/git-ignore' atload'export GI_TEMPLATE="$PWD/.git-ignore"; alias gi="git-ignore"'\
  #   laggardkernel/git-ignore
  # sbin'fd*/fd;fd*/fd -> fdfind' from'gh-r' \
  #   @sharkdp/fd \

# zinit depth'3' lucid wait'0' light-mode null for \
  # sbin"bin/git-dsf;bin/diff-so-fancy" \
  #   zdharma/zsh-diff-so-fancy \
  # sbin \
  #   paulirish/git-open \
  # sbin'm*/micro' from"gh-r" ver'nightly' bpick'*linux64*' reset \
  #   zyedidia/micro \
  # sbin'*/rm-trash' atload'alias rm="rm-trash ${rm_opts}"' reset \
  # patch"$pchf/%PLUGIN%.patch" \
  #   nateshmbhat/rm-trash \
  # sbin \
  #   kazhala/dotbare \
  # id-as'Cleanup' nocd atinit'_zsh_autosuggest_bind_widgets' \
  #   zdharma/null


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
# Rebuilds Zsh w/ curses (requires zinit-zsh/z-a-patch-dl [installed via meta-plugin above])
rebuild_zsh_curses_support() {
  zinit ice id-as"zsh" atclone"./.preconfig
          CFLAGS='-I/usr/include -I/usr/local/include -g -O2 -Wall' \
          LDFLAGS='-L/usr/lib -L/usr/local/lib' ./configure --prefix='$ZPFX'" \
      dl"https://gist.githubusercontent.com/psprint/2373494c71cb6d1529344a2ed1a64b03/raw -> curses.patch" \
      patch'curses.patch' atpull"%atclone" reset \
      run-atpull make"install" pick"/dev/null"
  zinit load zsh-users/zsh
}
# Only rebuild Zsh if missing curses support
# zmodload zsh/curses || rebuild_zsh_curses_support


# +-----------------------------------------------------------------+
# | Powerlevel10K Prompt Theme                                      |
# +-----------------------------------------------------------------+
# | A line exists at the end of this file to source the             |
# | Powerlevel10k configuration file.                               |
# +-----------------------------------------------------------------+
# Enable the plugin
# zinit ice depth=1; zinit light romkatv/powerlevel10k
# Enable the instant-prompt
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# +-----------------------------------------------------------------+
# | Colors                                                          |
# +-----------------------------------------------------------------+
# | Uses trapd00r/LS_COLORS for color definitions. This command     |
# | prevents needing to re-evaluate dircolors at every shell startup|
# +-----------------------------------------------------------------+
# zinit 

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
zinit depth'3' lucid wait'0' light-mode from'gh-r' for \
  sei40kr/fast-alias-tips-bin \
  sei40kr/zsh-fast-alias-tips

# +-----------------------------------------------------------------+
# | Powerlevel10K Prompt Theme                                      |
# +-----------------------------------------------------------------+
# (( ! ${+functions[p10k]} )) || p10k finalize
