# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module ActiveModel
  class Name
    def human_plural
      human count: 100
    end
  end
end
