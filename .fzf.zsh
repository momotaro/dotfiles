# Setup fzf
# ---------
if [[ ! "$PATH" == */home/momotaro/.fzf/bin* ]]; then
  export PATH="$PATH:/home/momotaro/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/momotaro/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/momotaro/.fzf/shell/key-bindings.zsh"

