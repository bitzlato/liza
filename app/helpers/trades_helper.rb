module TradesHelper
  def present_trades(trades)
    trades.map { |trade| present_trade trade }.join('; ').html_safe.presence || content_tag(:span, t('.no_trades'), class: 'text-muted')
  end

  def present_trade(trade)
    link_to trade_path(trade), title: "trade_id: #{trade.id}" do
      (
        trade.taker_type + ' ' +
        format_money(trade.amount, trade.maker_order.ask, show_currency: true) +
        ' for ' +
        format_money(trade.price, trade.maker_order.bid, show_currency: true) +
        ' (total=' + format_money(trade.total, trade.maker_order.bid, show_currency: true) + ')'
      ).html_safe
    end
  end
end
