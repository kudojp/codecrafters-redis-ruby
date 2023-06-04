class Server
  class CommandLineExecutor
    def initialize(command_line, socket)
      @command_line = command_line
      @socket = socket
    end

    def execute!
      case @command_line.command
      when :ping then
        execute_ping
      when :echo then
        execute_echo
      else
        raise "Command '#{command_line.command}' is invalid."
      end
    end

    private

    def execute_ping
      @socket.write("+PONG\r\n")
    end

    def execute_echo
      @socket.write("+#{@command_line.args[0]}\r\n")
    end
  end
end
