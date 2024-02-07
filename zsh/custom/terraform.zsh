export TFLINT_CONFIG_FILE=~/repos/ap3-ops/buildkite/scripts/.tflint.hcl

if [ "$(uname -s)" = "Darwin" ]; then
  alias tflock="terraform providers lock -platform=linux_amd64 -platform=darwin_arm64"
fi

alias tfiu="terraform init --upgrade"

function tfl() {
  SEARCHPATH="$(pwd)"

  tfmodules=("${(f)$(find "$SEARCHPATH" -name ".terraform.lock.hcl" -not -path "*/_common/*" | sed 's/.terraform.lock.hcl//')}")

  for m in $tfmodules; do
    echo "Checking: ${m}"
    tflint --config "$TFLINT_CONFIG_FILE" --chdir "${m}"
  done
}
