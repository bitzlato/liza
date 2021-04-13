# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.default_url_options = Settings.default_url_options.symbolize_keys

  include CurrentUser
  include RescueErrors
  include PaginationSupport
  include RansackSupport
  include ShowAction

  skip_before_action :verify_authenticity_token if Rails.env.development?

  layout 'application'

  private

  def model_class
    self.class.name.remove('Controller').singularize.constantize
  end
end
