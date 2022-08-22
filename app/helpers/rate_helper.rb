module RateHelper
  def whaler_client
    @whaler_client ||= WhalerClient.new(base_url: ENV.fetch('WHALER_API_URL'))
  end

  def current_rates(default_rate = 'USD')
    @current_rates ||= whaler_client.rates(default_rate).yield_self do |data|
      data['rates'].transform_keys!(&:downcase)
      data
    end
  end

  def get_rate_for(currency_id)
    current_rates['rates'][currency_id]
  end
end
