# encoding: UTF-8
# frozen_string_literal: true

class Beneficiary < ApplicationRecord

  # == Constants ============================================================

  extend Enumerize

  STATES_MAPPING = { pending: 0, active: 1, archived: 2, aml_processing: 3, aml_suspicious: 4 }.freeze

  STATES = %i[pending aml_processing aml_suspicious active archived].freeze
  STATES_AVAILABLE_FOR_MEMBER = %i[pending active]

  PIN_LENGTH  = 6
  PIN_RANGE   = 10**5..10**Beneficiary::PIN_LENGTH

  INVALID_ADDRESS_SYMBOLS = /[\<\>\'\,\[\]\}\{\"\)\(\*\&\^\%\$\#\`\~\{\}\@]/.freeze

  # == Extensions ===========================================================

  enumerize :state, in: STATES_MAPPING, scope: true
  # == Relationships ========================================================

  belongs_to :currency, required: true
  belongs_to :member, required: true
  # == Scopes ===============================================================

  scope :available_to_member, -> { with_state(:pending, :active) }

  def to_s
    name
  end

  def masked_account_number
    account_number = data.symbolize_keys[:account_number]

    if data.present? && account_number.present?
      account_number.sub(/(?<=\A.{2})(.*)(?=.{4}\z)/) { |match| '*' * match.length }
    end
  end

  def masked_data
    data.merge(account_number: masked_account_number).compact if data.present?
  end

  private

  def coin_rid
    return unless currency.coin?
    data.symbolize_keys[:address]
  end

  def fiat_rid
    return unless currency.fiat?
    "%s-%s-%08d" % [data.symbolize_keys[:full_name].downcase.split.join('-'), currency_id.downcase, id]
  end
end

# == Schema Information
# Schema version: 20201125134745
#
# Table name: beneficiaries
#
#  id             :bigint           not null, primary key
#  member_id      :bigint           not null
#  currency_id    :string(10)       not null
#  name           :string(64)       not null
#  description    :string(255)      default("")
#  data_encrypted :string(1024)
#  pin            :integer          unsigned, not null
#  sent_at        :datetime
#  state          :integer          default("pending"), unsigned, not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_beneficiaries_on_currency_id  (currency_id)
#  index_beneficiaries_on_member_id    (member_id)
#
