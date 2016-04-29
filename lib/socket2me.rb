require 'socket2me/version'
require 'socket2me/configuration'
require 'socket2me/middleware/add_script_tag'
require 'socket2me/ws_server'

module Socket2me
  def self.start_ws_server
    WsServer.instance.start
  end

  def self.exec_js(js)
    WsServer.instance.send_to_clients(js)
  end
end
