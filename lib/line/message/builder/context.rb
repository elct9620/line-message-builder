# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The context is wrapper for the context object to provide assigns support.
      class Context
        attr_accessor :assigns

        def initialize(context)
          @context = context
          @assigns = {}
        end

        def respond_to_missing?(method_name, include_private = false)
          @assigns.key?(method_name) ||
            @context.respond_to?(method_name, include_private) ||
            super
        end

        def method_missing(method_name, ...)
          return @assigns[method_name] if @assigns.key?(method_name)
          return @context.public_send(method_name, ...) if @context.respond_to?(method_name)

          super
        end
      end
    end
  end
end
