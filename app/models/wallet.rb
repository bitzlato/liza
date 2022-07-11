# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Wallet < PeatioRecord
  extend Enumerize

  # We use this attribute values rules for wallet kinds:
  # 1** - for deposit wallets.
  # 2** - for fee wallets.
  # 3** - for withdraw wallets (sorted by security hot < warm < cold).
  ENUMERIZED_KINDS = { deposit: 100, fee: 200, hot: 310, warm: 320, cold: 330, standalone: 400 }.freeze
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

  belongs_to :blockchain
  has_and_belongs_to_many :currencies
  has_many :currency_wallets

  scope :active,   -> { where(status: :active) }
  scope :deposit,  -> { where(kind: kinds(deposit: true, values: true)) }
  scope :fee,      -> { where(kind: kinds(fee: true, values: true)) }
  scope :hot,      -> { where(kind: kinds(hot: true, values: true)) }
  scope :withdraw, -> { where(kind: kinds(withdraw: true, values: true)) }
  scope :with_currency, ->(currency) { joins(:currencies).where(currencies: { id: currency }) }
  scope :ordered, -> { order(kind: :asc) }
  scope :standalone, -> { where kind: :standalone }

  class << self
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Style/MultilineBlockChain
    def kinds(options = {})
      ENUMERIZED_KINDS
        .yield_self do |kinds|
          if options.fetch(:deposit, false)
            kinds.select { |_k, v| [1, 4].include? v / 100 }
          elsif options.fetch(:fee, false)
            kinds.select { |_k, v| v / 100 == 2 }
          elsif options.fetch(:withdraw, false)
            kinds.select { |_k, v| [3, 4].include? v / 100 }
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
    # rubocop:enable Style/MultilineBlockChain
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength

    def deposit_wallet(currency_id)
      Wallet.active.deposit.with_currency(currency_id).take
    end

    def withdraw_wallet(currency_id)
      Wallet.active.withdraw.with_currency(currency_id).take
    end

    def find_by_address(address)
      where('lower(address)=?', address.downcase).take
    end

    def balances
      Wallet.all.each_with_object({}) { |w, a| w.available_balances.each_pair { |c, b| a[c] ||= 0.0; a[c] += b.to_d } }
    end
  end

  def to_s
    'wallet#' + id.to_s
  end

  def balances_by_transactions
    plus = blockchain.transactions.success.where(to_address: address.downcase).group(:currency_id).sum(:amount)
    minus = blockchain.transactions.success.where(from_address: address.downcase).group(:currency_id).sum(:amount)
    minus_fee = blockchain.transactions.where(from_address: address.downcase).failed_or_success.group(:fee_currency_id).sum(:fee)
    (plus.keys + minus.keys + minus_fee.keys).uniq.compact.each_with_object({}) do |currency_id, agg|
      agg[currency_id] = plus.fetch(currency_id, 0.0) - minus.fetch(currency_id, 0.0) - minus_fee.fetch(currency_id, 0.0)
    end
  end

  def available_balances
    (balance || {}).slice(*currency_wallets.where(use_in_balance: true).pluck(:currency_id))
  end

  def transactions
    # TODO: blockchain normalize
    blockchain.transactions.by_address(address.downcase)
  end

  def fee_amount
    transactions.accountable_fee.sum(:fee)
  end

  def native_currency
    currencies.find { |c| c.parent_id.nil? } || raise("No native currency for wallet id #{id}")
  end

  def fetch(_key)
    # not implemented
  end

  def address_url
    blockchain&.explore_address_url address
  end
end
