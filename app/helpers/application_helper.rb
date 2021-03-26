module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
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

  def format_money(amount, currency_id, css_class: nil, tooltip: nil)
    currency_id = currency_id.id if currency_id.is_a? Currency
    css_classes = ['text-nowrap', 'text-monospace']
    css_classes << css_class
    content_tag :span, class: css_classes.join(' '), title: tooltip, data: { toggle: :tooltip } do
      # TODO Взять число после запятой с валюты
      amount == 0 ? '0' : "%0.8f" % amount
    end
  end

  def format_currency(currency_id)
    content_tag :span, currency_id.to_param, class: 'text-uppercase text-monospace'
  end
end
