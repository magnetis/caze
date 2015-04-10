require 'spec_helper'
require 'caze'

describe Caze do
  before do
    # Removing constant definitions if they exist
    # This avoids state to be permanent through tests
    [:DummyUseCase, :DummyUseCaseWithParam, :Dummy].each do |const|
      Object.send(:remove_const, const) if Object.constants.include?(const)
    end

    class DummyUseCase
      include Caze

      export :the_answer
      export :the_answer, as: :the_transactional_answer

      def the_answer
        42
      end
    end

    class DummyUseCaseWithParam
      include Caze

      export :the_answer_for

      def initialize(question, priority: :low)
        @priority = priority
      end

      def the_answer_for
        [@priority, 42]
      end
    end

    module Dummy
      include Caze

      has_use_case :the_answer, DummyUseCase
      has_use_case :the_answer_for, DummyUseCaseWithParam
      has_use_case :the_transactional_answer, DummyUseCase, transactional: true
    end
  end

  let(:use_case) { DummyUseCase }
  let(:app) { Dummy }

  describe '.has_use_case' do
    it 'delegates the use case message to the use case' do
      allow(use_case).to receive(:the_answer)
      app.the_answer
    end

    context 'when method has params' do
      it 'calls the method with the right params' do
        expect(app.the_answer_for('the meaning of life', priority: :high)).to eql([:high, 42])
      end
    end

    context 'using transaction' do
      context 'when there is a transaction method' do
        let(:transaction_handler) { double(:transaction_handler) }

        before do
          app.transaction_handler = transaction_handler
        end

        it 'uses the transaction handler' do
          expect(transaction_handler).to receive(:transaction).and_yield
          app.the_transactional_answer
        end
      end

      context 'when there is no transaction method defined' do
        it 'raises an exception' do
          expect {
            app.the_transactional_answer
          }.to raise_error(/This action should be executed inside a transaction/)
        end
      end
    end
  end

  describe '.export' do
    it 'defines a class method' do
      expect(use_case).to respond_to(:the_answer)
    end

    context 'using the flag `as`' do
      before do
        use_case.export :the_answer, as: :universal_answer
      end

      it 'defines an entry point with another name' do
        expect(use_case).to respond_to(:universal_answer)
      end
    end
  end
end
