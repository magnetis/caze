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
      use_cases.each_pair do |name, use_case|
        main_module = self

        use_case.define_singleton_method(:parent_module, ->() { main_module })

        define_singleton_method(name, Proc.new { |*args|
          use_case.send(name, *args)
        })
      end
    end

    def define_entry_point(method_name, options = {})
      method_to_define = options.fetch(:as) { method_name }
      use_transaction = options.fetch(:transaction) { false }

      define_singleton_method(method_to_define, Proc.new { |*args|
        object = args.empty? ? new : new(args)

        if use_transaction
          handler = parent_module.transaction_handler

          raise NoTransactionMethodError, "This action should be executed inside a transaction. But no transaction handler was given" unless handler

          handler.transaction { object.send(method_name) }
        else
          object.send(method_name)
        end
      })
    end
  end
end
