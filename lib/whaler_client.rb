# frozen_string_literal: true

class WhalerClient
  Error = Class.new StandardError
  WrongResponse = Class.new Error

  def initialize(base_url:, logger: false, adapter: nil)
    @base_url = base_url
    @adapter = adapter || Faraday.default_adapter

    if logger == true
      @logger = Faraday::Response::Logger.new(STDOUT)
    else
      @logger = logger.nil? || logger == false ? nil : logger
    end
  end

  def rates(target_currency)
    get('api/public/v1/rates', target_currency: target_currency.upcase)
  end

  def get(path, params = {})
    parse_response connection.get(path, params)
  end

  def post(path, params = {})
    parse_response connection.post(path, params.to_json)
  end

  private

  def parse_response(response)
    raise WrongResponse, "Wrong response status (#{response.status}) with body #{response.body}" unless response.success?
    return nil if response.body.empty?
    raise WrongResponse, "Wrong content type (#{response['content-type']})" if response['content-type'] != 'application/json'
    JSON.parse response.body
  end

  def connection
    Faraday.new url: @base_url do |c|
      c.use Faraday::Response::Logger unless @logger.nil?
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
      c.request :curl, @logger, :warn if ENV['BITZLATO_CURL_LOGGER']
      c.adapter @adapter
    end
  end
end
