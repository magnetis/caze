# frozen_string_literal: true

module Caze
  module Generator
    # Public: Module responsible for generating use case files
    autoload :CLI, 'caze/generator/cli'

    class << self
      def start_generator
        CLI.start
      end
    end
  end
end
