if [ "$(uname)" = "Darwin" ]; then
    export HOMEBREW_NO_ANALYTICS=1
fi

export HOMEBREW_CASK_OPTS="--no-quarantine"
export HOMEBREW_NO_ENV_HINTS="true"

alias brew-cu="defaults export com.apple.dock "/tmp/dock-layout.plist" && brew cu -a && defaults import com.apple.dock "/tmp/dock-layout.plist" && killall Dock"
