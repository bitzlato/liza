# frozen_string_literal: true

set :stage, :b
set :rails_env, :staging
fetch(:default_env)[:rails_env] = :staging
set :user, 'app'
set :application, -> { 'liza-' + fetch(:stage).to_s }
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:stage)}/#{fetch(:application)}" }

server ENV.fetch('STAGING_SERVER'), user: fetch(:user), roles: fetch(:roles)
