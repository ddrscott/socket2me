# Stub/dummy handler to load javascript handler without needing to
# inject it into an existing response.
module Socket2me
  module Middleware
    class Stub < AddScriptTag
      def call(_)
        return 200, {}, [<<-HTML]
<html>
<body>
#{script_tag}
</body>
</html>
HTML
      end
    end
  end
end