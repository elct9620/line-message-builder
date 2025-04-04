# frozen_string_literal: true

module Line
  module Message
    class Builder
      # Text message builder.
      class Text < Base
        include QuickReply

        def initialize(text, context: nil, &block)
          @text = text

          super(context: context, &block)
        end

        def to_h
          {
            type: "text",
            text: @text,
            quickReply: @quick_reply&.to_h
          }.compact!
        end
      end
    end
  end
end
