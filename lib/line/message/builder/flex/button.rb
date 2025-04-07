# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The button is a component of the Flex message.
        class Button < Line::Message::Builder::Base
          include Actionable
          include Position::Vertical
          include Position::Padding
          include Position::Margin
          include Position::Offset

          option :flex, default: nil
          option :style, default: :link
          option :height, default: :md

          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required" if action.nil?

            {
              type: "button",
              action: action.to_h,
              # Position
              grivity: gravity,
              # Position::Padding
              paddingAll: padding,
              paddingTop: padding_top,
              paddingBottom: padding_bottom,
              paddingStart: padding_start,
              paddingEnd: padding_end,
              # Position::Margin
              margin: margin,
              # Position::Offset
              position: position,
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              flex: flex,
              style: style,
              height: height
            }.compact
          end
        end
      end
    end
  end
end
