# Give the current user back files that docker created as root (works on macOS and Linux).
unroot-root-files() {
  sudo find . -user root -exec chown "$(id -un):$(id -gn)" {} +
}
