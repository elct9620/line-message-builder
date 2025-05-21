# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Define a partial that can be reused in flex message.
        module HasPartial
          def partial!(partial)
            raise ArgumentError, "Not a partial" unless partial < Partial

            partial.new(context: self).call
          end
        end

        # The partial designed to be reused in flex message.
        class Partial
          def initialize(context:)
            @context = context
          end

          def call(*)
            raise NotImplementedError, "The #{self.class} class must implement the call method"
          end

          def respond_to_missing?(method_name, include_private = false)
            @context.respond_to?(method_name, include_private) || super
          end

          def method_missing(method_name, ...)
            if @context.respond_to?(method_name)
              @context.public_send(method_name, ...)
            else
              super
            end
          end
        end
      end
    end
  end
end
