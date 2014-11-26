require 'use_case_support/version'
require 'active_support'
require 'active_support/concern'

module UseCaseSupport
  extend ActiveSupport::Concern

  module ClassMethods
    def define_use_cases(use_cases)
      use_cases.each_pair do |name, use_case|
        delegate name, to: use_case
      end
    end

    def define_entry_point(method_name, options = {})
      method_to_define = options.fetch(:as) { method_name }

      define_singleton_method(method_to_define) do |keyword_args|
        new(keyword_args).send(method_name)
      end
    end
  end
end
