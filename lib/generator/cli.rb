# frozen_string_literal: true
module Caze
  module Generator
    # Public: Caze CLI, this is the class that will generate the use case class
    # for each user
    autoload :Parser, 'caze/generator/parser'
    class CLI < Thor::Group
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
      def generate(namespaced_file, attributes)
        file_path = Parser.namespace_to_path(namespaced_file)
        spec_file_path = Parser.namespace_to_spec_path(namespaced_file)

        built_attributes = Parser.build_attributes(attributes)
      end
    end
  end
end

