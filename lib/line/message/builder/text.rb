# frozen_string_literal: true

module Line
  module Message
    module Builder
      # Text message builder.
      class Text < Base
        def initialize(text, context: nil, &block)
          @text = text

          super(context: context, &block)
        end

        def to_h
          {
            type: "text",
            text: @text,
            quickReply: @quick_reply&.to_h
          }.compact
        end
      end
    end
  end
end
