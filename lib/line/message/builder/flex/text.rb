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
          include Position::Offset
          include Size::Flex
          include Size::Shared

          attr_reader :text

          option :wrap, default: false
          option :line_spacing, default: nil
          option :color, default: nil

          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          def wrap!
            @wrap = true
          end

          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "text is required" if text.nil?

            {
              type: "text",
              text: text,
              wrap: wrap,
              # Position
              align: align,
              gravity: gravity,
              # Position::Margin
              margin: margin,
              # Position::Offset
              position: position,
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              # Size::Flex
              flex: flex,
              # Size::Shared
              size: size,
              lineSpacing: line_spacing,
              color: color,
              action: action&.to_h
            }.compact
          end
        end
      end
    end
  end
end
