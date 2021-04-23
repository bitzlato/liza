# frozen_string_literal: true

set :stage, :production
set :rails_env, :production
fetch(:default_env)[:rails_env] = :production

server ENV['PRODUCTION_SERVER'],
       user: fetch(:user),
       port: '22',
       roles: %w[sidekiq web app db bugsnag].freeze,
       ssh_options: { forward_agent: true }
