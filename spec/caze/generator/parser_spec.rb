require 'spec_helper'
require 'caze/generator'
require 'caze/generator/parser'

module Caze
  module Generator
    describe Parser do
      describe '.namespace_to_path' do
        subject(:namespace_to_path) do
          described_class.namespace_to_path(namespace, :rspec)
        end
        context 'when the path is from a gem' do
          let(:namespace) do
            'gems:my_gem:partner:api:post_data'
          end
          let(:path_structure) do
            {
              dependency_loc: :my_gem,
              file_name: :post_data,
              full_path: 'gems/my_gem/lib/my_gem/partner/api/post_data.rb',
              test_path: 'gems/my_gem/spec/my_gem/partner/api/post_data_spec.rb',
              internal_namespaces: 'partner/api/',
              type: :gems
            }
          end

          it 'returns the correct path' do
            expect(namespace_to_path).to eq(path_structure)
          end
        end

        context 'when the path is from an engine' do
          let(:namespace) do
            'engine:my_engine:use_cases:calculate_price'
          end

          let(:path_structure) do
            {
              dependency_loc: :my_engine,
              file_name: :calculate_price,
              full_path: 'engines/my_engine/lib/my_engine/use_cases/calculate_price.rb',
              test_path: 'engines/my_engine/spec/my_engine/use_cases/calculate_price_spec.rb',
              internal_namespaces: 'use_cases/',
              type: :engines
            }
          end

          it 'returns the correct path' do
            expect(namespace_to_path).to eq(path_structure)
          end
        end

        context 'when the path is from an app module' do
          let(:namespace) do
            'modules:my_cache:write_my_cache'
          end

          let(:path_structure) do
            {
              dependency_loc: :my_cache,
              file_name: :write_my_cache,
              full_path: 'app/modules/my_cache/write_my_cache.rb',
              test_path: 'spec/modules/my_cache/write_my_cache_spec.rb',
              internal_namespaces: '',
              type: :modules
            }
          end

          it 'returns the correct path' do
            expect(namespace_to_path).to eq(path_structure)
          end
        end

        context 'when the path is from the main app' do
          let(:namespace) do
            'caze:generator:parse_spec_namespace'
          end
          let(:path_structure) do
            {
              dependency_loc: :main_app,
              file_name: :parse_spec_namespace,
              full_path: 'lib/caze/generator/parse_spec_namespace.rb',
              test_path: 'spec/caze/generator/parse_spec_namespace_spec.rb',
              internal_namespaces: 'caze/generator/',
              type: :app
            }
          end

          it 'returns the correct path structure' do
            expect(namespace_to_path).to eq(path_structure)
          end
        end
      end
    end
  end
end
