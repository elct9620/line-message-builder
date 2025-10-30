# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "button" component in a LINE Flex Message.
        #
        # Buttons are interactive elements that users can tap to trigger an action
        # (e.g., open a URL, send a message, or trigger a postback). They have
        # various styling options, including +style+ (primary, secondary, link) and
        # +height+.
        #
        # An action is mandatory for a button component.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Button Example" do
        #       bubble do
        #         body do
        #           button style: :primary, height: :sm do
        #             message "Buy Now", label: "Buy" # Action definition
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#button
        # - Actionable for defining the button's action (mandatory)
        # - Position::Vertical for +gravity+ property
        # - Position::Padding for padding properties
        # - Position::Margin for +margin+ property
        # - Position::Offset for offset properties
        # - Size::Flex for flex sizing property
        # - Size::AdjustMode for +adjust_mode+ property
        class Button < Line::Message::Builder::Base
          include Actionable # Defines the action performed when the button is tapped.
          include Position::Vertical # Adds `gravity` option for vertical alignment.
          include Position::Padding  # Adds padding options.
          include Position::Margin   # Adds `margin` option.
          include Position::Offset   # Adds offset options.
          include Size::Flex         # Adds `flex` option for sizing within a parent box.
          include Size::AdjustMode   # Adds `adjust_mode` option.

          # :method: style
          # :call-seq:
          #   style() -> Symbol
          #   style(value) -> Symbol
          #
          # Sets or gets the button style.
          #
          # [value]
          #   Button style. Can be +:primary+, +:secondary+, or +:link+ (default).
          #   String values should match these keywords.
          option :style, default: :link

          # :method: height
          # :call-seq:
          #   height() -> Symbol
          #   height(value) -> Symbol
          #
          # Sets or gets the button height.
          #
          # [value]
          #   Button height. Can be +:sm+ (small) or +:md+ (medium, default).
          option :height, default: :md, validator: Validators::Enum.new(:sm, :md)

          # Initializes a new Flex Message Button component.
          #
          # The provided block is instance-eval'd, primarily used to define the
          # button's action using methods from the Actionable module (e.g., +message+).
          #
          # [context]
          #   An optional context for the builder
          # [options]
          #   A hash of options to set instance variables
          #   (e.g., +:style+, +:height+, and options from included modules)
          # [block]
          #   A block to define the button's action and other properties.
          #   This block is where you should call an action method like +message+ or +postback+.
          def initialize(context: nil, **options, &)
            super # Calls Base#initialize, sets options, and evals block (which should define the action)
          end

          private

          # :nodoc:
          def to_api # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required for a button" if action.nil?

            {
              type: "button",
              action: action.to_h, # From Actionable module
              style: style,         # From option
              height: height,       # From option
              # Position::Vertical
              gravity: gravity,
              # Position::Padding
              paddingAll: padding || padding_all,
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
              adjustMode: adjust_mode
            }.compact
          end

          # :nodoc:
          def to_sdkv2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required for a button" if action.nil?

            {
              type: "button",
              action: action.to_h, # From Actionable module
              style: style,         # From option
              height: height,       # From option
              # Position::Vertical
              gravity: gravity,
              # Position::Padding
              padding_all: padding || padding_all,
              padding_top: padding_top,
              padding_bottom: padding_bottom,
              padding_start: padding_start,
              padding_end: padding_end,
              # Position::Margin
              margin: margin,
              # Position::Offset
              position: position,
              offset_top: offset_top,
              offset_bottom: offset_bottom,
              offset_start: offset_start,
              offset_end: offset_end,
              # Size::Flex
              flex: flex,
              # Size::AdjustMode
              adjust_mode: adjust_mode
            }.compact
          end
        end
      end
    end
  end
end
