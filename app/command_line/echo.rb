module CommandLine
  class Echo < Base
    COMMAND = :echo

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      socket.write("+#{@args[0]}\r\n")
    end
  end
end
