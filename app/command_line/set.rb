module CommandLine
  class Set < Base
    COMMAND = :set

    def self.command
      COMMAND
    end

    def execute!(server, socket)
      key = @args[0]
      value = @args[1]

      expiry_time =
        # Assumes that PX is always the first option.
        if @args[2]&.downcase == "px"
          expiry_millisecond = @args[3].to_i
          expiry_time = expiry_millisecond ? Time.now + expiry_millisecond * 0.001 : nil
        else
          nil
        end

      server.key_values[key] = [value, expiry_time]
      socket.write("+OK")
    end
  end
end
