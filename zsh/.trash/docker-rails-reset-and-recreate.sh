docker-rails-recreate-db () {
  docker-compose run --rm "$1" bash -c '\
    rake db:drop \
    && rake db:create \
    && (rake db:migrate || true) \
    && rake db:seed \
    && rake db:schema:dump'
}

docker-rails-recreate-db-lite () {
  docker-compose run --rm "$1" bash -c '\
    rake db:drop \
    && rake db:create \
    && rake db:migrate'
}

docker-rails-reset-sessions () {
  docker-compose run --rm "$1" rake tmp:clear
}
