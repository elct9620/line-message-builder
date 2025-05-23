# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Base` class serves as the foundation for all builder classes in the
      # `Line::Message::Builder` namespace. It provides common functionality
      # such as option handling, context management, and DSL capabilities.
      class Base
        class << self
          # @!visibility private
          def inherited(subclass)
            super
            subclass.extend ClassMethods
          end
        end

        # This module provides class-level methods for defining options in builder classes.
        module ClassMethods
          # Returns the list of defined options for the class.
          #
          # @return [Array<Symbol>] An array of option names.
          def options
            @options ||= []
          end

          # Defines an option for the builder class.
          # This creates an accessor method for the option.
          # If called with an argument, it sets the option's value.
          # If called without an argument, it gets the option's value or its default.
          #
          # @param name [Symbol] The name of the option.
          # @param default [Object, nil] The default value for the option.
          # @param validator [Object, nil] An optional validator for the option's value.
          #   The validator must respond to `valid!`.
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

        # @!attribute [r] context
        #   @return [Context] The context object associated with this builder instance.
        attr_reader :context

        # Initializes a new builder instance.
        #
        # @param context [Object, nil] An optional external context to be used.
        #   If provided, method calls that are not defined on the builder will be
        #   delegated to this context.
        # @param options [Hash] A hash of options to set on the builder.
        # @param block [Proc, nil] An optional block to be executed in the context
        #   of the new builder instance (instance_eval).
        def initialize(context: nil, **options, &block)
          @context = Context.new(context)
          @quick_reply = nil

          self.class.options.each do |option|
            send(option, options[option]) if options.key?(option)
          end

          instance_eval(&block) if ::Kernel.block_given?
        end

        # Defines a quick reply for the message.
        #
        # @param block [Proc] A block that defines the quick reply items.
        #   The block is executed in the context of a new {QuickReply} instance.
        # @return [QuickReply] The created QuickReply object.
        def quick_reply(&)
          @quick_reply = QuickReply.new(context: context, &)
        end

        # @!visibility private
        def respond_to_missing?(method_name, include_private = false)
          context.respond_to?(method_name, include_private) || super
        end

        # @!visibility private
        # Delegates missing methods to the associated context if the context can respond to them.
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
