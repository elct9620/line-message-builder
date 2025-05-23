# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a Button component in a Flex Message.
        # Buttons can trigger actions such as opening a URL, sending a message, or initiating a postback.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#button
        class Button < Line::Message::Builder::Base
          include Actionable # Provides `action`, `message`, `postback`
          # @!parse include Position::Vertical
          # @!parse include Position::Padding
          # @!parse include Position::Margin
          # @!parse include Position::Offset
          # @!parse include Size::Flex
          # @!parse include Size::AdjustMode
          include Position::Vertical
          include Position::Padding
          include Position::Margin
          include Position::Offset
          include Size::Flex
          include Size::AdjustMode

          # @!attribute style
          #   @return [:primary, :secondary, :link] The style of the button.
          #     Defaults to `:link`.
          #   @see https://developers.line.biz/en/reference/messaging-api/#button-style
          option :style, default: :link, validator: Validators::Enum.new(:primary, :secondary, :link)
          # @!attribute height
          #   @return [:sm, :md] The height of the button. Defaults to `:md`.
          #   @see https://developers.line.biz/en/reference/messaging-api/#button-height
          option :height, default: :md, validator: Validators::Enum.new(:sm, :md)
          # Note: `color` (text color) and `gravity` are also available via options from included modules/base if needed.

          # Converts the Button component to its hash representation for the LINE API.
          #
          # @raise [RequiredError] if an action is not defined for the button.
          # @return [Hash] The hash representation of the button.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required" if action.nil?

            {
              type: "button",
              action: action.to_h, # From Actionable
              height: height.to_s, # Ensure enum is string
              # Position::Vertical
              gravity: gravity&.to_s, # Ensure enum is string; from Position::Vertical (assuming it adds `gravity` option)
              # Position::Padding
              paddingAll: padding_all, # Corrected from `padding`
              paddingTop: padding_top,
              paddingBottom: padding_bottom,
              paddingStart: padding_start,
              paddingEnd: padding_end,
              # Position::Margin
              margin: margin, # From Position::Margin
              # Position::Offset
              position: position&.to_s, # Ensure enum is string
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              # Size::Flex
              flex: flex, # From Size::Flex
              # Size::AdjustMode
              adjustMode: adjust_mode&.to_s, # Ensure enum is string
              style: style.to_s # Ensure enum is string
            }.compact
          end
        end
      end
    end
  end
end
