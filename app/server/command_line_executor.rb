class Server
  class CommandLineExecutor
    def initialize(command_line, socket, key_values)
      @command_line = command_line
      @socket = socket
      @key_values = key_values
    end

    def execute!
      case @command_line.command
      when :ping then
        execute_ping
      when :echo then
        execute_echo
      when :set then
        execute_set
      when :get then
        execute_get
      else
        raise "Command '#{@command_line.command}' is invalid."
      end
    end

    private

    def execute_ping
      @socket.write("+PONG\r\n")
    end

    def execute_echo
      @socket.write("+#{@command_line.args[0]}\r\n")
    end

    def execute_set
      key, value = @command_line.args
      # print key, value, "#####"
      @key_values[key] = value
      @socket.write("+OK")
    end

    def execute_get
      key = @command_line.args[0]
      @socket.write("+#{@key_values[key]}")
    end
  end
end
