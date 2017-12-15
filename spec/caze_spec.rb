require 'spec_helper'
require 'caze'

describe Caze do

  before do
    # Removing constant definitions if they exist
    # This avoids state to be permanent through tests
    [:DummyUseCase,
     :DummyUseCaseWithParam,
     :Dummy,
     :DummyError,
     :DummyUseCaseTest].each do |const|
      Object.send(:remove_const, const) if Object.constants.include?(const)
    end

    class DummyError < StandardError; end
    class DummyUseCase
      include Caze

      export :the_answer
      export :the_answer, as: :the_transactional_answer
      export :the_answer, as: :the_answer_by_another_entry_point
      export :the_answer, as: :the_universal_answer
      export :the_answer, as: :the_transactional_and_intercepted_answer
      export :the_question

      def the_answer
        42
      end

      def the_question
        raise 'You did not say yet.'
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

    class DummyUseCaseTest
      include Caze

      export :the_question

      def the_question
        raise DummyError.new("We don't know the question")
      end
    end

    module DummyNamespace
      include Caze

      has_use_case :the_question, DummyUseCaseTest, raise_use_case_exception: true
    end

    module Dummy
      include Caze

      has_use_case :the_answer, DummyUseCase
      has_use_case :the_answer_by_another_entry_point, 'DummyUseCase'
      has_use_case :the_universal_answer, :DummyUseCase
      has_use_case :the_answer_for, DummyUseCaseWithParam
      has_use_case :the_transactional_answer, DummyUseCase, transactional: true
      has_use_case :the_question, DummyUseCase, raise_use_case_exception: true
      has_use_case :the_transactional_and_intercepted_answer, DummyUseCase, transactional: true,
                                                                            raise_use_case_exception: true
    end
  end

  let(:use_case) { DummyUseCase }
  let(:app) { Dummy }
  let(:namespaced_use_case) { DummyNamespace }

  describe '.has_use_case' do
    it 'delegates the message to the use case' do
      expect(use_case).to receive(:the_answer)

      app.the_answer
    end

    context 'when method has params' do
      it 'calls the method with the right params' do
        expect(app.the_answer_for('the meaning of life', priority: :high)).to eql([:high, 42])
      end
    end

    context 'when use case class is declared as string' do
      it 'delegates the message to the use case' do
        expect(use_case).to receive(:the_answer_by_another_entry_point)

        app.the_answer_by_another_entry_point
      end
    end

    context 'when use case class is declared as symbol' do
      it 'delegates the message to the use case' do
        expect(use_case).to receive(:the_universal_answer)

        app.the_universal_answer
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

    context 'using exception' do
      context 'when the use case raises an exception' do
        it 'raises with the namespace of the use case' do
          expect {
            namespaced_use_case.the_question
          }.to raise_error do |error|
            expect(error).to be_a(DummyUseCaseTest::DummyError)
            expect(error.cause).to be_a(::DummyError)
            expect(error.backtrace.first).to match(/in `the_question'/)
          end
        end
      end
    end

    context 'using exception and transaction' do
      context 'when the use case raises the transaction exception' do
        it 'shows the use case name' do
          expect {
            app.the_transactional_and_intercepted_answer
          }.to raise_error(Caze::NoTransactionMethodError, "This action should be executed inside a transaction. But no transaction handler was configured.")
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
