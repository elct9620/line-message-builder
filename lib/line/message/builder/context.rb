# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Context` class is a crucial component of the `Line::Message::Builder`
      # DSL, enabling a flexible and dynamic environment for message construction.
      # It acts as a wrapper around an optional user-provided context object and
      # manages a separate hash of "assigns" (local variables for the DSL).
      #
      # The primary purposes of the `Context` are:
      # 1.  **To provide access to helper methods**: If a user passes a context object
      #     (e.g., a Rails view context, a presenter, or any custom object) during
      #     builder initialization (`Line::Message::Builder.with(my_helper_object)`),
      #     methods defined on `my_helper_object` become directly callable within
      #     the DSL blocks.
      # 2.  **To allow local data storage (`assigns`)**: The `assigns` hash allows
      #     for setting and retrieving temporary data that can be shared across
      #     different parts of a complex message construction block, without needing
      #     to pass it explicitly or pollute the user-provided context.
      #
      # Method calls within the DSL that are not defined on the builder objects
      # themselves are resolved by `Context` in the following order:
      # - First, it checks if the method name corresponds to a key in the `assigns` hash.
      # - If not found in `assigns`, it checks if the wrapped user-context object
      #   responds to the method.
      # - If neither, the call proceeds up the normal Ruby method lookup chain.
      #
      # This mechanism allows for a clean and powerful way to integrate external logic
      # and data into the message building process.
      #
      # @example Using a custom context
      #   class MyHelpers
      #     def current_user_name
      #       "Alice"
      #     end
      #   end
      #
      #   helpers = MyHelpers.new
      #   Line::Message::Builder.with(helpers) do |root|
      #     # `current_user_name` is resolved from `helpers` by Context
      #     root.text "Hello, #{current_user_name}!"
      #
      #     # Using assigns
      #     assigns[:item_count] = 5
      #     root.text "You have #{assigns[:item_count]} items."
      #   end
      class Context
        # @!attribute assigns
        #   A hash for storing arbitrary data that can be accessed within the
        #   builder DSL. This is useful for temporary variables or shared state
        #   during message construction.
        #   @return [Hash] The hash of assigned values.
        #   @example
        #     context.assigns[:user_id] = 123
        #     puts context.assigns[:user_id] # => 123
        attr_accessor :assigns

        attr_reader :mode

        # Initializes a new Context object.
        #
        # @param context [Object, nil] An optional object whose methods will be made
        #   available within the DSL. If `nil`, only `assigns` and standard
        #   builder methods will be available.
        #   @param mode [Symbol] The mode of the context, which can be `:api` or `:sdkv2`.
        def initialize(context, mode: :api)
          @context = context
          @assigns = {}
          @mode = mode
        end

        # Part of Ruby's dynamic method dispatch. It's overridden here to declare
        # that instances of `Context` can respond to methods that are either:
        # 1. Keys in the `@assigns` hash.
        # 2. Methods to which the wrapped `@context` object responds.
        #
        # This ensures that `respond_to?` behaves consistently with how
        # `method_missing` resolves method calls.
        #
        # @param method_name [Symbol] The name of the method being queried.
        # @param include_private [Boolean] Whether to include private methods in
        #   the check.
        # @return [Boolean] `true` if the context can handle the method,
        #   `false` otherwise.
        # @!visibility private
        def respond_to_missing?(method_name, include_private = false)
          @assigns.key?(method_name) ||
            @context.respond_to?(method_name, include_private) || # Check @context directly
            super
        end

        # Handles calls to methods not explicitly defined on the `Context` class.
        # The resolution order is:
        # 1.  If `method_name` is a key in the `@assigns` hash, its value is returned.
        # 2.  If the wrapped `@context` object responds to `method_name`, the call
        #     is delegated to `@context`.
        # 3.  Otherwise, `super` is called, allowing the standard Ruby method
        #     lookup to continue (which will likely result in a `NoMethodError`
        #     if the method is truly undefined).
        #
        # This is the core mechanism that allows DSL blocks to seamlessly access
        # data from `assigns` or methods from the user-provided context.
        #
        # @param method_name [Symbol] The name of the invoked method.
        # @param ... [Object] Arguments passed to the method.
        # @return [Object, nil] The value from `@assigns`, the result of the
        #   delegated call to `@context`, or raises `NoMethodError` via `super`.
        # @raise [NoMethodError] If the method is not found in `assigns` or
        #   on the wrapped context.
        # @!visibility private
        def method_missing(method_name, ...)
          return @assigns[method_name] if @assigns.key?(method_name)
          # Check @context directly
          return @context.public_send(method_name, ...) if @context.respond_to?(method_name)

          super
        end

        def sdkv2?
          mode == :sdkv2
        end
      end
    end
  end
end
