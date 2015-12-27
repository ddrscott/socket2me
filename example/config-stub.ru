$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'socket2me'
run Socket2me::Middleware::Stub.new(nil, ws_port: 3002)
