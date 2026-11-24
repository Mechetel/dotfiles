grep_and_rm () {
  grep -le "$1" **/*.rake **/*.rb | tr '\n' '\0' | xargs -0 rm
}
