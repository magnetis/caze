require 'spec_helper'
require 'use_case_support'

describe UseCaseSupport do
  class DummyUseCase
    include UseCaseSupport

    define_entry_point :the_answer

    def the_answer
      42
    end
  end

  module Dummy
    class << self
      include UseCaseSupport

      define_use_cases the_answer: DummyUseCase
    end
  end

  let(:use_case) { DummyUseCase }
  let(:app) { Dummy }

  describe '.define_use_cases' do
    it 'delegates the use case message to the use case' do
      allow(use_case).to receive(:the_answer)
      app.the_answer
    end
  end

  describe '.define_entry_point' do
    it 'defines a class method' do
      expect(use_case).to respond_to(:the_answer)
    end

    context 'using the flag `as`' do
      before do
        use_case.define_entry_point :the_answer, as: :universal_answer
      end

      it 'defines an entry point with another name' do
        expect(use_case).to respond_to(:universal_answer)
      end
    end

    context 'using transaction' do
      context 'when there is a transaction method' do
        let(:transaction_handler) do
          Class.new do
            def self.transaction
              yield
            end
          end
        end
        before do
          app.define_transaction_handler transaction_handler
          use_case.define_entry_point :the_answer, as: :the_answer_with_transaction, transaction: true
        end

        xit 'uses the transaction handler' do
          allow(transaction_handler).to receive(:transaction)
          use_case.the_answer_with_transaction
        end
      end
    end

  end
end
