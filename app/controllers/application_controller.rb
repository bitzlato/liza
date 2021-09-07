# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.default_url_options = Settings.default_url_options.symbolize_keys
  http_basic_authenticate_with **Rails.application.credentials.dig(:http_basic_auth) # if Rails.env.production?

  include CurrentUser
  include RescueErrors
  include HidedColumns

  skip_before_action :verify_authenticity_token if Rails.env.development?

  layout 'application'
end
