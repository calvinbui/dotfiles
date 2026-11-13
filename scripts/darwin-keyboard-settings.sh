#!/bin/sh
set -eu

# holding a key repeats it instead of showing the accents popup
defaults write -g ApplePressAndHoldEnabled -bool false

# no auto-capitalisation
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# no smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# no autocorrect
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# no auto-period
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# no inline predictions
defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false
