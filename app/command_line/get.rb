module CommandLine
  class Get < Base
    COMMAND = :get

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      key = @args[0]

      value = server.key_values[key]
      socket.write("+#{value}")
    end
  end
end
