# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module LiabilitiesHelper
  # rubocop:disable Metrics/MethodLength
  def present_liability_reference(reference)
    case reference
    when OrderBid
      present_order_bid(reference)
    when OrderAsk
      present_order_ask(reference)
    when Deposit
      present_deposit(reference)
    when Withdraw
      present_withdraw(reference)
    when Trade
      present_trade(reference)
    when Adjustment
      present_adjustment(reference)
    when InternalTransfer
      present_internal_transfer(reference)
    when nil
      '-'
    else
      raise "Unknown liability reference #{reference.class}"
    end
  end
  # rubocop:enable Metrics/MethodLength

  def present_wallet(wallet)
    link_to wallet_path(wallet) do
      "wallet[#{wallet.id}:#{wallet.kind}]".html_safe
    end
  end

  def present_internal_transfer(internal_transfer)
    "internal transfer #{internal_transfer.id}"
  end

  def present_payment_address(payment_address)
    "payment_addresss[member:#{link_to payment_address.member.uid, member_path(payment_address.member)},#{present_blockchain(payment_address.blockchain)}]"
  end

  def present_blockchain(blockchain)
    link_to blockchain_path(blockchain) do
      "blockchain[#{blockchain.id}:#{blockchain.key}]".html_safe
    end
  end

  def present_adjustment(adjustment)
    link_to adjustment_path(adjustment) do
      ('adjustment: ' + format_money(adjustment.amount, adjustment.currency) + ' -> ' + adjustment.receiving_account_number).html_safe
    end
  end

  def present_deposit(deposit)
    link_to deposit_path(deposit) do
      "deposit##{deposit.id}&nbsp;#{format_money(deposit.amount, deposit.currency)}".html_safe
    end
  end

  def present_withdraw(withdraw)
    link_to withdraw_path(withdraw) do
      "withdraw##{withdraw.id}&nbsp;#{format_money(withdraw.amount, withdraw.currency)}".html_safe
    end
  end
end
