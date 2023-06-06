require "socket"
require "./app/command_line_builder"

# require "./app/resp/parser.rb"

Thread.abort_on_exception=true # for the debugging purpose.

class Server
  MAX_COMMAND_LENGTH = 1024

  attr_reader :key_values

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
    server = self

    Thread.new do
      puts "Handling the socket #{socket.object_id} in thread #{Thread.current.object_id}"

      loop do
        # TODO: Server has to close the connection after keep-alive period ends
        resp_command_line = socket.recv(MAX_COMMAND_LENGTH)
        # NOTE: I don't know if this always indicates that the connection has been closed by the client.
        break if resp_command_line == ""

        command_line = CommandLineBuilder.new(resp_command_line).build
        command_line.execute!(server, socket)
      end

      socket.close
      puts "Socket #{socket.object_id} closed in thread #{Thread.current.object_id}"
    end
  end
end

Server.new(6379).start
