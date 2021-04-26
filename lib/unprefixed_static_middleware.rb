class UnprefixedStaticMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    %w(PATH_INFO REQUEST_URI REQUEST_PATH).each do |key|
      env[key].gsub!(Settings.root_prefix + '/uploads/', '/uploads/') if env[key].present?
    end
    @app.call(env)
  end
end
