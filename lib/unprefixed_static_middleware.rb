# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class UnprefixedStaticMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    %w[PATH_INFO REQUEST_URI REQUEST_PATH].each do |key|
      next if env[key].blank?

      env[key] = env[key]
                 .gsub(Settings.root_prefix + '/uploads/', '/uploads/')
      # .gsub(Settings.root_prefix + '/assets/', '/assets/')
    end
    @app.call(env)
  end
end
