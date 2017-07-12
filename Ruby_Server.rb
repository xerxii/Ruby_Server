#!/usr/bin/env ruby
# encoding: utf-8

require 'socket'

begin
  require 'enum'
rescue LoadError
  puts("The enum gem is required for this program")
  exit(1)
end

# Defaults for Server Config, intended to be 'safe'.
Config = {
  Socket_Type=>'TCP',
  Process_Type=>'Threading',
  Connection_Limit=>10
}


class SocketError < StandardError
end


class TCP_Server < Socket
  # Connections are the amount of connections you will allow.
  # This also determines Thread instances
  # Data is the data you shall serve people connecting.
  def initialize(port, connections, config, data)
    @port = port
    @connections = connections
    @config = config
    @data = data
    
    
    @socket = TCPServer.new('0.0.0.0', @port)
    
  end
  
  def Handle_connection(client)
    puts("A client has connected")
    
    client.write(@data)
    client.close
  end
  
  def Listen  
    connected = 0   
    # While the socket is open, and connections do not reach limit
    # Create a thread instance to handle the connection
    while (client == @socket.accept) & (connected <= @connections)
      Thread.new { Server.handle_connection(client) ; connected += 1 }
      
      if (client == @socket.close)
        return connected -= 1
    end
  end
    
  def Kill
    return exit(0)
  end 
  
  def Quit
    return @socket.close
  end
  
end

