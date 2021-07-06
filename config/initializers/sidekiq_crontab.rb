# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

CRONTAB_FILE = './config/sidekiq_crontab.yml'

if Rails.env.staging? || Rails.env.production? || ENV.true?('LOAD_SIDEKIQ_CRONTAB')
  Sidekiq::Cron::Job.destroy_all!
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(CRONTAB_FILE)
end
