# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :user, 'app'

set :rails_env, :staging
set :disallow_pushing, false
set :linked_files, %w[.env config/master.key config/settings.yml config/credentials.yml.enc]
set :application, -> { 'liza-' + fetch(:stage).to_s }
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:stage)}/#{fetch(:application)}" }
set :puma_bind, -> { "unix://#{shared_path}/tmp/sockets/puma.sock" }

server ENV.fetch('STAGING_SERVER'),
  user: fetch(:user),
  port: '22',
  roles: %w[app db].freeze,
  ssh_options: { forward_agent: true }