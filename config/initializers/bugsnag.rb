Bugsnag.configure do |config|
  config.app_version = AppVersion.format('%M.%m.%p') # rubocop:disable Style/FormatStringToken
  config.send_environment = true
  config.notify_release_stages = %w[production]
end
