Dir["./app/command_line/*.rb"].each {|file| require file }

class CommandLineBuilder
  class InvalidCommandError < StandardError; end

  # ref. https://redis.io/docs/reference/protocol-spec/
  TOKEN_TYPE_COVERTERS = {
    # For Simple Strings, the first byte of the reply is "+"
    ":" => lambda{|arg_str| arg_str.to_i},
    # For Errors, the first byte of the reply is "-"
    "$" => lambda{|arg_str| arg_str.to_s},
    # For Arrays, the first byte of the reply is "*"
  }

  COMMANDS = [
    CommandLine::Ping,
    CommandLine::Echo,
    CommandLine::Set,
    CommandLine::Get,
  ]

  def initialize(resp_str)
    @resp_str = resp_str
  end

  def build
    # Current logic assumes that the command is only the first token.
    command, args = parse_tokens

    COMMANDS.each do |command_line_class|
      next if command != command_line_class.command
      return command_line_class.new(args)
    end

    raise InvalidCommandError.new("Command #{command} does not exist. Use one of #{COMMANDS.map(&:command)}")
  end

  private

  def parse_tokens
    tokens = @resp_str.split("\r\n")
    command = tokens[2].downcase.to_sym
    
    args = []
    curr_idx = 3
    while curr_idx < tokens.length
      type_char, _length_str = tokens[curr_idx][0], tokens[curr_idx][1...]
      convertor = TOKEN_TYPE_COVERTERS[type_char]
      curr_idx += 1

      args << convertor.call(tokens[curr_idx])
      curr_idx += 1
    end
    
    [command, args]
  end
end
