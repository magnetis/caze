require 'use_case_support/version'
require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'

module UseCaseSupport
  class NoTransactionMethodError < StandardError; end
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :transaction_handler

    def define_use_cases(use_cases)
      use_cases.each_pair do |use_case_name, use_case_class|
        main_module = self

        # Define a reference to the parent module
        # in order to be able to use the transaction handler.
        use_case_class.define_singleton_method(:parent_module, ->() { main_module })

        define_singleton_method(use_case_name, Proc.new { |*args|
          use_case_class.send(use_case_name, *args)
        })
      end
    end

    def define_entry_point(method_name, options = {})
      method_to_define = options.fetch(:as) { method_name }
      use_transaction  = options.fetch(:use_transaction) { false }

      define_singleton_method(method_to_define, Proc.new { |*args|
        use_case_object = args.empty? ? new : new(*args)

        if use_transaction
          handler = parent_module.transaction_handler

          raise NoTransactionMethodError, "This action should be executed inside a transaction. But no transaction handler was configured." unless handler

          handler.transaction { use_case_object.send(method_name) }
        else
          use_case_object.send(method_name)
        end
      })
    end
  end
end
