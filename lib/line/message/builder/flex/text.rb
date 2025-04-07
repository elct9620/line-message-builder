# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The text is a component of the Flex message.
        class Text < Line::Message::Builder::Base
          include Actionable
          include Position::Horizontal
          include Position::Vertical
          include Position::Margin

          attr_reader :text

          option :size, default: nil
          option :wrap, default: false
          option :line_spacing, default: nil
          option :color, default: nil
          option :flex, default: nil

          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          def wrap!
            @wrap = true
          end

          def to_h # rubocop:disable Metrics/MethodLength
            raise RequiredError, "text is required" if text.nil?

            {
              type: "text",
              text: text,
              # Position
              align: align,
              gravity: gravity,
              # Position::Margin
              margin: margin,
              wrap: wrap,
              lineSpacing: line_spacing,
              color: color,
              size: size,
              flex: flex,
              action: action&.to_h
            }.compact
          end
        end
      end
    end
  end
end
