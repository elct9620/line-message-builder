# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # Represents a postback action for LINE messages.
        #
        # A postback action sends a postback event to your bot's webhook when a
        # button associated with this action is tapped. The event contains the
        # specified +data+ payload. Optionally, +display_text+ can be provided,
        # which will be shown in the chat as a message from the user.
        #
        # This action is useful for triggering specific backend logic or flows
        # without necessarily displaying a message in the chat, or for displaying
        # a different message than the data payload.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     text "What do you want to do?"
        #     quick_reply do
        #       button action: :postback,
        #              label: "Track Order",
        #              data: "action=track_order&order_id=123",
        #              display_text: "I want to track my order."
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#postback-action
        class Postback < Line::Message::Builder::Base
          # The data payload to be sent in the postback event to the webhook.
          # This is a required attribute. Max 300 characters.
          attr_reader :data

          # :method: label
          # :call-seq:
          #   label() -> String or nil
          #   label(value) -> String or nil
          #
          # Sets or gets the label for the action.
          #
          # The label is recommended by LINE for accessibility. For some message
          # types (e.g., buttons), the button's label itself is used.
          #
          # [value]
          #   The label text for the action
          option :label, default: nil

          # :method: display_text
          # :call-seq:
          #   display_text() -> String or nil
          #   display_text(value) -> String or nil
          #
          # Sets or gets the display text for the action.
          #
          # This is the text that will be displayed in the chat as a message from
          # the user when the action is performed. If not set, no message is displayed.
          #
          # [value]
          #   The text to display in the chat (max 300 characters)
          option :display_text, default: nil

          # Initializes a new Postback action.
          #
          # [data]
          #   The data to be sent in the postback event (required)
          # [context]
          #   An optional context object (default: +nil+)
          # [options]
          #   Options for the action, including +:label+ and +:display_text+
          #
          # Raises RequiredError if +data+ is +nil+ (this check is done in +to_h+
          # but +data+ is conceptually required on initialization).
          #
          # == Example
          #
          #   postback = Postback.new(
          #     "action=buy&item=123",
          #     context: view_context,
          #     label: "Buy Now",
          #     display_text: "I want to buy this item"
          #   )
          def initialize(data, context: nil, **options, &)
            @data = data

            super(context: context, **options, &)
          end

          # Converts the Postback action object to a hash suitable for the LINE Messaging API.
          #
          # Returns a hash representing the postback action, including +:type+, +:label+
          # (if set), +:data+, and +:displayText+ (if set).
          #
          # Raises RequiredError if +data+ is +nil+.
          #
          # == Example
          #
          #   postback = Postback.new("action=track", label: "Track Order")
          #   postback.to_h
          #   # => { type: "postback", label: "Track Order", data: "action=track" }
          def to_h
            raise RequiredError, "data is required" if data.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # :nodoc:
            {
              type: "postback",
              label: label,
              data: data,
              displayText: display_text
            }.compact
          end

          def to_sdkv2 # :nodoc:
            {
              type: "postback",
              label: label,
              data: data,
              display_text: display_text
            }.compact
          end
        end
      end
    end
  end
end
