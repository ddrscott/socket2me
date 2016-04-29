require 'em-websocket'
require 'singleton'
require 'logger'

# Singleton wrapper class around an EM::WebSocket thread.
module Socket2me
  class WsServer
    include Singleton

    # initializes an empty client list
    def initialize
      @clients = []
    end

    # maps `Socket2me#config` options to `EM::WebSocket` options
    # @return [Hash] hash of options compatible with EM::WebSocket#start
    def ws_options
      {
        host: Socket2me.config.ws_host,
        port: Socket2me.config.ws_port
      }
    end

    # sends a message to all connected clients
    # @param [String] msg to send to all the clients
    def send_to_clients(msg)
      EM.schedule do
        @clients.each do |socket|
          socket.send msg
        end
      end
    end

    def log(text)
      Socket2me.config.logger.debug "[WsServer] #{text}"
    end

    # Start the EM::WebSocket thread.
    # The server
    def start
      @thread = Thread.new do
        EM::WebSocket.start(ws_options) do |ws|
          ws.onopen do |handshake|
            log "onopen: #{handshake.headers}"
            @clients << ws
          end

          ws.onclose do |event|
            log "closed: #{event}"
            @clients.delete ws
          end

          ws.onmessage do |msg|
            log "received: #{msg}"
          end
        end
      end
    end
  end
end
