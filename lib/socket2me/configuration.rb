require 'logger'

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

    # @return [Logger] a basic STDOUT logger if one hasn't been set
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # @param [Logger] logger to use
    attr_writer :logger
  end

  # @yield [Configuration]
  def self.configure(&block)
    @config ||= Configuration.new
    block.call @config if block_given?
  end

  # @return [Configuration] current configuration
  def self.config
    @config
  end
end
