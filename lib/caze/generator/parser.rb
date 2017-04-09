# frozen_string_literal: true

module Caze
  module Generator
    class Parser

      autoload :BuildFileStructure, 'caze/generator/parser/build_file_structure'

      class << self
        def namespace_to_path(namespace, test_framework)
          _build_file_path_structure namespace, test_framework
        end

        private

        def _build_file_path_structure(namespace, test_framework)
          namespaces = namespace.split(':').map(&:to_sym)
          path_type = _pluralize(_resolve_path_type(namespaces))
          dependency_loc = _resolve_dependency_location(namespaces, path_type)
          internal_namespaces = _resolve_internal_namespaces(namespaces)
          file_name = namespaces.first

          builder = BuildFileStructure.new(
            path_type,
            dependency_loc,
            internal_namespaces,
            file_name,
            test_framework
          )
          builder.build
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

        def _resolve_path_type(namespaces)
          path_type = namespaces.first
          return namespaces.delete_at(0) if known_path? path_type

          :app
        end

        def _resolve_dependency_location(namespaces, path_type)
          return namespaces.delete_at(0) if known_path? path_type
          :main_app
        end

        def _resolve_internal_namespaces(namespaces)
          n = namespaces.count
          return '' if n <= 1
          r = ''
          i = 0
          while n > 1
            val = namespaces.delete_at 0
            r += "#{val}/"
            i += 1
            n = namespaces.count
          end
          r
        end

        def _pluralize(path_type)
          return "#{path_type}s".to_sym if [:gem, :engine, :module].include? path_type
          path_type
        end
      end
    end
  end
end
