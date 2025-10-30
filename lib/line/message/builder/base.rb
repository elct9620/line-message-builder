# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Base class serves as the foundation for all message builder classes
      # within the Line::Message::Builder DSL. It provides core functionality
      # for defining options, handling initialization, and delegating method calls
      # to a context object.
      #
      # This class is not typically used directly but is inherited by specific
      # message type builders (e.g., Text, Flex::Builder).
      class Base
        class << self
          def inherited(subclass) # :nodoc:
            super
            subclass.extend ClassMethods
          end
        end

        # The ClassMethods module is automatically extended by any class that
        # inherits from Base. It provides class-level methods for defining
        # DSL options and configurations.
        module ClassMethods
          def options # :nodoc:
            @options ||= []
          end

          # Defines a new option for the builder class.
          #
          # This method dynamically creates an instance method on the builder class
          # with the given name. When this instance method is called:
          # - Without arguments, it returns the current value of the option, or
          #   the default value if not set.
          # - With an argument, it sets the value of the option. If a validator
          #   is provided, the value is validated before being set.
          #
          # [name]
          #   The name of the option to define. This will also be the name of the
          #   generated instance method.
          # [default]
          #   The default value for the option if not explicitly set.
          # [validator]
          #   An optional validator object that must respond to +valid!+ method.
          #   If the value is invalid, the validator should raise an error.
          #
          # == Example
          #
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

        # The context object used for method delegation.
        #
        # When methods are called on the builder that it doesn't respond to,
        # they are delegated to this context object if it responds to them.
        # This allows accessing helper methods and variables from the surrounding
        # environment within the builder DSL.
        attr_reader :context

        # Initializes a new instance of a builder class.
        #
        # [context]
        #   An optional external context object. Methods not defined in the builder
        #   will be delegated to this context if it responds to them. This allows
        #   for using helper methods or accessing data from the surrounding environment
        #   within the builder DSL.
        # [options]
        #   A hash of options to set on the builder instance. These options are
        #   typically defined using the +option+ method in the builder class.
        # [block]
        #   An optional block that is instance-eval'd within the new builder instance.
        #   This is the primary way the DSL is used to define message content.
        #
        # == Example
        #
        #   builder = MyBuilder.new(context: view_context) do
        #     text "Hello from context"
        #   end
        def initialize(context: nil, **options, &block)
          @context = context
          @quick_reply = nil

          self.class.options.each do |option|
            send(option, options[option]) if options.key?(option)
          end

          instance_eval(&block) if ::Kernel.block_given?
        end

        # Defines a quick reply for the message.
        #
        # A quick reply consists of a set of buttons that are displayed along
        # with the message, allowing users to make quick responses.
        #
        # The provided block is executed in the context of a new QuickReply
        # instance, where you can define the quick reply buttons.
        #
        # :yields: quick_reply
        #
        # == Example
        #
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

        def respond_to_missing?(method_name, include_private = false) # :nodoc:
          context.respond_to?(method_name, include_private) || super
        end

        def method_missing(method_name, ...) # :nodoc:
          if context.respond_to?(method_name)
            context.public_send(method_name, ...)
          else
            super
          end
        end

        # Converts the builder to a hash representation.
        #
        # The format of the hash depends on the mode (API or SDK v2) determined
        # by the builder's configuration. Subclasses must implement +to_api+ and
        # +to_sdkv2+ methods to provide the actual conversion logic.
        #
        # [return]
        #   A hash representation of the message in the appropriate format.
        #
        # == Example
        #
        #   builder = Text.new { text "Hello" }
        #   builder.to_h
        #   # => { type: "text", text: "Hello" }
        def to_h
          return to_sdkv2 if sdkv2?

          to_api
        end

        private

        def to_api # :nodoc:
          raise NotImplementedError, "#{self.class} must implement #to_api"
        end

        def to_sdkv2 # :nodoc:
          raise NotImplementedError, "#{self.class} must implement #to_sdkv2"
        end
      end
    end
  end
end
