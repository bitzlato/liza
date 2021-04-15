# frozen_string_literal: true

require_relative 'boot'

require File.expand_path('boot', __dir__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Liza
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Europe/Moscow'
    config.i18n.default_locale = ENV.fetch('RAILS_LOCALE', :en)
    config.autoload_paths += Dir[
      "#{Rails.root}/app/reports",
      "#{Rails.root}/app/forms",
      "#{Rails.root}/app/errors",
      "#{Rails.root}/app/services",
      "#{Rails.root}/app/inputs",
      "#{Rails.root}/app/decorators",
    ]

    config.generators do |generate|
      generate.helper     false
      generate.assets     false
      generate.view_specs false
      generate.jbuilder   false
    end
  end
end
