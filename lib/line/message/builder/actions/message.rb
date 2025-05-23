# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # Represents a message action.
        # This action sends a message from the user to the bot.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#message-action
        class Message < Line::Message::Builder::Base
          # @!attribute [r] text
          #   @return [String] The text of the message.
          attr_reader :text

          # @!attribute [rw] label
          #   @return [String, nil] The label for the action.
          #     Max: 20 characters.
          option :label, default: nil

          # Creates a new message action.
          #
          # @param text [String] The text of the message.
          #   Max: 300 characters (LINE app version 7.5.0 or later).
          #   Max: 40 characters (LINE app version lower than 7.5.0).
          # @param context [Object, nil] The context to use for the action.
          # @param options [Hash] Additional options for the action.
          # @option options [String, nil] :label The label for the action.
          # @param &block [Proc, nil] A block to be executed in the context of the new action.
          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          # Returns a hash representation of the message action.
          #
          # @raise [RequiredError] if text is nil.
          # @return [Hash] A hash representing the message action.
          def to_h
            raise RequiredError, "text is required" if text.nil?

            {
              type: "message",
              label: label,
              text: text
            }.compact
          end
        end
      end
    end
  end
end
