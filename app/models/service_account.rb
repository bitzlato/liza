# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# ServiceAccount model
class ServiceAccount < PeatioRecord
  UID_PREFIX = 'SI'

  belongs_to :user, foreign_key: 'owner_id', optional: true
  has_many :api_keys, as: :key_holder_account, dependent: :destroy, class_name: 'APIKey'

  scope :active, -> { where(state: 'active') }

  def active?
    state == 'active'
  end

  private

  def update_state
    !state_changed?
  end
end
