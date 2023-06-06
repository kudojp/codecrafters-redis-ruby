module CommandLine
  class Set < Base
    COMMAND = :set

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      key = @args[0]
      value = @args[1]

      server.key_values[key] = value
      socket.write("+OK")
    end
  end
end
