# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# ENV['SCHEMA'] = Rails.root.join('db', ['schema', ActiveRecord::Base.configurations[Rails.env].symbolize_keys[:adapter], 'rb'].join('.')).to_s
Rails.configuration.database_support_json = \
  ActiveRecord::Base.configurations[Rails.env][:support_json]
Rails.configuration.database_adapter = \
  ActiveRecord::Base.configurations[Rails.env][:adapter]
