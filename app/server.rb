require "socket"
require "./app/server/command_line_executor"
require "./app/resp/command_line"
require "./app/resp/parser.rb"

Thread.abort_on_exception=true # for the debugging purpose.

class Server
  MAX_COMMAND_LENGTH = 1024

  def initialize(port)
    @port = port
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
        begin
          resp_command_line = socket.recv(MAX_COMMAND_LENGTH)
          break if resp_command_line == "" # probably client program has exited.
        end

        RESP::Parser.new(resp_command_line).parse.each do |command_line|
          CommandLineExecutor.new(command_line, socket).execute!
        end
      end
      puts "Close the socket #{socket.object_id} in thread #{Thread.current.object_id}"
      socket.close
    end
  end
end

Server.new(6379).start
