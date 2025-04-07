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
          include Size::Flex
          include Size::AdjustMode

          option :style, default: :link
          option :height, default: :md, validator: Validators::Enum.new(:sm, :md)

          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required" if action.nil?

            {
              type: "button",
              action: action.to_h,
              height: height,
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
              # Size::Flex
              flex: flex,
              # Size::AdjustMode
              adjustMode: adjust_mode,
              style: style
            }.compact
          end
        end
      end
    end
  end
end
