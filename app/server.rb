require "socket"
require "./app/server/command_line_executor"
require "./app/resp/command_line"
require "./app/resp/parser.rb"

Thread.abort_on_exception=true # for the debugging purpose.

class Server
  MAX_COMMAND_LENGTH = 1024

  def initialize(port)
    @port = port
    @key_values = {}
  end

  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)
    loop do
      handle_connection(server.accept)
    end
  end

  private

  def handle_connection(socket)
    Thread.new do
      puts "Handling the socket #{socket.object_id} in thread #{Thread.current.object_id}"

      loop do
        # TODO: Server has to close the connection after keep-alive period ends
        resp_command_line = socket.recv(MAX_COMMAND_LENGTH)
        break if resp_command_line == ""

        command_line = RESP::Parser.new(resp_command_line).parse
        CommandLineExecutor.new(command_line, socket, @key_values).execute!
      end

      socket.close
      puts "Socket #{socket.object_id} closed in thread #{Thread.current.object_id}"
    end
  end
end

Server.new(6379).start
