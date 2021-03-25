Rails.configuration.database_support_json = \
  ActiveRecord::Base.configurations[Rails.env][:support_json]
