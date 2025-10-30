# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The QuickReply class provides a builder for creating quick reply buttons
      # that can be attached to text messages or flex messages in the LINE Messaging API.
      #
      # Quick reply buttons appear at the bottom of the chat screen and allow users
      # to quickly respond to messages with predefined actions. They provide a
      # convenient way to guide user interactions without requiring typing.
      #
      # Quick replies support:
      # - Message actions that send text messages when tapped
      # - Postback actions that send data to your webhook
      # - Optional image icons for each button (up to 13 buttons total)
      #
      # == Example: Basic quick reply with message actions
      #
      #   Line::Message::Builder.with do
      #     text "Choose your favorite:" do
      #       quick_reply do
      #         message "Pizza", label: "Pizza"
      #         message "Sushi", label: "Sushi"
      #       end
      #     end
      #   end
      #
      # == Example: Quick reply with postback actions
      #
      #   Line::Message::Builder.with do
      #     text "What would you like to do?" do
      #       quick_reply do
      #         postback "action=order", label: "Place Order", display_text: "I want to order"
      #         postback "action=track", label: "Track Order"
      #       end
      #     end
      #   end
      #
      # == Example: Quick reply with image icons
      #
      #   Line::Message::Builder.with do
      #     text "Select a category:" do
      #       quick_reply do
      #         message "Food", label: "Food", image_url: "https://example.com/food.png"
      #         message "Drinks", label: "Drinks", image_url: "https://example.com/drinks.png"
      #       end
      #     end
      #   end
      #
      # See also:
      # - Text
      # - Actions::Message
      # - Actions::Postback
      # - https://developers.line.biz/en/docs/messaging-api/using-quick-reply/
      class QuickReply < Line::Message::Builder::Base
        # Creates a new quick reply builder.
        #
        # Quick reply builders manage a collection of action buttons that appear
        # at the bottom of messages. The builder provides methods to add message
        # and postback actions with optional image icons.
        #
        # [context]
        #   An optional context object for method delegation (default: +nil+)
        # [block]
        #   Block for configuring quick reply buttons using +message+ and +postback+ methods
        #
        # == Example
        #
        #   quick_reply = QuickReply.new(context: view_context) do
        #     message "Yes", label: "Yes"
        #     message "No", label: "No"
        #   end
        def initialize(context: nil, &)
          @items = []

          super
        end

        # Adds a message action button to the quick reply.
        #
        # Message actions send the specified text as a message from the user when
        # the button is tapped. This is useful for providing predefined response
        # options that simplify user interaction.
        #
        # [text]
        #   The text message to send when the button is tapped
        # [label]
        #   The label text displayed on the button (required)
        # [image_url]
        #   Optional icon image URL for the button (default: +nil+)
        # [block]
        #   Optional block for additional configuration
        #
        # == Example: Basic message button
        #
        #   quick_reply do
        #     message "I agree", label: "Yes"
        #     message "I disagree", label: "No"
        #   end
        #
        # == Example: Message button with icon
        #
        #   quick_reply do
        #     message "Order pizza", label: "Pizza",
        #             image_url: "https://example.com/pizza.png"
        #   end
        def message(text, label:, image_url: nil, &)
          action(
            Actions::Message.new(text, context: context, label: label, &),
            image_url
          )
        end

        # Adds a postback action button to the quick reply.
        #
        # Postback actions send data to your bot's webhook when the button is tapped,
        # allowing you to trigger backend logic without displaying a message. Optionally,
        # you can specify display text that will appear in the chat as if the user
        # sent it.
        #
        # [data]
        #   The data payload to send to the webhook (max 300 characters)
        # [label]
        #   The label text displayed on the button (default: +nil+)
        # [display_text]
        #   Text to display in chat when tapped (default: +nil+)
        # [image_url]
        #   Optional icon image URL for the button (default: +nil+)
        # [block]
        #   Optional block for additional configuration
        #
        # == Example: Basic postback button
        #
        #   quick_reply do
        #     postback "action=yes", label: "Yes"
        #     postback "action=no", label: "No"
        #   end
        #
        # == Example: Postback with display text
        #
        #   quick_reply do
        #     postback "action=order&item=pizza",
        #              label: "Order Pizza",
        #              display_text: "I'd like to order a pizza"
        #   end
        #
        # == Example: Postback button with icon
        #
        #   quick_reply do
        #     postback "action=confirm",
        #              label: "Confirm",
        #              image_url: "https://example.com/check.png"
        #   end
        def postback(data, label: nil, display_text: nil, image_url: nil, &)
          action(
            Actions::Postback.new(data, context: context, label: label, display_text: display_text, &),
            image_url
          )
        end

        private

        def to_api # :nodoc:
          {
            items: @items.map do |item, image_url|
              {
                type: "action",
                imageUrl: image_url,
                action: item.to_h
              }
            end
          }
        end

        def to_sdkv2 # :nodoc:
          {
            items: @items.map do |item, image_url|
              {
                type: "action",
                image_url: image_url,
                action: item.to_h
              }
            end
          }
        end

        def action(action, image_url) # :nodoc:
          @items << [action, image_url]
        end
      end
    end
  end
end
