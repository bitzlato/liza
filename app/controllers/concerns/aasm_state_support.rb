# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module AasmStateSupport
  extend ActiveSupport::Concern

  included do
    helper_method :aasm_state
  end

  private

  def aasm_state
    params.dig(:q, :aasm_state_eq)
  end
end
