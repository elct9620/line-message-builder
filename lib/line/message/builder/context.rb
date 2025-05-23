# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Context` class acts as a wrapper around an arbitrary context object.
      # It provides a way to delegate method calls to the wrapped context and
      # also supports an `assigns` hash for storing local variables accessible
      # within the builder's scope.
      #
      # This allows builders to access helper methods or instance variables from
      # the environment in which they are used (e.g., a Rails controller or view).
      class Context
        # @!attribute [rw] assigns
        #   @return [Hash] A hash for storing local variables.
        attr_accessor :assigns

        # Initializes a new Context wrapper.
        #
        # @param context [Object, nil] The object to wrap. Method calls not handled
        #   by `assigns` will be delegated to this object.
        def initialize(context)
          @context = context
          @assigns = {}
        end

        # @!visibility private
        # Checks if the context can respond to a given method.
        # It first checks the `assigns` hash, then the wrapped context.
        def respond_to_missing?(method_name, include_private = false)
          @assigns.key?(method_name) ||
            (@context && @context.respond_to?(method_name, include_private)) ||
            super
        end

        # @!visibility private
        # Handles method calls that are not defined on the Context class.
        # It first looks for the method name as a key in the `assigns` hash.
        # If not found, it attempts to delegate the method call to the wrapped context.
        def method_missing(method_name, ...)
          return @assigns[method_name] if @assigns.key?(method_name)
          return @context.public_send(method_name, ...) if @context && @context.respond_to?(method_name)

          super
        end
      end
    end
  end
end
