# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a Text component in a Flex Message.
        # Text components can display strings with various styling options.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#text
        class Text < Line::Message::Builder::Base
          include Actionable           # For defining actions on text
          # @!parse include Position::Horizontal
          # @!parse include Position::Vertical
          # @!parse include Position::Margin
          # @!parse include Position::Offset
          # @!parse include Size::Flex
          # @!parse include Size::Shared
          # @!parse include Size::AdjustMode
          include Position::Horizontal # For `align` option
          include Position::Vertical   # For `gravity` option
          include Position::Margin     # For `margin` option
          include Position::Offset     # For `position`, `offset_...` options
          include Size::Flex           # For `flex` factor
          include Size::Shared         # For `size` (font size) option
          include Size::AdjustMode     # For `adjust_mode` option

          # @!attribute [r] text
          #   @return [String] The content of the text component.
          attr_reader :text

          # @!attribute wrap
          #   @return [Boolean] Whether text should wrap. Defaults to `false`.
          #     If `true`, text wraps to the next line. If `false`, text exceeding the width is truncated.
          #   @see https://developers.line.biz/en/reference/messaging-api/#text-wrap
          option :wrap, default: false
          # @!attribute line_spacing
          #   @return [String, nil] The spacing between lines of text (e.g., "10px", "md").
          #   @see https://developers.line.biz/en/reference/messaging-api/#text-linespacing
          option :line_spacing, default: nil, validator: Validators::Size.new(:pixel, :keyword)
          # @!attribute color
          #   @return [String, nil] The color of the text (e.g., "#RRGGBB", "#RRGGBBAA").
          #   @see https://developers.line.biz/en/reference/messaging-api/#text-color
          option :color, default: nil # Validator could be added for color hex format

          # Initializes a new Text component.
          #
          # @param text_content [String] The string content to display.
          # @param context [Object, nil] The context for the text component.
          # @param options [Hash] Options for the text (e.g., wrap, color, size, action).
          # @param block [Proc, nil] An optional block for further configuration, typically for defining an action.
          def initialize(text_content, context: nil, **options, &)
            @text = text_content

            super(context: context, **options, &)
          end

          # A shorthand method to set the `wrap` option to `true`.
          # @return [true]
          def wrap!
            self.wrap = true # Use the writer method
          end

          # Converts the Text component to its hash representation for the LINE API.
          #
          # @raise [RequiredError] if `text` content is not set.
          # @return [Hash] The hash representation of the text component.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "text is required" if text.nil?

            {
              type: "text",
              text: text,
              wrap: wrap,
              # Position
              align: align&.to_s,         # From Position::Horizontal
              gravity: gravity&.to_s,       # From Position::Vertical
              # Position::Margin
              margin: margin,            # From Position::Margin
              # Position::Offset
              position: position&.to_s,     # From Position::Offset
              offsetTop: offset_top,       # From Position::Offset
              offsetBottom: offset_bottom,   # From Position::Offset
              offsetStart: offset_start,     # From Position::Offset
              offsetEnd: offset_end,       # From Position::Offset
              # Size::Flex
              flex: flex,                # From Size::Flex
              # Size::Shared
              size: size&.to_s,             # From Size::Shared (font size)
              # Size::AdjustMode
              adjustMode: adjust_mode&.to_s, # From Size::AdjustMode
              # Text specific
              lineSpacing: line_spacing,   # From self
              color: color,              # From self
              action: action&.to_h         # From Actionable
            }.compact
          end
        end
      end
    end
  end
end
