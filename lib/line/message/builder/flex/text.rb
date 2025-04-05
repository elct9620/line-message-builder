# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The text is a component of the Flex message.
        class Text < Line::Message::Builder::Base
          option :wrap, default: false
          option :line_spacing, default: nil
          option :color, default: nil
          option :size, default: nil
          option :align, default: nil
          option :flex, default: nil

          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          def wrap!
            @wrap = true
          end

          def to_h
            {
              type: "text",
              text: @text,
              wrap: @wrap,
              lineSpacing: @line_spacing,
              color: @color,
              size: @size,
              align: @align,
              flex: @flex
            }.compact
          end
        end
      end
    end
  end
end
