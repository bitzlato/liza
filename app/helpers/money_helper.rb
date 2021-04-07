module MoneyHelper
  MAX_PRECISION = 8

  def format_divergence(amount, currency)
    if amount.zero?
      format_money amount, currency
    else
      format_money amount, currency, css_class: 'text-warning', tooltip: 'Должно быть 0'
    end
  end

  def compare_amounts(estimated, actual)
    return [:nagative, actual - estimated] if estimated > actual
    return [:positive, actual - estimated] if actual > estimated

    nil
  end

  # @param amount Decimal
  # @param currency [Currency, String]
  # @param options [Hash] :tooltip, :css_class, :show_currency
  def format_money(amount, currency, options = {})
    options = options.symbolize_keys.reverse_merge show_currency: true
    currency = currency.is_a?(Currency) ? currency : Currency.find(currency)
    css_classes = %w[text-nowrap text-monospace]
    css_classes << options[:css_class]
    buffer = money_precission(amount, currency.precision)
    buffer += format_currency(currency, css_class: 'text-muted ml-1') if options[:show_currency]
    content_tag :span, class: css_classes.join(' '), title: options[:tooltip], data: { toggle: :tooltip } do
      buffer.html_safe
    end
  end

  def money_precission(amount, precision)
    return '0' if amount.zero?
    precised = format("%0.#{precision}f", amount)
    return precised if precised.to_d == amount
    format("%0.#{MAX_PRECISION}f", amount)
  end

  def format_currency(currency_id, css_class: '')
    content_tag :span, currency_id.to_param, class: "text-uppercase text-monospace #{css_class}"
  end
end
