# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Require JWT initializer to configure JWT key & options.
require_relative 'jwt'
require 'jwt/rack'

on_error = lambda do |error|
  message = 'jwt.decode_and_verify'
  body    = { errors: [message] }.to_json
  headers = { 'Content-Type' => 'application/json', 'Content-Length' => body.bytesize.to_s }

  report_exception error

  [401, headers, [body]]
end

# TODO: Fixme in jwt-rack handle api/v2// as api/v2.
auth_args = {
  secret: Rails.configuration.x.jwt_public_key,
  options: Rails.configuration.x.jwt_options,
  verify: Rails.configuration.x.jwt_public_key.present?,
  on_error: on_error
}

Rails.application.config.middleware.use JWT::Rack::Auth, auth_args unless ENV.true? 'DISABLE_JWT'
