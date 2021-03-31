module LiabilitiesHelper
  def present_liability_reference(reference)
    case reference
    when OrderBid
      then present_order_bid(reference)
    when OrderAsk
      then present_order_ask(reference)
    when Deposit
      then present_deposit(reference)
    when Withdraw
      then present_withdraw(reference)
    when Trade
      then present_trade(reference)
    when nil
      then '-'
    else
      raise "Unknown liability reference #{reference.class}"
    end
  end

  def present_deposit(deposit)
    ('deposit<br>' + format_money(deposit.amount, deposit.currency)).html_safe
  end

  def present_withdraw(withdraw)
    ('withdraw<br>' + format_money(withdraw.amount, withdraw.currency)).html_safe
  end
end
