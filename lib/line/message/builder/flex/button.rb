# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "button" component in a LINE Flex Message.
        #
        # Buttons are interactive elements that users can tap to trigger an {Actionable#action action}
        # (e.g., open a URL, send a message, or trigger a postback). They have
        # various styling options, including `style` (primary, secondary, link) and
        # `height`.
        #
        # An action is mandatory for a button component.
        #
        # @example Creating a button that sends a message
        #   Line::Message::Builder.with do |root|
        #     root.flex alt_text: "Button Example" do |flex|
        #       flex.bubble do |bubble|
        #         bubble.body do |body_box|
        #           body_box.button style: :primary, height: :sm do |btn|
        #             btn.message "Buy Now", label: "Buy" # Action definition
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#button
        # @see Actionable For defining the button's action (mandatory).
        # @see Position::Vertical For `gravity` property.
        # @see Position::Padding For padding properties.
        # @see Position::Margin For margin property.
        # @see Position::Offset For offset properties.
        # @see Size::Flex For flex sizing property.
        # @see Size::AdjustMode For `adjust_mode` property.
        class Button < Line::Message::Builder::Base
          include Actionable # Defines the action performed when the button is tapped.
          include Position::Vertical # Adds `gravity` option for vertical alignment.
          include Position::Padding  # Adds padding options.
          include Position::Margin   # Adds `margin` option.
          include Position::Offset   # Adds offset options.
          include Size::Flex         # Adds `flex` option for sizing within a parent box.
          include Size::AdjustMode   # Adds `adjust_mode` option.

          # Specifies the style of the button.
          # @!method style(value)
          #   @param value [Symbol, String] Button style.
          #     Can be `:primary`, `:secondary`, `:link` (default).
          #     String values should match these keywords.
          #   @return [Symbol, String] The current button style.
          option :style, default: :link

          # Specifies the height of the button.
          # @!method height(value)
          #   @param value [Symbol, String] Button height.
          #     Can be `:sm` (small) or `:md` (medium, default).
          #   @return [Symbol, String] The current button height.
          option :height, default: :md, validator: Validators::Enum.new(:sm, :md)

          # Initializes a new Flex Message Button component.
          # The provided block is instance-eval'd, primarily used to define the
          # button's action using methods from the {Actionable} module (e.g., `message "label"`).
          #
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables
          #   (e.g., `:style`, `:height`, and options from included modules).
          # @param block [Proc, nil] A block to define the button's action and other properties.
          #   This block is where you should call an action method like `message` or `postback`.
          def initialize(context: nil, **options, &)
            super # Calls Base#initialize, sets options, and evals block (which should define the action)
          end

          # Converts the Button component and its properties to a hash suitable for
          # the LINE Messaging API.
          #
          # @return [Hash] A hash representing the button component.
          # @raise [RequiredError] if no `action` is defined for the button.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "action is required for a button" if action.nil?

            {
              type: "button",
              action: action.to_h, # From Actionable module
              style: style,         # From option
              height: height,       # From option
              # Position::Vertical
              gravity: gravity, # Corrected from `grivity`
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
        end
      end
    end
  end
end
