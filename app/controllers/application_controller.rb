# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.default_url_options = Settings.default_url_options.symbolize_keys

  include CurrentUser
  include RescueErrors
  include HidedColumns

  skip_before_action :verify_authenticity_token if Rails.env.development?

  before_action :authenticate

  layout 'application'

  private

  def authenticate
    raise HumanizedError, 'Not authenticated' unless current_user.present?
  end
end
