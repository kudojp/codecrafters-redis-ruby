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
    loop do
      new_socket = server.accept
      Thread.new do
        socket = new_socket
        puts "handling socket #{socket.object_id} in thread #{Thread.current.object_id}"

        loop do
          begin
            socket.recv(MAX_COMMAND_LENGTH)
          rescue Errno::ECONNRESET
            puts "The connection is probably terminated by the client."
            break
          end
          
          begin
            socket.write("+PONG\r\n")
          rescue Errno::ECONNRESET, Errno::EPIPE
            puts "The connection is terminated by the client."
            break
          end
        end
        # socket.close
      end
    end
  end
end

YourRedisServer.new(6379).start
