# sqlite
# alias rails-recreate-db="rails db:migrate VERSION=0 && rails db:drop && rails db:migrate"

# postgre
alias rails-recreate-db="rails db:drop && rails db:create && rails db:migrate"
