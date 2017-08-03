# frozen_string_literal: true

module Caze
  module Generator
    class Parser
      # Private: Builder responsible for building the parsed file namespace
      # to a structure that can later be consumed by some external entity
      class BuildFileStructure
        def initialize(dependency_type,
                       dependency_namespace,
                       internal_modules,
                       file_name,
                       test_framework)
          @dependency_type = dependency_type
          @dependency_namespace = dependency_namespace
          @internal_modules = internal_modules
          @file_name = file_name
          @test_framework = test_framework
        end

        def build
          {
            dependency_type: dependency_type,
            dependency_namespace: dependency_namespace,
            internal_modules: internal_modules,
            file_name: file_name,
            full_path: resolve_path[:path],
            test_path: resolve_path[:test_path]
          }
        end

        private

        attr_reader :dependency_type,
                    :dependency_namespace,
                    :internal_modules,
                    :file_name,
                    :test_framework

        def known_path?(given_dependency_type)
          Generator.known_path? given_dependency_type
        end

        def resolve_path
          return resolve_known_path if known_path? dependency_type

          {
            path: "lib/#{internal_modules}#{file_name}.rb",
            test_path: "#{test_namespace}/#{internal_modules}#{file_name}_#{test_namespace}.rb"
          }
        end

        def resolve_known_path
          if dependency_type == :modules
            { path: modules_path,
              test_path: modules_path(test_namespace) }
          else
            { path: path,
              test_path: path(test_namespace) }
          end
        end

        def modules_path(path_namespace = 'app')
          path_beginning = [
            path_namespace,
            dependency_type,
            dependency_namespace,
            internal_modules
          ].join('/')

          testing_namespace = path_namespace == test_namespace ? "_#{test_namespace}" : ''
          "#{path_beginning}#{file_name}#{testing_namespace}.rb".freeze
        end

        def path(path_namespace = 'lib')
          path_beginning = [
            dependency_type,
            dependency_namespace,
            path_namespace,
            dependency_namespace,
            internal_modules
          ].join('/')

          testing_namespace = path_namespace == test_namespace ? "_#{test_namespace}" : ''
          "#{path_beginning}#{file_name}#{testing_namespace}.rb".freeze
        end

        def test_namespace
          test_framework == :rspec ? 'spec' : 'test'
        end
      end
    end
  end
end
