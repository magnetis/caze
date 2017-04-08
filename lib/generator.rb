require 'thor'

module Caze
  # Public: Module responsible for generating use case files 
  module Generator
    autoload :CLI, 'caze/generator/cli'

    class << self
      def caze
        Caze::CazeGenerator::CLI.start(ARGV)
      end
    end
  end
end
