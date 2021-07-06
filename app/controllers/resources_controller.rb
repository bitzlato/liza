# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ResourcesController < ApplicationController
  self.default_url_options = Settings.default_url_options.symbolize_keys

  include PaginationSupport
  include RansackSupport
  include ShowAction

  layout 'fluid'

  helper_method :model_class

  def show
    redirect_to url_for(model_class, id: params[:id])
  end

  private

  def model_class
    self.class.name.remove('Controller').singularize.constantize
  end
end
