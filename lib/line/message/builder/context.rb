# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Context class is a crucial component of the Line::Message::Builder
      # DSL, enabling a flexible and dynamic environment for message construction.
      # It acts as a wrapper around an optional user-provided context object and
      # manages a separate hash of +assigns+ (local variables for the DSL).
      #
      # The primary purposes of the Context are:
      # 1.  To provide access to helper methods: If a user passes a context object
      #     (e.g., a Rails view context, a presenter, or any custom object) during
      #     builder initialization, methods defined on that object become directly
      #     callable within the DSL blocks.
      # 2.  To allow local data storage: The +assigns+ hash allows for setting and
      #     retrieving temporary data that can be shared across different parts of
      #     a complex message construction block, without needing to pass it
      #     explicitly or pollute the user-provided context.
      #
      # Method calls within the DSL that are not defined on the builder objects
      # themselves are resolved by Context in the following order:
      # - First, it checks if the method name corresponds to a key in the +assigns+ hash.
      # - If not found in +assigns+, it checks if the wrapped user-context object
      #   responds to the method.
      # - If neither, the call proceeds up the normal Ruby method lookup chain.
      #
      # This mechanism allows for a clean and powerful way to integrate external logic
      # and data into the message building process.
      #
      # == Example: Using a custom context
      #
      #   class MyContext
      #     def current_user_name
      #       "Alice"
      #     end
      #   end
      #
      #   context = MyContext.new
      #   Line::Message::Builder.with(context) do
      #     # current_user_name is resolved from context by Context
      #     text "Hello, #{current_user_name}!"
      #   end
      class Context
        # A hash for storing arbitrary data that can be accessed within the
        # builder DSL. This is useful for temporary variables or shared state
        # during message construction.
        #
        # == Example
        #
        #   context.assigns[:user_id] = 123
        #   puts context.assigns[:user_id] # => 123
        attr_accessor :assigns

        # The mode in which the builder is operating. This affects how messages
        # are formatted in the final output. Either +:api+ for direct LINE
        # Messaging API format or +:sdkv2+ for LINE Bot SDK v2 compatible format.
        attr_reader :mode

        # Initializes a new Context object.
        #
        # [context]
        #   An optional object whose methods will be made available within the DSL.
        #   If +nil+, only +assigns+ and standard builder methods will be available.
        # [mode]
        #   The mode of the context, which can be +:api+ (default) for direct LINE
        #   Messaging API format or +:sdkv2+ for LINE Bot SDK v2 compatible format.
        #
        # == Example
        #
        #   # With a custom context object
        #   my_context = MyHelpers.new
        #   context = Line::Message::Builder::Context.new(my_context, mode: :api)
        #
        # === Example: Without context
        #
        #   # Without context, using only assigns
        #   context = Line::Message::Builder::Context.new(nil)
        #   context.assigns[:user_name] = "Alice"
        def initialize(context, mode: :api)
          @context = context
          @assigns = {}
          @mode = mode
        end

        def respond_to_missing?(method_name, include_private = false) # :nodoc:
          @assigns.key?(method_name) ||
            @context.respond_to?(method_name, include_private) || # Check @context directly
            super
        end

        def method_missing(method_name, ...) # :nodoc:
          return @assigns[method_name] if @assigns.key?(method_name)
          # Check @context directly
          return @context.public_send(method_name, ...) if @context.respond_to?(method_name)

          super
        end

        # Checks if the current mode is set to SDK v2 compatibility.
        #
        # Returns +true+ if the mode is +:sdkv2+, +false+ otherwise.
        #
        # == Example
        #
        #   if context.sdkv2?
        #     # Format message for LINE Bot SDK v2
        #   else
        #     # Format message for direct API use
        #   end
        def sdkv2?
          mode == :sdkv2
        end
      end
    end
  end
end
