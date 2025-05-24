# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Base` class serves as the foundation for all message builder classes
      # within the `Line::Message::Builder` DSL. It provides core functionality
      # for defining options, handling initialization, and delegating method calls
      # to a context object.
      #
      # This class is not typically used directly but is inherited by specific
      # message type builders (e.g., `Text`, `Flex`).
      class Base
        class << self
          # @!visibility private
          # @!parse extend ClassMethods
          def inherited(subclass)
            super
            subclass.extend ClassMethods
          end
        end

        # The `ClassMethods` module is automatically extended by any class that
        # inherits from {Base}. It provides class-level methods for defining
        # DSL options and configurations.
        module ClassMethods
          # Returns an array of option names that have been defined for this class
          # using the {option} method.
          #
          # @return [Array<Symbol>] A list of defined option names.
          # @!visibility private
          def options
            @options ||= []
          end

          # Defines a new option for the builder class.
          # This method dynamically creates an instance method on the builder class
          # with the given `name`. When this instance method is called:
          # - Without arguments, it returns the current value of the option, or
          #   the `default` value if not set.
          # - With an argument, it sets the value of the option. If a `validator`
          #   is provided, the value is validated before being set.
          #
          # @param name [Symbol] The name of the option to define. This will also
          #   be the name of the generated instance method.
          # @param default [Object, nil] The default value for the option if not
          #   explicitly set.
          # @param validator [#valid!?, nil] An optional validator object that must
          #   respond to `valid!(value)`. If the value is invalid, the validator
          #   should raise an error (typically a {ValidationError}).
          # @return [void]
          # @example
          #   class MyBuilder < Base
          #     option :color, default: "red"
          #     option :size, validator: SizeValidator.new
          #   end
          #
          #   builder = MyBuilder.new
          #   puts builder.color # => "red"
          #   builder.color "blue"
          #   puts builder.color # => "blue"
          #   builder.size "large" # Assuming SizeValidator allows "large"
          def option(name, default: nil, validator: nil)
            options << name

            define_method name do |*args|
              if args.empty?
                instance_variable_get("@#{name}") || default
              else
                validator&.valid!(args.first)
                instance_variable_set("@#{name}", args.first)
              end
            end
          end
        end

        attr_reader :context

        # Initializes a new instance of a builder class.
        #
        # @param context [Object, nil] An optional external context object.
        #   Methods not defined in the builder will be delegated to this context
        #   if it responds to them. This allows for using helper methods or
        #   accessing data from the surrounding environment within the builder DSL.
        # @param options [Hash] A hash of options to set on the builder instance.
        #   These options are typically defined using the {ClassMethods.option .option}
        #   method in the builder class.
        # @param block [Proc, nil] An optional block that is instance-eval'd
        #   within the new builder instance. This is the primary way the DSL
        #   is used to define message content.
        def initialize(context: nil, **options, &block)
          @context = context
          @quick_reply = nil

          self.class.options.each do |option|
            send(option, options[option]) if options.key?(option)
          end

          instance_eval(&block) if ::Kernel.block_given?
        end

        # Defines a quick reply for the message.
        # A quick reply consists of a set of buttons that are displayed along
        # with the message, allowing users to make quick responses.
        #
        # The provided block is executed in the context of a new {QuickReply}
        # instance, where you can define the quick reply buttons.
        #
        # @yield [quick_reply] The block is yielded with a {QuickReply} instance.
        # @return [QuickReply] The created {QuickReply} object.
        # @example
        #   text_message do
        #     text "Please choose an option:"
        #     quick_reply do
        #       button action: :message, label: "Option A", text: "You chose A"
        #       button action: :camera,  label: "Open Camera"
        #     end
        #   end
        def quick_reply(&)
          @quick_reply = QuickReply.new(context: context, &)
        end

        # Determines if the builder can respond to a given method, including
        # checking if the context object can respond to it.
        # This is part of Ruby's mechanism for `method_missing` and is used
        # here to enable delegation to the `context` object.
        #
        # @param method_name [Symbol] The name of the method.
        # @param include_private [Boolean] Whether to include private methods
        #   in the search.
        # @return [Boolean] `true` if the builder or its context can respond to
        #   the method, `false` otherwise.
        # @!visibility private
        def respond_to_missing?(method_name, include_private = false)
          context.respond_to?(method_name, include_private) || super
        end

        # Handles calls to undefined methods by attempting to delegate them to the
        # `context` object. If the `context` object responds to the method,
        # it is called. Otherwise, it behaves like the standard `method_missing`.
        # This allows the DSL to feel more integrated with the surrounding code
        # by making methods from the `context` directly available within the
        # builder block.
        #
        # @param method_name [Symbol] The name of the missing method.
        # @param ... [Object] Arguments passed to the method.
        # @raise [NoMethodError] If neither the builder nor the context can
        #   handle the method call.
        # @!visibility private
        def method_missing(method_name, ...)
          if context.respond_to?(method_name)
            context.public_send(method_name, ...)
          else
            super
          end
        end

        def to_h
          return to_sdkv2 if sdkv2?

          to_api
        end

        private

        def to_api
          raise NotImplementedError, "#{self.class} must implement #to_api"
        end

        def to_sdkv2
          raise NotImplementedError, "#{self.class} must implement #to_sdkv2"
        end
      end
    end
  end
end
