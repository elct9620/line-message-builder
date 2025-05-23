# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # Represents a "postback action" for LINE messages.
        #
        # A postback action sends a postback event to your bot's webhook when a
        # button associated with this action is tapped. The event contains the
        # specified `data` payload. Optionally, `displayText` can be provided,
        # which will be shown in the chat as a message from the user.
        #
        # This action is useful for triggering specific backend logic or flows
        # without necessarily displaying a message in the chat, or for displaying
        # a different message than the data payload.
        #
        # @example Creating a postback action for a quick reply button
        #   Line::Message::Builder.with do |root|
        #     root.text "What do you want to do?"
        #     root.quick_reply do |qr|
        #       qr.button action: :postback,
        #                 label: "Track Order",
        #                 data: "action=track_order&order_id=123",
        #                 display_text: "I want to track my order."
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#postback-action
        class Postback < Line::Message::Builder::Base
          # @!attribute [r] data
          #   @return [String] The data payload to be sent in the postback event
          #     to the webhook. This is a required attribute. Max 300 characters.
          attr_reader :data

          # Defines an optional `label` for the action.
          # The label is recommended by LINE for accessibility. For some message
          # types (e.g., buttons), the button's label itself is used.
          #
          # @!method label(value = nil)
          #   @param value [String, nil] The label text for the action.
          #   @return [String, nil] The current label text.
          option :label, default: nil

          # Defines an optional `displayText` for the action.
          # This is the text that will be displayed in the chat as a message from
          # the user when the action is performed. If not set, no message is displayed.
          #
          # @!method display_text(value = nil)
          #   @param value [String, nil] The text to display in the chat. Max 300 characters.
          #   @return [String, nil] The current display text.
          option :display_text, default: nil

          # Initializes a new Postback action.
          #
          # @param data [String] The data to be sent in the postback event. This is required.
          # @param context [Object, nil] An optional context object.
          # @param options [Hash] Options for the action, including `:label` and `:display_text`.
          # @param block [Proc, nil] An optional block for instance_eval.
          # @raise [RequiredError] if `data` is nil. (This check is done in `to_h`
          #   but `data` is conceptually required on initialization).
          def initialize(data, context: nil, **options, &)
            @data = data

            super(context: context, **options, &)
          end

          # Converts the Postback action object to a hash suitable for the LINE Messaging API.
          #
          # @return [Hash] A hash representing the postback action.
          #   Includes `:type`, `:label` (if set), `:data`, and `:displayText` (if set).
          # @raise [RequiredError] if `data` is nil.
          def to_h
            raise RequiredError, "data is required" if data.nil?

            {
              type: "postback",
              label: label,
              data: data,
              displayText: display_text
            }.compact
          end
        end
      end
    end
  end
end
