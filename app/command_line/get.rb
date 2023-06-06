module CommandLine
  class Get < Base
    COMMAND = :get

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      key = @args[0]

      value, expiry_time = server.key_values[key]
      if expiry_time && (expiry_time < Time.now)
        # puts  "### expired expiry_time: #{expiry_time} < Time.now: #{Time.now}"
        socket.write("$-1\r\n}")
        return
      end

      socket.write("+#{value}")
    end
  end
end
