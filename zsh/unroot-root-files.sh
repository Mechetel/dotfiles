# Вернуть текущему пользователю файлы, которые docker создал от root (работает на macOS и Linux).
unroot-root-files() {
  sudo find . -user root -exec chown "$(id -un):$(id -gn)" {} +
}
