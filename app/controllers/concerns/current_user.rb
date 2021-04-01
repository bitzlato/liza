# frozen_string_literal: true

module CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    before_action :authenticate!
  end

  private

  def authenticate!
    redirect_to Settings.signin_url unless current_user.present?
  end

  def current_user
    @current_user ||= load_current_user
  end

  def load_current_user
    # jwt.payload provided by rack-jwt
    unless request.env.key?('jwt.payload')
      Rails.logger.error 'No JWT payload to authenticate'
      return
    end

    payload = request.env['jwt.payload'].symbolize_keys
    unless payload[:state] == 'active'
      Rails.logger.warn "Wrong user state (#{payload[:state]})"
      return
    end

    Member.find_by(uid: payload[:uid])
  end
end
