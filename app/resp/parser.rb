module RESP
  class Parser
    # ref. https://redis.io/docs/reference/protocol-spec/
    TOKEN_TYPE_COVERTERS = {
      # For Simple Strings, the first byte of the reply is "+"
      ":" => lambda{|arg_str| arg_str.to_i},
      # For Errors, the first byte of the reply is "-"
      "$" => lambda{|arg_str| arg_str.to_s},
      # For Arrays, the first byte of the reply is "*"
    }

    def initialize(resp_str)
      @resp_str = resp_str
    end

    def parse
      # Current logic assumes that there is only one command in one command line. (*1)
      tokens = @resp_str.split("\r\n")
      cl_command = tokens[2].to_sym
      cl_args = []

      curr_idx = 3
      while curr_idx < tokens.length
        type_char, _length_str = tokens[curr_idx][0], tokens[curr_idx][1...]
        convertor = TOKEN_TYPE_COVERTERS[type_char]
        curr_idx += 1

        cl_args << convertor.call(tokens[curr_idx])
        curr_idx += 1
      end

      CommandLine.new(cl_command, cl_args)
    end
  end
end
