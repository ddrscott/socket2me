require 'json'
require 'erb'

module Socket2me
  module Middleware
    class AddScriptTag
      def initialize(app, options={})
        @app = app
        @ws_port = options[:ws_port] || '3001'
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
        js_erb = IO.read(File.join(__dir__, 'ws_client.js.erb'))
        js = ERB.new(js_erb).result(binding)
        "<script>#{js}</script>"
      end
    end
  end
end