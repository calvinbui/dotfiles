export TFLINT_CONFIG_FILE=~/repos/ap3-ops/buildkite/scripts/.tflint.hcl

if [ "$(uname -s)" = "Darwin" ]; then
  alias tflock="terraform providers lock -platform=linux_amd64 -platform=darwin_arm64"
fi

alias tfiu="terraform init --upgrade"
