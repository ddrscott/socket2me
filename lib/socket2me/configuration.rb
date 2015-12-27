module Socket2me

  class Configuration
    # @attr [String] ws_host for the WebSocket listener
    attr_accessor :ws_host

    # @attr [String] ws_port for the WebSocket listener
    attr_accessor :ws_port

    def initialize
      @ws_host = '0.0.0.0'
      @ws_port = '3001'
    end
  end

  # @yield [Configuration]
  def self.configure(&block)
    @config ||= Configuration.new
    if block_given?
      block.call @config
    end
  end

  # @return [Configuration] current configuration
  def self.config
    @config
  end
end
