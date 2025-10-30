# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Text class provides a builder for creating simple text messages
      # in the LINE Messaging API. Text messages are the most basic message type,
      # consisting of plain text content with optional quick reply buttons and
      # quote tokens for replying to specific messages.
      #
      # Text messages support:
      # - Plain text content (up to 5,000 characters)
      # - Quick reply buttons for user interaction
      # - Quote tokens to reply to specific messages in a conversation
      #
      # == Example: Basic text message
      #
      #   Line::Message::Builder.with do
      #     text "Hello, world!"
      #   end
      #
      # == Example: Text with quick reply
      #
      #   Line::Message::Builder.with do
      #     text "Choose an option:" do
      #       quick_reply do
      #         button action: :message, label: "Yes", text: "I agree"
      #         button action: :message, label: "No", text: "I disagree"
      #       end
      #     end
      #   end
      #
      # == Example: Text with quote token
      #
      #   Line::Message::Builder.with do
      #     text "This is a reply" do
      #       quote_token "sample_quote_token_value"
      #     end
      #   end
      #
      # The Text builder inherits from Base and can be used within the
      # Line::Message::Builder.with block using the +text+ method.
      class Text < Base
        # :method: quote_token
        # :call-seq:
        #   quote_token() -> String or nil
        #   quote_token(value) -> String
        #
        # Sets or gets the quote token for replying to a specific message.
        #
        # Quote tokens allow your bot to quote and reply to a specific message
        # in the conversation. When set, the original message being replied to
        # will be displayed above the new message.
        #
        # [value]
        #   The quote token string obtained from a webhook event
        option :quote_token, default: nil

        # Creates a new text message builder.
        #
        # [text]
        #   The text content of the message (up to 5,000 characters)
        # [context]
        #   An optional context object for method delegation (default: +nil+)
        # [option]
        #   Additional options to configure the text message
        # [block]
        #   Optional block for configuring quick replies or quote token
        #
        # == Example
        #
        #   text = Text.new("Hello!", context: view_context) do
        #     quick_reply do
        #       button action: :message, label: "Hi", text: "Hi back!"
        #     end
        #   end
        def initialize(text, context: nil, **options, &block)
          @text = text

          super(context: context, **options, &block)
        end

        private

        def to_api # :nodoc:
          {
            type: "text",
            text: @text,
            quoteToken: quote_token,
            quickReply: @quick_reply&.to_h
          }.compact
        end

        def to_sdkv2 # :nodoc:
          {
            type: "text",
            text: @text,
            quote_token: quote_token,
            quick_reply: @quick_reply&.to_h
          }.compact
        end
      end
    end
  end
end
