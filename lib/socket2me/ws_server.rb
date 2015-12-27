require 'em-websocket'
require 'singleton'

module Socket2me
  class WsServer
    include Singleton

    def initialize
      @clients = []
    end

    def ws_options
      {
          host: Socket2me.config.ws_host,
          port: Socket2me.config.ws_port
      }
    end

    def send_to_clients(msg)
      EM.schedule do
        @clients.each do |socket|
          socket.send msg
        end
      end
    end

    def start
      @thread = Thread.new do
        EM::WebSocket.start(ws_options) do |ws|
          ws.onopen do |handshake|
            @clients << ws
            ws.send "console.log('Connected to #{handshake.path}.')"
          end

          ws.onclose do
            ws.send "console.log('Closed')"
            @clients.delete ws
          end

          ws.onmessage do |msg|
            puts "Received Message: #{msg}"
          end
        end
      end
    end
  end
end
