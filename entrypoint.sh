#!/bin/bash

JAVA_HOME=/opt/java
export JAVA_HOME

echo "Exception sites:"
cat /home/ffuser/.java/deployment/security/exception.sites

if [ ! -d "${HOME}/.mozilla/firefox/default.profile" ]; then
  mkdir -p "${HOME}/.mozilla/firefox"
  mv -f /tmp/default.profile "${HOME}/.mozilla/firefox"
  echo -e "[General]\nStartWithLastProfile=1\n\n[Profile0]\nName=default\nIsRelative=1\nPath=default.profile\nDefault=1" > "${HOME}/.mozilla/firefox/profiles.ini"
fi

/usr/bin/firefox-esr $@
