module RESP
  class CommandLine
    class InvalidCommandError < StandardError; end
    class InvalidArgs < StandardError; end

    COMMANDS = [
      :echo,
      :ping,
    ]

    attr_reader :command
    attr_reader :args

    def initialize(command, args)
      symbolized_command = command&.downcase&.to_sym
      raise InvalidCommandError.new("Command command should be any of #{COMMANDS}, but was '#{symbolized_command}'") unless COMMANDS.include? symbolized_command
      @command = command # symbol
      raise InvalidArgs.new("Command args should be an array.") unless args.is_a?(Array)
      @args = args
    end

    def to_s
      ([self.command] + self.args).join " "
    end
  end
end
