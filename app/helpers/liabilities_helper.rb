# frozen_string_literal: true

module LiabilitiesHelper
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
    when nil
      '-'
    else
      raise "Unknown liability reference #{reference.class}"
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
