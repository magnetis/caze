# frozen_string_literal: true

module Caze
  # Public: Module responsible for generating use case files
  module Generator
    autoload :CLI, 'caze/generator/cli'

    class << self
      def start_generator
        CLI.start
      end

      def known_path?(path_type)
        [
          :engine,
          :engines,
          :gem,
          :gems,
          :modules,
          :module
        ].include? path_type
      end
    end
  end
end
