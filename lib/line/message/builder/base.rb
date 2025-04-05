# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The base class to provide DSL functionality.
      class Base
        attr_reader :context

        def initialize(context: nil, &block)
          @context = context
          @quick_reply = nil

          instance_eval(&block) if ::Kernel.block_given?
        end

        def quick_reply(&)
          @quick_reply = QuickReply.new(context: context, &)
        end

        def respond_to_missing?(method_name, include_private = false)
          context.respond_to?(method_name, include_private) || super
        end

        def method_missing(method_name, ...)
          if context.respond_to?(method_name)
            context.public_send(method_name, ...)
          else
            super
          end
        end
      end
    end
  end
end
