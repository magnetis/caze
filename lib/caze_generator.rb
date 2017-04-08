# frozen_string_literal: true
require 'thor'

module Caze
  module CazeGenerator
    # Public: Caze CLI, this is the class that will generate the use case class
    # for each user
    class CLI < Thor
      # Command `generate`:
      # params:
      #   - file: engine:some_engine:some_use_case_module:class_name
      #   - attributes: the attributes to add to the class
      #   - options:
      #       - action_method
      #       - test_framework
      #       - app_root_path
      desc 'generate file',
           'generates file and creates the class with its attributes'
      # option :action, type: :string, aliases: :a
      # option :test_framework, type: :string, aliases: [:t, :test]
      # option :root_path, type: :string, aliases: [:rp, :p]
      def generate(file, attributes)
        # TODO: to be implemented
        puts "File: #{file}"
        puts "Attributes: #{attributes}"
      end
    end
  end
end

Caze::CazeGenerator::CLI.start(ARGV)
