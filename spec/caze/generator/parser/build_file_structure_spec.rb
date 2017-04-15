# frozen_string_literal: true

require 'spec_helper'
require 'caze/generator'
require 'caze/generator/parser/build_file_structure'

module Caze
  module Generator
    describe Parser::BuildFileStructure do
      describe '#build' do
        subject(:build) do
          described_class.new(dependency_type,
                              dependency_namespace,
                              internal_modules,
                              file_name,
                              test_framework).build
        end
        let(:test_framework) { :rspec }

        context 'when the path is from a gem' do
          let(:dependency_type) { :gems }
          let(:dependency_namespace) { :my_gem }
          let(:internal_modules) { 'partner/api/' }
          let(:file_name) { :post_data }

          let(:path_structure) do
            {
              dependency_namespace: dependency_namespace,
              file_name: file_name,
              full_path: 'gems/my_gem/lib/my_gem/partner/api/post_data.rb',
              test_path: 'gems/my_gem/spec/my_gem/partner/api/post_data_spec.rb',
              internal_modules: internal_modules,
              dependency_type: dependency_type
            }
          end

          it 'returns the correct path structure' do
            expect(build).to eq(path_structure)
          end
        end

        context 'when the path is from an engine' do
          let(:dependency_type) { :engines }
          let(:dependency_namespace) { :my_engine }
          let(:internal_modules) { 'use_cases/' }
          let(:file_name) { :calculate_price }

          let(:path_structure) do
            {
              dependency_namespace: dependency_namespace,
              file_name: file_name,
              full_path: 'engines/my_engine/lib/my_engine/use_cases/calculate_price.rb',
              test_path: 'engines/my_engine/spec/my_engine/use_cases/calculate_price_spec.rb',
              internal_modules: internal_modules,
              dependency_type: dependency_type
            }
          end

          it 'returns the correct path structure' do
            expect(build).to eq(path_structure)
          end
        end

        context 'when the path is from an app module' do
          let(:dependency_type) { :modules }
          let(:dependency_namespace) { :my_cache }
          let(:internal_modules) { '' }
          let(:file_name) { :write_my_cache }

          let(:path_structure) do
            {
              dependency_namespace: dependency_namespace,
              file_name: file_name,
              full_path: 'app/modules/my_cache/write_my_cache.rb',
              test_path: 'spec/modules/my_cache/write_my_cache_spec.rb',
              internal_modules: internal_modules,
              dependency_type: dependency_type
            }
          end

          it 'returns the correct path structure' do
            expect(build).to eq(path_structure)
          end
        end

        context 'when the path is from the main app' do
          let(:dependency_type) { :app }
          let(:dependency_namespace) { :main_app }
          let(:internal_modules) { 'caze/generator/' }
          let(:file_name) { :parse_spec_namespace }

          let(:path_structure) do
            {
              dependency_namespace: dependency_namespace,
              file_name: file_name,
              full_path: 'lib/caze/generator/parse_spec_namespace.rb',
              test_path: 'spec/caze/generator/parse_spec_namespace_spec.rb',
              internal_modules: internal_modules,
              dependency_type: dependency_type
            }
          end

          it 'returns the correct path structure' do
            expect(build).to eq(path_structure)
          end
        end
      end
    end
  end
end
