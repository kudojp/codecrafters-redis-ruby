module CommandLine
  class Base
    def self.command
      raise StandardError.new(".command should be overridden in each subclass!")
    end
    
    def initialize(args)
      @args = args
    end

    def execute!(server, socket)
      raise StandardError.new("#execute! should be overridden in each subclass!")
    end

    def to_s
      ([self.class.command] + @args).join " "
    end
  end
end
