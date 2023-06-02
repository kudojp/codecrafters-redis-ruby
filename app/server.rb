require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)
    socket = server.accept
    socket.write("+PONG\r\n")
  end
end

YourRedisServer.new(6379).start
