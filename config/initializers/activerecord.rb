Rails.configuration.database_support_json = \
  ActiveRecord::Base.configurations[Rails.env][:support_json]
Rails.configuration.database_adapter = \
  ActiveRecord::Base.configurations[Rails.env][:adapter]
