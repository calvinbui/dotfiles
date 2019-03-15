# grep
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
# curl
PATH="/usr/local/opt/curl/bin:$PATH"
# coreutils https://www.gnu.org/software/coreutils/
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# ruby
PATH="/usr/local/opt/ruby/bin:$PATH"
# gnu-tar
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
# serverless
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
