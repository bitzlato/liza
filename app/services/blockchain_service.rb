
class BlockchainService
  SCAN_URLS = {
    'eth-mainnet' => 'https://api.etherscan.io/api?module=proxy&action=eth_blockNumber&apikey=#{API_KEY}',
    'bsc-mainnet' => 'https://api.bscscan.com/api?module=proxy&action=eth_blockNumber&apikey=#{API_KEY}',
    # 'heco-mainnet' => ''
  }

  def initialize(blockchain)
    @blockchain = blockchain
  end

  def scan_latest_block
    return nil unless scan_url
    Rails.cache.fetch [:v2, :blockchain_service, blockchain.key, :scan_latest_block], expires_in: 30.seconds do
      JSON.parse(URI.open(scan_url).read).
        fetch('result').
        to_i(16)
    end
  rescue OpenSSL::SSL::SSLError, Net::OpenTimeout => err
    report_exception err, true, blockchain_key: blockchain.key
    nil
  end

  def scan_host
    return if scan_url.nil?
    URI(scan_url).host
  end

  private

  attr_reader :blockchain

  def scan_url
    url = SCAN_URLS.fetch(blockchain.key.to_s, nil)
    return if url.nil?
    url.to_s.gsub('#{API_KEY}', scan_api_key.to_s)
  end

  def scan_api_key
    Rails.application.credentials.scan_api_keys[blockchain.key.to_sym]
  end

  def scan_api_key_name
    blockchain.key.to_s.split('-')
  end
end
