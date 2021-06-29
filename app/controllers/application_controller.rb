# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.default_url_options = Settings.default_url_options.symbolize_keys

  include CurrentUser
  include RescueErrors

  skip_before_action :verify_authenticity_token if Rails.env.development?

  layout 'application'
end
