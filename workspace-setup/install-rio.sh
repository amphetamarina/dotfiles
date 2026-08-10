#!/usr/bin/env bash

set -Eeuo pipefail

readonly repo="raphamorim/rio"
readonly api_url="https://api.github.com/repos/${repo}/releases/latest"

for command_name in curl jq sha256sum dpkg dpkg-deb apt-get sudo; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'error: required command not found: %s\n' "$command_name" >&2
    exit 1
  fi
done

if [[ ! -r /etc/os-release ]]; then
  printf 'error: cannot identify this operating system\n' >&2
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
case "${ID:-}:${ID_LIKE:-}" in
  debian:*|ubuntu:*|*:debian*) ;;
  *)
    printf 'error: this installer supports Debian-family systems only\n' >&2
    exit 1
    ;;
esac

case "$(dpkg --print-architecture)" in
  amd64) architecture="amd64" ;;
  arm64) architecture="arm64" ;;
  *)
    printf 'error: Rio has no supported Debian package for architecture %s\n' \
      "$(dpkg --print-architecture)" >&2
    exit 1
    ;;
esac

case "${XDG_SESSION_TYPE:-}" in
  wayland) display_backend="wayland" ;;
  x11) display_backend="x11" ;;
  *)
    if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
      display_backend="wayland"
    elif [[ -n "${DISPLAY:-}" ]]; then
      display_backend="x11"
    else
      printf 'error: cannot determine whether this desktop uses Wayland or X11\n' >&2
      exit 1
    fi
    ;;
esac

temporary_directory="$(mktemp -d)"
trap 'rm -rf -- "$temporary_directory"' EXIT
# Let APT's unprivileged _apt user traverse the directory when it reads the
# verified local package. The directory contains public release files only.
chmod 755 "$temporary_directory"
metadata_file="${temporary_directory}/release.json"

printf 'Fetching the latest stable Rio release metadata...\n'
curl --fail --silent --show-error --location \
  --header 'Accept: application/vnd.github+json' \
  --header 'X-GitHub-Api-Version: 2022-11-28' \
  --output "$metadata_file" \
  "$api_url"

if [[ "$(jq -r '.draft' "$metadata_file")" != "false" ]] ||
   [[ "$(jq -r '.prerelease' "$metadata_file")" != "false" ]]; then
  printf 'error: GitHub returned a draft or prerelease; refusing to install\n' >&2
  exit 1
fi

version="$(jq -er '.tag_name | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$")) | ltrimstr("v")' "$metadata_file")"
asset_name="rioterm_${version}_${architecture}_${display_backend}.deb"
asset_url="$(jq -er --arg name "$asset_name" '.assets[] | select(.name == $name) | .browser_download_url' "$metadata_file")"
asset_digest="$(jq -er --arg name "$asset_name" '.assets[] | select(.name == $name) | .digest' "$metadata_file")"

if [[ "$asset_digest" != sha256:* ]]; then
  printf 'error: release asset has no SHA-256 digest; refusing to install\n' >&2
  exit 1
fi

package_file="${temporary_directory}/${asset_name}"
printf 'Downloading Rio v%s (%s, %s)...\n' "$version" "$architecture" "$display_backend"
curl --fail --silent --show-error --location \
  --output "$package_file" \
  "$asset_url"
chmod 644 "$package_file"

printf '%s  %s\n' "${asset_digest#sha256:}" "$package_file" | sha256sum --check --status
printf 'SHA-256 verification passed.\n'

package_name="$(dpkg-deb --field "$package_file" Package)"
package_version="$(dpkg-deb --field "$package_file" Version)"
package_architecture="$(dpkg-deb --field "$package_file" Architecture)"
if [[ "$package_name" != "rioterm" ]] ||
   [[ "${package_version%%-*}" != "$version" ]] ||
   [[ "$package_architecture" != "$architecture" ]]; then
  printf 'error: unexpected package identity: %s %s (%s)\n' \
    "$package_name" "$package_version" "$package_architecture" >&2
  exit 1
fi

printf 'Installing %s %s with APT...\n' "$package_name" "$package_version"
sudo apt-get install -- "$package_file"
printf 'Rio v%s installed successfully.\n' "$version"
