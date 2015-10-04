require 'caze/version'
require 'active_support'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'

module Caze
  class NoTransactionMethodError < StandardError; end
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :transaction_handler

    def has_use_case(use_case_name, use_case_class_or_stringish, options = {})
      transactional = options.fetch(:transactional) { false }

      define_singleton_method(use_case_name, Proc.new do |*args|
        use_case_class = get_use_case_class(use_case_class_or_stringish)

        if transactional
          handler = self.transaction_handler

          unless handler
            raise NoTransactionMethodError,
              "This action should be executed inside a transaction. But no transaction handler was configured."
          end

          handler.transaction { use_case_class.send(use_case_name, *args) }
        else
          use_case_class.send(use_case_name, *args)
        end
      end)
    end

    def export(method_name, options = {})
      method_to_define = options.fetch(:as) { method_name }

      define_singleton_method(method_to_define, Proc.new { |*args|
        use_case_object = args.empty? ? new : new(*args)
        use_case_object.send(method_name)
      })
    end

    private

    def get_use_case_class(use_case_class_or_stringish)
      if use_case_class_or_stringish.respond_to?(:upcase)
        return Object.const_get(use_case_class_or_stringish)
      end

      use_case_class_or_stringish
    end
  end
end
