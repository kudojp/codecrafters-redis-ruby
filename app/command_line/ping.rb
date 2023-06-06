module CommandLine
  class Ping < Base
    COMMAND = :ping
    PING_RESPONSE = "PONG"

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      socket.write("+#{PING_RESPONSE}\r\n")
    end
  end
end
