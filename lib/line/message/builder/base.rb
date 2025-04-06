# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The base class to provide DSL functionality.
      class Base
        class << self
          def inherited(subclass)
            super
            subclass.extend ClassMethods
          end
        end

        # :nodoc:
        module ClassMethods
          def options
            @options ||= []
          end

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

        def initialize(context: nil, **options, &block)
          @context = context
          @quick_reply = nil

          self.class.options.each do |option|
            send(option, options[option]) if options.key?(option)
          end

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
