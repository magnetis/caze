# frozen_string_literal: true

module Caze
  module Generator
    class Parser
      class << self
        def namespace_to_path(namespace)
          "#{namesapce.tr(':', '/')}.tb"
        end

        def namespace_to_spec_path(namesapce)
          # TODO: to be implemented
          namespace
        end

        def build_attributes(attrs)
          { attrs: attrs.split(',') }
        end
      end
    end
  end
end
