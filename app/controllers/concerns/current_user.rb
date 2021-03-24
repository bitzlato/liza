module CurrentUser
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= load_current_user
  end

  def load_current_user
    # jwt.payload provided by rack-jwt
    raise 'No JWT payload to authenticate' unless request.env.key?('jwt.payload')

    payload = request.env['jwt.payload'].symbolize_keys
    raise "Wrong user state (#{payload[:state]})" unless payload[:state] == 'active'

    Member.find_by(uid: payload[:uid])
  end
end
