# frozen_string_literal: true

module Caze
  module Generator
    # Internal: Class responsible for parsing the namespace given to a path
    class Parser
      autoload :BuildFileStructure, 'caze/generator/parser/build_file_structure'

      class << self
        def namespace_to_path(namespace, test_framework)
          build_file_path_structure(namespace, test_framework)
        end

        private

        def known_path?(path_type)
          Generator.known_path? path_type
        end

        def build_file_path_structure(namespace, test_framework)
          namespaces = namespace.split(':').map(&:to_sym)
          dependency_type = resolve_dependency_type(namespaces)
          dependency_type = pluralize(dependency_type)
          dependency_namespace = resolve_dependency_namespace(namespaces, dependency_type)
          internal_modules = resolve_internal_modules(namespaces)
          file_name = namespaces.first

          builder = Parser::BuildFileStructure.new(
            dependency_type,
            dependency_namespace,
            internal_modules,
            file_name,
            test_framework
          )

          builder.build
        end

        def resolve_dependency_type(namespaces)
          dep_type = namespaces.first
          return namespaces.delete_at(0) if known_path? dep_type

          :app
        end

        def resolve_dependency_namespace(namespaces, dependency_type)
          return namespaces.delete_at(0) if known_path? dependency_type
          :main_app
        end

        def resolve_internal_modules(namespaces)
          n = namespaces.count
          return '' if n <= 1

          modules = ''
          while n > 1
            modules += "#{namespaces.delete_at 0}/"
            n = namespaces.count
          end
          modules
        end

        def pluralize(path_type)
          return "#{path_type}s".to_sym if [:gem, :engine, :module].include? path_type
          path_type
        end
      end
    end
  end
end
