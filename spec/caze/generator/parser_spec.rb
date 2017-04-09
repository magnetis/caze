require 'spec_helper'
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
            'gems:broker_service:easynvest:api:post_personal_data'
          end
          let(:path_structure) do
            {
              dependency_loc: :broker_service,
              file_name: :post_personal_data,
              full_path: 'gems/broker_service/lib/broker_service/easynvest/api/post_personal_data.rb',
              internal_namespaces: 'easynvest/api/',
              type: :gems
            }
          end

          it 'returns the correct path' do
            expect(namespace_to_path).to eq(path_structure)
          end
        end

        context 'when the path is from an engine' do
          let(:namespace) do
            'engine:pricing:use_cases:calculate_category_amount'
          end

          let(:path_structure) do
            {
              dependency_loc: :pricing,
              file_name: :calculate_category_amount,
              full_path: 'engines/pricing/lib/pricing/use_cases/calculate_category_amount.rb',
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
            'modules:accounting_cache:write_investments_cache'
          end

          let(:path_structure) do
            {
              dependency_loc: :accounting_cache,
              file_name: :write_investments_cache,
              full_path: 'app/modules/accounting_cache/write_investments_cache.rb',
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
