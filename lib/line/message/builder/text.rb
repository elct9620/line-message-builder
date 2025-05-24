# frozen_string_literal: true

module Line
  module Message
    module Builder
      # Text message builder.
      class Text < Base
        option :quote_token, default: nil

        def initialize(text, context: nil, **options, &block)
          @text = text

          super(context: context, **options, &block)
        end

        private

        def to_api
          {
            type: "text",
            text: @text,
            quoteToken: quote_token,
            quickReply: @quick_reply&.to_h
          }.compact
        end

        def to_sdkv2
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
