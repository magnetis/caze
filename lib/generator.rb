#!/usr/bin/env ruby

require 'thor'
# Public: Module responsible for generating use case files
class Generator < Thor
  include Thor::Actions

  desc 'generate file',
       'generates file and creates the class with its attributes'
  # Define arguments and options
  class_option :test_framework, default: :rspec

  def generate(namespace)
    file_path = Parser.namespace_to_path(namespace)

    create_file file_path do
      '#TODO: Implement logic to generate files'
    end
  end
end

class Parser
  class << self
    def namespace_to_path(namespace)
      namespaces = namespace.split(':')
      path_type = namespaces.first.to_sym
      namespaces.delete_at 0
      unless known_paths.include? path_type
        path_type = :normal
      end
      path = ''
      case path_type
      when :engine, :gem
        dependency_name = namespaces.first
        namespaces.delete_at 0
        "#{path_type}/#{dependency_name}/lib/#{dependency_name}/#{namespaces.join('/')}.rb"
      when :modules
        "app/#{path_type}/#{namespaces.join('/')}.rb"
      else
        "lib/#{namespaces.join('/')}.rb"
      end
    end

    private

    def known_paths
      [:engine, :gem, :modules]
    end
  end
end

Generator.start
