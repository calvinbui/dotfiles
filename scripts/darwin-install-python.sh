#!/bin/sh
set -eu

# python.org build: framework + GUI apps + /usr/local/bin symlinks + pip.
# Deselected: docs, shell-profile PATH edits (path.zsh has the framework bin),
# free-threaded framework.
# UPGRADES: bump PY_VERSION here; every machine installs it on its next apply.
# Choice identifiers per version: installer -pkg python.pkg -showChoicesXML
PY_VERSION="3.14.6"
PY_MINOR="${PY_VERSION%.*}"

INSTALLED="$(/Library/Frameworks/Python.framework/Versions/Current/bin/python3 --version 2>/dev/null | awk '{print $2}' || true)"
if [ "$INSTALLED" != "$PY_VERSION" ]; then
  curl -fsSLo /tmp/python.pkg "https://www.python.org/ftp/python/${PY_VERSION}/python-${PY_VERSION}-macos11.pkg"

  cat > /tmp/python-choices.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
  <dict>
    <key>choiceIdentifier</key><string>org.python.Python.PythonDocumentation-${PY_MINOR}</string>
    <key>choiceAttribute</key><string>selected</string>
    <key>attributeSetting</key><integer>0</integer>
  </dict>
  <dict>
    <key>choiceIdentifier</key><string>org.python.Python.PythonProfileChanges-${PY_MINOR}</string>
    <key>choiceAttribute</key><string>selected</string>
    <key>attributeSetting</key><integer>0</integer>
  </dict>
  <dict>
    <key>choiceIdentifier</key><string>org.python.Python.PythonTFramework-${PY_MINOR}</string>
    <key>choiceAttribute</key><string>selected</string>
    <key>attributeSetting</key><integer>0</integer>
  </dict>
</array>
</plist>
EOF

  sudo installer -pkg /tmp/python.pkg -applyChoiceChangesXML /tmp/python-choices.xml -target /
  rm -f /tmp/python.pkg /tmp/python-choices.xml

  # python.org builds bundle their own OpenSSL with no CA certs; without this,
  # every https request fails with CERTIFICATE_VERIFY_FAILED
  sh "/Applications/Python ${PY_MINOR}/Install Certificates.command"
fi
