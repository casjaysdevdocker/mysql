#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202408111855-git
# @@Author           :  CasjaysDev
# @@Contact          :  CasjaysDev <docker-admin@casjaysdev.pro>
# @@License          :  MIT
# @@ReadME           :
# @@Copyright        :  Copyright 2023 CasjaysDev
# @@Created          :  Mon Aug 28 06:48:42 PM EDT 2023
# @@File             :  05-custom.sh
# @@Description      :  script to run custom
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck shell=bash
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -e -o pipefail
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -x$DEBUGGER_OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set env variables
exitCode=0
users="$(cat /etc/passwd | awk -F ':' '{print $1}')"
WWW_USER="$(echo "$users" | grep '^apache$' || echo "$users" | grep '^nginx$' || echo 'root')"
PHPMYADMIN_WWW_ROOT="/usr/share/phpmyadmin"
PHPMYADMIN_VERSION="${PHPMYADMIN_VERSION:-$(curl -q -LSsf https://api.github.com/repos/phpmyadmin/phpmyadmin/releases | jq -r '.[].name' | sort -rV | head -n1 | grep '^' || echo "5.2.1")}"
PHPMYADMIN_DOWNLOAD_URL="https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script
echo "Installing phpmyadmin from $PHPMYADMIN_DOWNLOAD_URL"
[ -d "$PHPMYADMIN_WWW_ROOT" ] && rm -Rf "$PHPMYADMIN_WWW_ROOT"
if curl -q -LSsf "$PHPMYADMIN_DOWNLOAD_URL" -o "/tmp/phpmyadmin.zip"; then
  unzip -q "/tmp/phpmyadmin.zip" -d "/tmp" && rm -Rf "/tmp/phpmyadmin.zip"
  mv -f "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages" "$PHPMYADMIN_WWW_ROOT"
  git clone --depth 1 "https://github.com/phpmyadmin/themes" "/tmp/themes"
  for theme in blueberry boodark bootstrap dark-orange darkmod-neo darkwolf eyed fallen fistu metro mhn; do
    echo "Installing $theme to $PHPMYADMIN_WWW_ROOT/themes/$theme"
    mkdir -p "$PHPMYADMIN_WWW_ROOT/themes/$theme" && [ -d "/tmp/themes/$theme" ] && copy "/tmp/themes/$theme/." "$PHPMYADMIN_WWW_ROOT/themes/$theme/"
  done
  symlink "/etc/phpmyadmin/config.php" "$PHPMYADMIN_WWW_ROOT/config.inc.php"
  chown -Rf $WWW_USER "$PHPMYADMIN_WWW_ROOT"
  find "$PHPMYADMIN_WWW_ROOT" -type -d -exec chmod -f 777 {} \;
  echo "phpmyadmin has been installed to $PHPMYADMIN_WWW_ROOT"
else
  echo "Failed to install phpMyAdmin" >&2
  exitCode=1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
exitCode=$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $exitCode
