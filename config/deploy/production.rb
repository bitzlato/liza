# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :stage, :production
set :rails_env, :production
set :user, 'liza'
fetch(:default_env)[:rails_env] = :production

server ENV['PRODUCTION_SERVER'],
       user: fetch(:user),
       port: '22',
       roles: %w[sidekiq web app db bugsnag].freeze,
       ssh_options: { forward_agent: true }
