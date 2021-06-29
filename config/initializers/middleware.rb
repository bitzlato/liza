# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

require 'unprefixed_static_middleware'
Rails.application.config.middleware.insert_before 0, UnprefixedStaticMiddleware
