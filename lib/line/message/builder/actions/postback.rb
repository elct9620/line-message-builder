# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # Represents a postback action.
        # When a control associated with this action is tapped, a postback event is returned via webhook.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#postback-action
        class Postback < Line::Message::Builder::Base
          # @!attribute [r] data
          #   @return [String] The data to be sent via the postback event.
          attr_reader :data

          # @!attribute [rw] label
          #   @return [String, nil] The label for the action.
          #     Max: 20 characters.
          option :label, default: nil
          # @!attribute [rw] display_text
          #   @return [String, nil] The text displayed in the chat as a message sent by the user when the action is performed.
          #     Max: 300 characters.
          option :display_text, default: nil

          # Creates a new postback action.
          #
          # @param data [String] The data to be sent via the postback event.
          #   Max: 300 characters.
          # @param context [Object, nil] The context to use for the action.
          # @param options [Hash] Additional options for the action.
          # @option options [String, nil] :label The label for the action.
          # @option options [String, nil] :display_text The text displayed in the chat.
          # @param &block [Proc, nil] A block to be executed in the context of the new action.
          def initialize(data, context: nil, **options, &)
            @data = data

            super(context: context, **options, &)
          end

          # Returns a hash representation of the postback action.
          #
          # @raise [RequiredError] if data is nil.
          # @return [Hash] A hash representing the postback action.
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
