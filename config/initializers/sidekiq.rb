# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq'
Sidekiq.default_worker_options = { 'backtrace' => true }

if Rails.env.development? || Rails.env.production? || Rails.env.staging? || ENV['SIDEKIQ_ASYNC']

  Sidekiq.logger = ActiveSupport::Logger.new Rails.root.join './log/sidekiq.log'
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV.fetch('LIZA_SIDEKIQ_REDIS_URL', 'redis://localhost:6379/3') }
    Sidekiq.logger.info "Configure server for application #{AppVersion}"
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV.fetch('LIZA_SIDEKIQ_REDIS_URL', 'redis://localhost:6379/3') }
    Sidekiq.logger.info "Configure server for application #{AppVersion}"
  end

elsif Rails.env.test?
  require 'sidekiq/testing/inline'
  Sidekiq::Testing.fake!
else

  raise "Not supported env #{Rails.env}"
end
