require "socket"
class YourRedisServer
  MAX_COMMAND_LENGTH = 1024
  def initialize(port)
    @port = port
  end

  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)
    socket = server.accept
    loop do
      socket.recv(MAX_COMMAND_LENGTH)
      socket.write("+PONG\r\n")
    rescue Errno::ECONNRESET
      puts "The connection is terminated by the client."
      break
    end
    # socket.close
  end
end

YourRedisServer.new(6379).start
