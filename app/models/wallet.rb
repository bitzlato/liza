# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Wallet < ApplicationRecord
  extend Enumerize

  # We use this attribute values rules for wallet kinds:
  # 1** - for deposit wallets.
  # 2** - for fee wallets.
  # 3** - for withdraw wallets (sorted by security hot < warm < cold).
  ENUMERIZED_KINDS = { deposit: 100, fee: 200, hot: 310, warm: 320, cold: 330 }.freeze
  enumerize :kind, in: ENUMERIZED_KINDS, scope: true

  SETTING_ATTRIBUTES = %i[uri secret].freeze

  SETTING_ATTRIBUTES.each do |attribute|
    define_method attribute do
      settings[attribute.to_s]
    end

    define_method "#{attribute}=".to_sym do |value|
      self.settings = settings.merge(attribute.to_s => value)
    end
  end

  NOT_AVAILABLE = 'N/A'

  belongs_to :blockchain, foreign_key: :blockchain_key, primary_key: :key
  has_and_belongs_to_many :currencies

  scope :active,   -> { where(status: :active) }
  scope :deposit,  -> { where(kind: kinds(deposit: true, values: true)) }
  scope :fee,      -> { where(kind: kinds(fee: true, values: true)) }
  scope :withdraw, -> { where(kind: kinds(withdraw: true, values: true)) }
  scope :with_currency, ->(currency) { joins(:currencies).where(currencies: { id: currency }) }
  scope :ordered, -> { order(kind: :asc) }

  class << self
    def kinds(options = {})
      ENUMERIZED_KINDS
        .yield_self do |kinds|
          if options.fetch(:deposit, false)
            kinds.select { |_k, v| v / 100 == 1 }
          elsif options.fetch(:fee, false)
            kinds.select { |_k, v| v / 100 == 2 }
          elsif options.fetch(:withdraw, false)
            kinds.select { |_k, v| v / 100 == 3 }
          else
            kinds
          end
        end
        .yield_self do |kinds|
          if options.fetch(:keys, false)
            kinds.keys
          elsif options.fetch(:values, false)
            kinds.values
          else
            kinds
          end
        end
    end

    def deposit_wallet(currency_id)
      Wallet.active.deposit.joins(:currencies).find_by(currencies: { id: currency_id })
    end
  end

  def current_balance(currency = nil)
    if currency.present?
      WalletService.new(self).load_balance!(currency)
    else
      currencies.each_with_object({}) do |c, balances|
        balances[c.id] = WalletService.new(self).load_balance!(c)
      rescue StandardError => e
        report_exception(e)
        balances[c.id] = NOT_AVAILABLE
      end
    end
  rescue StandardError => e
    report_exception(e)
    NOT_AVAILABLE
  end
end
