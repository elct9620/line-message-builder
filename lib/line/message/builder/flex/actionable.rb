# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Actionable` module provides a DSL for defining actions
        # within flex components (e.g., buttons, images).
        #
        # When included in a class, it adds an `action` attribute reader
        # and methods to create specific action types like `message` and `postback`.
        module Actionable
          # @!visibility private
          def self.included(base)
            # @!attribute [r] action
            #   @return [Actions::Message, Actions::Postback, nil] The action associated with this component.
            base.attr_reader :action
          end

          # Defines a message action for the component.
          #
          # @param text [String] The text of the message to be sent when the action is triggered.
          # @param options [Hash] Additional options for the message action (e.g., label).
          # @param block [Proc, nil] An optional block for further configuration of the message action.
          # @return [Actions::Message] The created message action object.
          #
          # @see Actions::Message
          def message(text, **options, &)
            @action = Actions::Message.new(text, context: context, **options, &)
          end

          # Defines a postback action for the component.
          #
          # @param data [String] The data to be sent in the postback event when the action is triggered.
          # @param options [Hash] Additional options for the postback action (e.g., label, display_text).
          # @param block [Proc, nil] An optional block for further configuration of the postback action.
          # @return [Actions::Postback] The created postback action object.
          #
          # @see Actions::Postback
          def postback(data, **options, &)
            @action = Actions::Postback.new(data, context: context, **options, &)
          end
        end
      end
    end
  end
end
