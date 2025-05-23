# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Actionable` module provides a DSL for defining an action that can be
        # triggered when a user interacts with certain Flex Message components
        # (e.g., a {Button} component, or an entire {Bubble} or {Box} component
        # if it's made tappable).
        #
        # When a component includes this module, it gains methods like {#message}
        # and {#postback} to associate a specific LINE action with itself. The
        # chosen action is stored in the `action` attribute.
        #
        # @!attribute [r] action
        #   @return [Actions::Message, Actions::Postback, nil] The action object
        #     associated with this component. `nil` if no action is defined.
        #
        # @see Line::Message::Builder::Actions::Message
        # @see Line::Message::Builder::Actions::Postback
        # @see https://developers.line.biz/en/reference/messaging-api/#action-objects
        module Actionable
          # @!visibility private
          # Automatically adds an `attr_reader :action` to the class that includes
          # this module.
          # @param base [Class] The class including this module.
          def self.included(base)
            base.attr_reader :action
          end

          # Defines a message action for the component.
          # When the component is tapped, a message with the given `text` is sent
          # from the user to the chat.
          #
          # @param text [String] The text of the message to send.
          # @param options [Hash] Additional options for the message action,
          #   such as `:label`. See {Actions::Message#initialize}.
          # @param block [Proc, nil] An optional block, though not typically used
          #   directly for message actions here.
          # @return [Actions::Message] The created message action object.
          #
          # @example Setting a message action on a button
          #   button_component.message "Hello User!", label: "Send Greeting"
          def message(text, **options, &)
            @action = Actions::Message.new(text, context: context, **options, &)
          end

          # Defines a postback action for the component.
          # When the component is tapped, a postback event with the given `data`
          # is sent to the bot's webhook.
          #
          # @param data [String] The data payload for the postback event.
          # @param options [Hash] Additional options for the postback action,
          #   such as `:label` or `:display_text`. See {Actions::Postback#initialize}.
          # @param block [Proc, nil] An optional block, though not typically used
          #   directly for postback actions here.
          # @return [Actions::Postback] The created postback action object.
          #
          # @example Setting a postback action on a button
          #   button_component.postback "action=buy&item_id=123", label: "Buy Item"
          def postback(data, **options, &)
            @action = Actions::Postback.new(data, context: context, **options, &)
          end
        end
      end
    end
  end
end
