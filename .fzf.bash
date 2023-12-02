# Setup fzf
# ---------
if [[ ! "$PATH" == */home/colljori/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/colljori/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/colljori/.fzf/shell/completion.bash"

# Key bindings
# ------------
source "/home/colljori/.fzf/shell/key-bindings.bash"
