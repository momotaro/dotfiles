export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.local/bin
export GO111MODULE=on

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

export ANDROID_SDK=$HOME/Library/Android/sdk
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

export NANOBANANA_MODEL="gemini-3-pro-image-preview"

export ENABLE_LSP_TOOL=1

export PYTORCH_ENABLE_MPS_FALLBACK=1

# Required keys (set in ~/.zshenv.local)
# export GEMINI_API_KEY=
# export FIGMA_API_KEY=
# export GITHUB_PERSONAL_ACCESS_TOKEN=
# export BITBUCKET_USERNAME=
# export BITBUCKET_PASSWORD=
# export NANOBANANA_GEMINI_API_KEY=

[ -f ~/.zshenv.local ] && source ~/.zshenv.local
source $HOME/.localrc
