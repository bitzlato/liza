module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
  end

  def active_class(css_classes, flag)
    flag ? css_classes + ' active' : css_classes
  end

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
    else
      raise "Unknown liability reference #{reference}"
    end
  end

  def present_trades(trades)
    trades.map { |trade| present_trade trade }.join('; ').html_safe
  end

  def present_trade(trade)
    link_to trade_path(trade), title: "trade_id: #{trade.id}" do
      (trade.taker_type + ' ' + format_money(trade.amount, trade.maker_order.bid) + ' for ' + format_money(trade.price, trade.maker_order.ask) + ' (total=' + format_money(trade.total, trade.maker_order.ask) + ')').html_safe
    end
  end

  def present_deposit(deposit)
    ('deposit<br>' + format_money(deposit.amount, deposit.currency)).html_safe
  end

  def present_withdraw(withdraw)
    ('withdraw<br>' + format_money(deposit.amount, deposit.currency)).html_safe
  end

  def present_order_bid(order)
    ('order bid<br>' + format_money(order.price * order.volume, order.currency)).html_safe
  end

  def present_order_ask(order)
    ('order ask<br>' + format_money(order.volume, order.currency)).html_safe
  end

  def column_tip(buffer)
    content_tag :small, buffer, class: 'text-small text-monospace text-nowrap'
  end

  def back_link(url = nil)
    link_to '&larr; назад на глаавную'.html_safe, url || root_url
  end

  def format_divergence(amount, currency)
    if amount.zero?
      format_money amount, currency
    else
      format_money amount, currency, css_class: 'text-warning', tooltip: "Должно быть 0"
    end
  end

  def compare_amounts(estimated, actual)
    return [:nagative, actual - estimated] if estimated > actual
    return [:positive, actual - estimated] if actual > estimated
    return nil
  end

  def format_money(amount, currency, css_class: nil, tooltip: nil)
    currency = currency.is_a?(Currency) ? currency : Currency.find(currency)
    css_classes = ['text-nowrap', 'text-monospace']
    css_classes << css_class
    content_tag :span, class: css_classes.join(' '), title: tooltip, data: { toggle: :tooltip } do
      # TODO Взять число после запятой с валюты
      amount == 0 ? '0' : "%0.#{currency.precision}f" % amount
    end
  end

  def format_currency(currency_id)
    content_tag :span, currency_id.to_param, class: 'text-uppercase text-monospace'
  end
end
