# frozen_string_literal: true
require 'thor'

module Caze
  module Generator
    autoload :Parser, 'caze/generator/parser'

    # Internal: Class responsible for inheriting `Thor`'s behaviour
    # and declaring the command methods
    class CLI < Thor
      include Thor::Actions
      desc 'bundle exec caze generate engine:my_engine:my_use_case:my_class --test-framework unit_test',
           'Generates use case files with test',
           'options: test-framework default: :rspec'
      # Define arguments and options
      class_option :test_framework, default: :rspec, aliases: :t

      def generate(namespace)
        file_path_structure = Parser.namespace_to_path(namespace, options.fetch(:test_framework))

        # Create main file
        create_file file_path_structure[:full_path] do
          '#TODO: Implement logic to generate files'
        end

        # Create test file
        create_file file_path_structure[:test_path] do
          '#TODO: Implement logic to generate files'
        end
      end
    end
  end
end
