require 'em-websocket'

module Socket2me
  module Middleware
    class AddScriptTag
      def initialize(app)
        @app = app
        @ws_url = "ws://#{Socket2me.config.ws_host}:#{Socket2me.config.ws_port}"
      end

      # 1. look for a text/html response type from parent app.
      # 2. replace the closing `</body>` with the WebSocket client code.
      #
      # @param [Hash] env about Rack environment and the request
      # @return [String, Hash, Array[String]]
      def call(env)
        response = @app.call(env)
        status, headers, body = *response

        return response unless headers['Content-Type'] == 'text/html'

        # replace the last body with script
        new_body = body.join.gsub(%r{(</body>)}i, "#{script_tag}\\1")

        [status, headers, [new_body]]
      end

      # @return [String] the outer Javascript tag with WS client script
      def script_tag
        <<-HTML
<script>
(function (ws) {
    ws.onmessage = function (msg) {
      new Function(msg.data)();
    }
})(new WebSocket("#{@ws_url}"));
</script>
        HTML
      end
    end
  end
end
