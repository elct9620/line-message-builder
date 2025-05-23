# frozen_string_literal: true

module Line
  module Message
    module Builder
      # Represents a standard text message in the LINE Messaging API.
      # This class provides a DSL for constructing text messages, optionally
      # including a {QuickReply} and a quote token.
      #
      # Usage:
      #   ```ruby
      #   Line::Message::Builder.with do
      #     text "Hello, world! This is a simple text message."
      #   end
      #
      #   Line::Message::Builder.with do
      #     text "Reply to this message!", quote_token: "user_provided_quote_token" do
      #       quick_reply do
      #         message "Option 1", label: "Opt1"
      #       end
      #     end
      #   end
      #   ```
      #
      # @see https://developers.line.biz/en/reference/messaging-api/#text-message
      class Text < Base
        # @!attribute [r] text
        #   @return [String] The content of the text message.
        attr_reader :text

        # @!attribute quote_token
        #   @return [String, nil] A quote token used to quote a previous message sent by a user.
        #     This is obtained from webhook events when a user quotes a message.
        #     Max: 32 characters.
        #   @see https://developers.line.biz/en/reference/messaging-api/#set-quote-token
        option :quote_token, default: nil # TODO: Add validator for length if desired

        # Initializes a new Text message.
        #
        # @param text_content [String] The main text content of the message. Max 5000 characters.
        # @param context [Object, nil] An optional external context.
        # @param options [Hash] Additional options for the text message, such as `quote_token`.
        # @param block [Proc, nil] An optional block executed in the context of the new Text instance.
        #   Typically used to define a {QuickReply} using the `quick_reply` DSL method.
        def initialize(text_content, context: nil, **options, &block)
          @text = text_content
          # TODO: Add validation for text length if desired (max 5000 characters)

          super(context: context, **options, &block)
        end

        # Converts the Text message object to its hash representation for the LINE API.
        #
        # @return [Hash] A hash representing the text message, including its type,
        #   text content, optional quote token, and optional quick reply.
        def to_h
          {
            type: "text",
            text: @text,
            quoteToken: quote_token, # Uses the accessor, which respects default
            quickReply: @quick_reply&.to_h # @quick_reply is from Base class
          }.compact
        end
      end
    end
  end
end
