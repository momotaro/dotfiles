export LANG=ja_JP.UTF-8

HISTFILE=$HOME/.zsh-history # 履歴の保存先
HISTSIZE=100000             # メモリに展開する履歴の数
SAVEHIST=100000             # 保存する履歴の数

TERM=screen-256color
autoload -U colors
colors

# Configure Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Vi モード
set -o vi
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# スクリーンロックのショートカットを解除
stty stop undef
stty start undef

setopt no_beep

# プログラマブル保管機能を有効
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# 大文字 小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## 色を使う
setopt prompt_subst

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## コマンドのスペルチェック
#setopt correct

## 同一ホストで動いているzshで履歴を共有
setopt share_history

## ディレクトリスタックを保存
setopt auto_pushd

## 補完候補を一覧表示
setopt auto_list

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## ディレクトリ名だけで cd
setopt auto_cd

# 保管候補をカーソルで選択可能に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
function fzf_search_file() {
  find . | fzf
}
zle -N fzf_search_file
bindkey '^F' fzf_search_file

if [[ -n "$TMUX" ]]; then
    eval "$(tmux source-file ~/.tmux.conf)"
fi

# Open
[ `uname` = "Linux" ] && alias open='xdg-open 2>/dev/null'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/momotaro/.sdkman"
[[ -s "/home/momotaro/.sdkman/bin/sdkman-init.sh" ]] && source "/home/momotaro/.sdkman/bin/sdkman-init.sh"

source ~/.zsh_profile
source ~/.zshenv
