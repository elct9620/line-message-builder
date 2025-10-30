# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Actionable module provides a DSL for defining an action that can be
        # triggered when a user interacts with certain Flex Message components
        # (e.g., a Button component, or an entire Bubble or Box component
        # if it's made tappable).
        #
        # When a component includes this module, it gains methods like +message+
        # and +postback+ to associate a specific LINE action with itself. The
        # chosen action is stored in the +action+ attribute.
        #
        # == Attributes
        #
        # The following attribute is automatically added to classes that include
        # this module:
        #
        # [action]
        #   The action object associated with this component. Returns an
        #   Actions::Message, Actions::Postback, or +nil+ if no action is defined.
        #
        # See also:
        # - Line::Message::Builder::Actions::Message
        # - Line::Message::Builder::Actions::Postback
        # - https://developers.line.biz/en/reference/messaging-api/#action-objects
        module Actionable
          def self.included(base) # :nodoc:
            base.attr_reader :action
          end

          # Defines a message action for the component.
          # When the component is tapped, a message with the given text is sent
          # from the user to the chat.
          #
          # [text]
          #   The text of the message to send
          # [options]
          #   Additional options for the message action, such as +:label+.
          #   See Actions::Message
          #
          # == Example
          #
          #   button_component.message "Hello User!", label: "Send Greeting"
          def message(text, **options, &)
            @action = Actions::Message.new(text, context: context, **options, &)
          end

          # Defines a postback action for the component.
          # When the component is tapped, a postback event with the given data
          # is sent to the bot's webhook.
          #
          # [data]
          #   The data payload for the postback event
          # [options]
          #   Additional options for the postback action, such as +:label+ or
          #   +:display_text+. See Actions::Postback
          #
          # == Example
          #
          #   button_component.postback "action=buy&item_id=123", label: "Buy Item"
          def postback(data, **options, &)
            @action = Actions::Postback.new(data, context: context, **options, &)
          end
        end
      end
    end
  end
end
