# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.default_url_options = Settings.default_url_options.symbolize_keys
  http_basic_authenticate_with **Rails.application.credentials.dig(:http_basic_auth) # if Rails.env.production?

  include CurrentUser
  include RescueErrors

  skip_before_action :verify_authenticity_token if Rails.env.development?

  helper_method :system_balances

  layout 'application'

  def system_balances
    @system_balances ||= Wallet.active.each_with_object({}) { |w, a| w.available_balances.each_pair { |c, b| a[c] ||= 0.0; a[c] += b.to_d } } # rubocop:disable Style/Semicolon
  end
end
