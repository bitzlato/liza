# frozen_string_literal: true

require 'net/http'
module Net
  class HTTP < Protocol
    alias default_timeout_initializer initialize
    def initialize(address, port = nil)
      default_timeout_initializer(address, port)
      # @keep_alive_timeout = 2
      @open_timeout = 1
      @read_timeout = 1
      @continue_timeout = 1
      @ssl_timeout = 1
    end
  end
end
