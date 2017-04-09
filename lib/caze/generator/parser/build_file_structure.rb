# frozen_string_literal: true

module Caze
  module Generator
    class Parser::BuildFileStructure
      def initialize(path_type,
                     dependency_location,
                     internal_namespaces,
                     file_name,
                     test_framework)
        @path_type = path_type
        @dependency_location = dependency_location
        @internal_namespaces = internal_namespaces
        @file_name = file_name
        @test_framework = test_framework
      end

      def build
        {
          type: path_type,
          dependency_loc: dependency_location,
          internal_namespaces: internal_namespaces,
          file_name: file_name,
          full_path: _resolve_path[:path],
          test_path: _resolve_path[:test_path]
        }
      end

      private

      attr_reader :path_type,
                  :dependency_location,
                  :internal_namespaces,
                  :file_name,
                  :test_framework

      def known_path?(given_path_type)
        [
          :engine,
          :engines,
          :gem,
          :gems,
          :modules,
          :module
        ].include? given_path_type
      end

      def _resolve_path
        return _resolve_known_path if known_path? path_type

        {
          path: "lib/#{internal_namespaces}#{file_name}.rb",
          test_path: "#{test_namespace}/#{internal_namespaces}#{file_name}_spec.rb"
        }
      end

      def _resolve_known_path
        if path_type == :modules
          {
            path: _modules_path('app'),
            test_path: _modules_path
          }
        else
          {
            path: _path('lib'),
            test_path: _path
          }
        end
      end

      def _modules_path(path_namespace = test_namespace)
        "#{path_namespace}/#{path_type}/#{dependency_name}/#{internal_namespaces}#{file_name}.rb".freeze
      end

      def _path(path_namespace = test_namespace)
        "#{path_type}/#{dependency_name}/#{path_namespace}/#{dependency_name}/#{internal_namespaces}#{file_name}.rb".freeze
      end

      def test_namespace
        test_framework == :rspec ? 'spec' : 'test'
      end
    end
  end
end
