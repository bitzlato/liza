# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ResourcesController < ApplicationController
  self.default_url_options = Settings.default_url_options.symbolize_keys

  include PaginationSupport
  include RansackSupport
  include ShowAction
  include IndexFormSupport

  layout 'fluid'

  helper_method :model_class

  private

  def model_class
    self.class.name.remove('Controller').singularize.constantize
  end
end
