# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Require JWT initializer to configure JWT key & options.
require_relative 'jwt'
require 'jwt/rack'

auth_args = {
  secret: Rails.configuration.x.jwt_public_key,
  options: Rails.configuration.x.jwt_options,
  verify: Rails.configuration.x.jwt_public_key.present?,
}

Rails.application.config.middleware.use JWT::Rack::Auth, auth_args unless ENV.true? 'DISABLE_JWT'
