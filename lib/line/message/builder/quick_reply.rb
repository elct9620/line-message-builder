# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `QuickReply` class provides a DSL for constructing quick reply buttons
      # that can be attached to various message types (e.g., {Text}, {Flex::Builder}).
      # Quick replies offer users a set of predefined responses or actions.
      #
      # Usage:
      #   ```ruby
      #   Line::Message::Builder.with do
      #     text "Select your favorite food category:" do
      #       quick_reply do
      #         message "Sushi", label: "Sushi", image_url: "https://example.com/sushi.png"
      #         postback "action=buy&itemid=111", label: "Pizza", display_text: "I want pizza!"
      #         # Add other quick reply button types like camera, location, etc. if supported
      #       end
      #     end
      #   end
      #   ```
      #
      # @see https://developers.line.biz/en/reference/messaging-api/#quick-reply
      class QuickReply < Line::Message::Builder::Base
        # @!attribute [r] items
        #   @return [Array<Array(Actions::Base, String, nil)>] An array of quick reply items.
        #     Each item is a tuple containing an action object and an optional image URL.
        attr_reader :items

        # Initializes a new QuickReply builder.
        # This is typically called within the block of a message builder (e.g., `text do ... end`).
        #
        # @param context [Object, nil] The context from the parent builder.
        # @param block [Proc] A block executed in the context of this QuickReply instance,
        #   allowing definition of quick reply items using methods like {#message} and {#postback}.
        def initialize(context: nil, &)
          @items = []
          super
        end

        # Adds a message action button to the quick reply.
        # When tapped, this button sends a text message from the user to the bot.
        #
        # @param text_content [String] The text to be sent when the button is tapped.
        # @param label [String] The label displayed on the button. Max 20 characters.
        # @param image_url [String, nil] URL of an icon image to display on the button (HTTPS). Max 1000 characters.
        # @param block [Proc, nil] An optional block for further configuration of the {Actions::Message} action.
        # @return [Array] The array of current quick reply items.
        #
        # @see Actions::Message
        def message(text_content, label:, image_url: nil, &)
          action( # Reverted call
            Actions::Message.new(text_content, label: label, context: context, &),
            image_url
          )
        end

        # Adds a postback action button to the quick reply.
        # When tapped, this button sends a postback event to the bot's webhook.
        #
        # @param data_payload [String] The data to be sent in the postback event. Max 300 characters.
        # @param label [String, nil] The label displayed on the button. Max 20 characters.
        #   If `nil`, `data_payload` or `display_text` (if also nil) might be used by some clients, but providing a label is recommended.
        # @param display_text [String, nil] Text displayed in the chat as a message sent by the user when the action is performed.
        #   Max 300 characters.
        # @param image_url [String, nil] URL of an icon image to display on the button (HTTPS). Max 1000 characters.
        # @param block [Proc, nil] An optional block for further configuration of the {Actions::Postback} action.
        # @return [Array] The array of current quick reply items.
        #
        # @see Actions::Postback
        def postback(data_payload, label: nil, display_text: nil, image_url: nil, &)
          action( # Reverted call
            Actions::Postback.new(data_payload, label: label, display_text: display_text, context: context, &),
            image_url
          )
        end
        # TODO: Add other quick reply action types if this library intends to support them:
        # - cameraAction
        # - cameraRollAction
        # - locationAction
        # - datetimePickerAction (though this has more complex parameters)

        # Converts the QuickReply object to its hash representation for the LINE API.
        #
        # @return [Hash] A hash structured as `{ items: [...] }`.
        def to_h
          # Reverted: Removed API limit validations
          {
            items: @items.map do |action_item, item_image_url|
              {
                type: "action",
                imageUrl: item_image_url, # This key should be `imageUrl` based on API docs
                action: action_item.to_h
              }.compact # Remove imageUrl if nil
            end
          }
        end

        private

        # Original private method to add an action to the items list.
        # @param action_obj [Actions::Base] The action object (e.g., Message, Postback).
        # @param item_image_url [String, nil] The image URL for this quick reply button.
        # @return [Array] The updated items array.
        def action(action_obj, item_image_url) # Reverted name
          @items << [action_obj, item_image_url]
        end
      end
    end
  end
end
