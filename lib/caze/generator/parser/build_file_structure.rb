# frozen_string_literal: true

module Caze
  module Generator
    class Parser
      # Private: Builder responsible for building the parsed file namespace
      # to a structure that can later be consumed by some external entity
      class BuildFileStructure
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
            full_path: resolve_path[:path],
            test_path: resolve_path[:test_path]
          }
        end

        private

        def known_path?(given_path_type)
          Generator.known_path? given_path_type
        end

        attr_reader :path_type,
                    :dependency_location,
                    :internal_namespaces,
                    :file_name,
                    :test_framework

        def resolve_path
          return resolve_known_path if known_path? path_type

          { path: "lib/#{internal_namespaces}#{file_name}.rb",
            test_path: "#{test_namespace}/#{internal_namespaces}#{file_name}_#{test_namespace}.rb" }
        end

        def resolve_known_path
          if path_type == :modules
            { path: modules_path('app'),
              test_path: modules_path }
          else
            { path: path('lib'),
              test_path: path }
          end
        end

        def modules_path(path_namespace = test_namespace)
          path_beginning = [
            path_namespace,
            path_type,
            dependency_location,
            internal_namespaces
          ].join('/')
          testing = path_namespace == test_namespace ? "_#{test_namespace}" : ''
          "#{path_beginning}#{file_name}#{testing}.rb".freeze
        end

        def path(path_namespace = test_namespace)
          path_beginning = [
            path_type,
            dependency_location,
            path_namespace,
            dependency_location,
            internal_namespaces
          ].join('/')

          testing = path_namespace == test_namespace ? "_#{test_namespace}" : ''
          "#{path_beginning}#{file_name}#{testing}.rb".freeze
        end

        def test_namespace
          test_framework == :rspec ? 'spec' : 'test'
        end
      end
    end
  end
end
