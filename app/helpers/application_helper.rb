module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
  end

  def column_tip(buffer)
    content_tag :small, buffer, class: 'text-small text-monospace text-nowrap'
  end

  def back_link
    link_to '&larr; назад на глаавную'.html_safe, root_url
  end

  def compare_amounts(estimated, actual)
    return [:nagative, actual - estimated] if estimated > actual
    return [:positive, actual - estimated] if actual > estimated
    return nil
  end

  def format_money(amount, currency_id, comparison = nil)
    currency_id = currency_id.id if currency_id.is_a? Currency
    css_classes = ['text-nowrap', 'text-monospace']
    if comparison.present?
      css_classes << 'text-warning'
      title = "Разница #{comparison.second}"
    end
    content_tag :span, class: css_classes.join(' '), title: title, data: { toggle: :tooltip } do
      # TODO Взять число после запятой с валюты
      amount == 0 ? '0' : "%0.8f" % amount
    end
  end

  def format_currency(currency_id)
    content_tag :span, currency_id, class: 'text-uppercase text-monospace'
  end
end
