#!/usr/bin/env sh
bundle exec rake db:migrate

exec "$@"