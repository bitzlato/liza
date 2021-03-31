module ApplicationHelper
  def app_title
    I18n.t 'titles.application'
  end

  def active_class(css_classes, flag)
    flag ? css_classes + ' active' : css_classes
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

  # @param amount Decimal
  # @param currency [Currency, String]
  # @param options [Hash] :tooltip, :css_class, :show_currency
  def format_money(amount, currency, options = {})
    options = options.symbolize_keys.reverse_merge show_currency: true
    currency = currency.is_a?(Currency) ? currency : Currency.find(currency)
    css_classes = ['text-nowrap', 'text-monospace']
    css_classes << options[:css_class]
    buffer = amount == 0 ? '0' : "%0.#{currency.precision}f" % amount
    buffer << format_currency(currency, css_class: 'text-muted ml-1') if options[:show_currency]
    content_tag :span, class: css_classes.join(' '), title: options[:tooltip], data: { toggle: :tooltip } do
      buffer.html_safe
    end
  end

  def format_currency(currency_id, css_class: '')
    content_tag :span, currency_id.to_param, class: "text-uppercase text-monospace #{css_class}"
  end
end
