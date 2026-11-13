# Only use work-repo defaults on machines where those files exist.
if [[ -r "$HOME/repos/buildkite/scripts/.trivy.yaml" ]]; then
  export TRIVY_CONFIG="$HOME/repos/buildkite/scripts/.trivy.yaml"
fi
if [[ -r "$HOME/repos/buildkite/scripts/.trivyignore-shared.yaml" ]]; then
  export TRIVY_IGNOREFILE="$HOME/repos/buildkite/scripts/.trivyignore-shared.yaml"
fi
