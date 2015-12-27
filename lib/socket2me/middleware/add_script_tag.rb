require 'json'
require 'erb'
require 'em-websocket'

module Socket2me
  module Middleware
    class AddScriptTag

      def initialize(app)
        @app = app
        @ws_url = "ws://#{Socket2me.config.ws_host}:#{Socket2me.config.ws_port}"
      end

      def call(env)
        response = @app.call(env)
        status, headers, body = *response

        return response unless headers['Content-Type'] == 'text/html'

        full_body = body.join

        # replace the last body with script
        full_body.gsub!(%r{(</body>)}i,"#{script_tag}\\1")

        return status, headers, [full_body]
      end

      def script_tag
        js = ERB.new(js_erb).result(binding)
        "<script>#{js}</script>"
      end


      def js_erb
        <<-JS
(function () {
    var socket = new WebSocket("<%= @ws_url %>");

    function log(message) {
        console.log.apply(console, arguments);
    }

    try {
        socket.onopen = function () {
            log("Socket Status: " + socket.readyState + " (open)");
        };

        socket.onclose = function () {
            log("Socket Status: " + socket.readyState + " (closed)");
        };

        socket.onmessage = function (msg) {
            try {
                // execute in an anonymous function
                new Function(msg.data)();
            } catch (msgEx){
                console.error("Could not execute `%s` due to %o", msg.data, msgEx);
            }
        }
    } catch (exception) {
        console.error("Error: " + exception);
    }
})();
        JS
      end
    end
  end
end