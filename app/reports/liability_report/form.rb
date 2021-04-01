# frozen_string_literal: true

module LiabilityReport
  # Form for liability report form
  class Form
    include ActiveModel::Model

    attr_accessor :time_from, :time_to
  end
end
