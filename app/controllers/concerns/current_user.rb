# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= load_current_user
  end

  def load_current_user
    if ENV.true? 'FORCED_MEMBER_UID'
      return Member.find_by(uid: ENV['FORCED_MEMBER_UID']) || Member.new(uid: ENV['FORCED_MEMBER_UID'],
                                                                         role: 'superadmin').freeze
    end

    unless request.env.key?('jwt.payload') # jwt.payload provided by rack-jwt
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
