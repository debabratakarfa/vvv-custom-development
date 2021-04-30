#!/usr/bin/env bash
# @description WP CLI
set -eo pipefail

function wp_cli_setup() {
  vvv_info " * Installing/updating WP-CLI"
  # WP-CLI Install
  local exists_wpcli

  # Remove old wp-cli symlink, if it exists.
  if [[ -L "/usr/local/bin/wp" ]]; then
    vvv_info " * Removing old wp-cli symlink"
    rm -f /usr/local/bin/wp
  fi

  if [[ ! -f "/usr/local/bin/wp" ]]; then
    vvv_info " * Downloading wp-cli nightly, see <url>http://wp-cli.org</url>"
    wget http://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar --no-check-certificate
    chmod +x wp-cli-nightly.phar
    mv wp-cli-nightly.phar /usr/local/bin/wp

    vvv_success " * WP CLI Nightly Installed"

    vvv_info " * Grabbing WP CLI bash completions"
    # Install bash completions
    mkdir -p /srv/config/wp-cli/
    vvv_info " * Downloading WP CLI bash completions"
    wget http://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash --no-check-certificate
    mv wp-completion.bash /srv/config/wp-cli/
    chown vagrant /srv/config/wp-cli/wp-completion.bash
  fi
  
}
export -f wp_cli_setup

vvv_add_hook after_packages wp_cli_setup
