# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The text is a component of the Flex message.
        class Text < Line::Message::Builder::Base
          def initialize(text, wrap: false, line_spacing: nil, context: nil, &)
            @text = text
            @wrap = wrap
            @line_spacing = line_spacing

            super(context: context, &)
          end

          def wrap!
            @wrap = true
          end

          def line_spacing(value)
            @line_spacing = value
          end

          def to_h
            {
              type: "text",
              text: @text,
              wrap: @wrap,
              lineSpacing: @line_spacing
            }.compact
          end
        end
      end
    end
  end
end
