#!/usr/bin/env bash
set -euo pipefail

readonly image="${QGIS_IMAGE:-docker.io/qgis/qgis:4.2.1}"
readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly workspace_dir="$(cd "$script_dir/../.." && pwd)"
readonly data_dir="${QGIS_DATA_DIR:-$workspace_dir/.local/qgis}"
readonly storage_dir="$data_dir/containers/storage"
readonly profile_dir="$data_dir/home"
readonly runtime_base="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
readonly runroot="$runtime_base/qgis-podman"

if ! command -v podman >/dev/null 2>&1; then
  echo "Podman is required but is not installed." >&2
  exit 1
fi

mkdir -p "$storage_dir" "$profile_dir" "$runroot"

podman_command=(
  podman
  --root "$storage_dir"
  --runroot "$runroot"
)

case "${1:-run}" in
  install)
    "${podman_command[@]}" pull "$image"
    ;;
  version)
    version_arguments=(
      --rm
      --pull=never
      --env LANG=C.UTF-8
      --env LC_ALL=C.UTF-8
    )
    "${podman_command[@]}" run "${version_arguments[@]}" "$image" qgis --version
    ;;
  run)
    if [[ -z "${DISPLAY:-}" ]]; then
      echo "DISPLAY is not set. Start QGIS from the desktop session." >&2
      exit 1
    fi
    if [[ -z "${XAUTHORITY:-}" || ! -r "$XAUTHORITY" ]]; then
      echo "XAUTHORITY does not identify a readable X11 authority file." >&2
      exit 1
    fi
    if [[ ! -d /tmp/.X11-unix ]]; then
      echo "The X11 display socket directory is not available." >&2
      exit 1
    fi

    run_arguments=(
      --rm
      --pull=never
      --name qgis-4.2.1
      --security-opt=no-new-privileges
      --env "DISPLAY=$DISPLAY"
      --env XAUTHORITY=/tmp/.Xauthority
      --env QT_X11_NO_MITSHM=1
      --env LANG=C.UTF-8
      --env LC_ALL=C.UTF-8
      --volume "$XAUTHORITY:/tmp/.Xauthority:ro"
      --volume /tmp/.X11-unix:/tmp/.X11-unix:ro
      --volume "$profile_dir:/root"
      --volume "$workspace_dir:/workspace"
    )

    if [[ -d /dev/dri ]]; then
      run_arguments+=(--device /dev/dri --group-add keep-groups)
    fi

    exec "${podman_command[@]}" run "${run_arguments[@]}" "$image" qgis
    ;;
  *)
    echo "Usage: ${0##*/} {install|run|version}" >&2
    exit 2
    ;;
esac
