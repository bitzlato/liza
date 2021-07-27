# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class AssetDecorator < ApplicationDecorator
    delegate_all
    def reference
      h.present_liability_reference object.reference
    end
  end
end
