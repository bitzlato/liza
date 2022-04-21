# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Form for time ranged fields
#
class OperationAccountsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :exclude_bots, :boolean
end
