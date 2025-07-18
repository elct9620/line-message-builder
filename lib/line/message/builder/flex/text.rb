# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "text" component in a LINE Flex Message.
        #
        # Text components are used to display strings of text. They offer various
        # styling options, including font `size`, `weight` (via styles in a {Box}
        # or {Bubble}), `color`, `align`ment, `gravity`, text `wrap`ping,
        # `line_spacing`, and more. A text component can also have an
        # {Actionable#action action} to make it tappable.
        #
        # Text components also support embedded {Span} components, which allow parts of
        # the text to have different styling. Spans can be added to a text component
        # using the {#span} method within the Text component block.
        #
        # @example Creating a text component within a box
        #   Line::Message::Builder.with do
        #     flex alt_text: "Text Example" do
        #       bubble do
        #         body do
        #           text "Hello, Flex World!",
        #                size: :xl,
        #                color: "#FF0000",
        #                wrap: true do
        #                  message "More info", text: "Tell me more about text"
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # @example Creating a text component with spans
        #   Line::Message::Builder.with do
        #     flex alt_text: "Span Example" do
        #       bubble do
        #         body do
        #           text "This message has styled spans:" do
        #             span "Red", color: "#FF0000"
        #             span " and ", size: :sm
        #             span "Bold", weight: :bold
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#text
        # @see Actionable For making the text tappable.
        # @see Position::Horizontal For `align` property.
        # @see Position::Vertical For `gravity` property.
        # @see Position::Margin For `margin` property.
        # @see Position::Offset For offset properties.
        # @see Size::Flex For `flex` sizing property.
        # @see Size::Shared For common `size` keywords (e.g., `:xl`, `:sm`).
        # @see Size::AdjustMode For `adjust_mode` property.
        class Text < Line::Message::Builder::Base
          include Actionable           # Enables defining an action for the text.
          include Position::Horizontal # Adds `align` option.
          include Position::Vertical   # Adds `gravity` option.
          include Position::Margin     # Adds `margin` option.
          include Position::Offset     # Adds offset options.
          include Size::Flex           # Adds `flex` option for sizing within a parent box.
          include Size::Shared         # Adds `size` option (e.g., :sm, :md, :xl).
          include Size::AdjustMode # Adds `adjust_mode` option.

          # @!attribute [r] text
          #   @return [String] The actual text content to be displayed.
          #     This is a required attribute.
          attr_reader :text, :contents

          # Specifies whether the text should wrap or be truncated if it exceeds
          # the component's width.
          # @!method wrap(value)
          #   @param value [Boolean] `true` to enable text wrapping, `false` (default) to disable.
          #   @return [Boolean] The current wrap setting.
          option :wrap, default: false

          # Specifies the spacing between lines of text.
          # Can be a pixel value (e.g., "10px") or a keyword.
          # @!method line_spacing(value)
          #   @param value [String, nil] The line spacing value (e.g., `"5px"`).
          #   @return [String, nil] The current line spacing.
          option :line_spacing, default: nil # API key: lineSpacing

          # Specifies the color of the text.
          # @!method color(value)
          #   @param value [String, nil] Hexadecimal color code (e.g., `"#RRGGBB"`, `"#RRGGBBAA"`).
          #   @return [String, nil] The current text color.
          option :color, default: nil

          # Initializes a new Flex Message Text component.
          #
          # @param text_content [String] The text to display. This is required.
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables
          #   (e.g., `:wrap`, `:color`, `:size`, and options from included modules).
          # @param block [Proc, nil] An optional block, typically used to define an
          #   {Actionable#action action} for the text.
          # @raise [ArgumentError] if `text_content` is nil (though the more specific
          #   `RequiredError` is raised in `to_h`).
          def initialize(text_content = nil, context: nil, **options, &)
            @text = text_content # The text content is mandatory.
            @contents = []       # Initialize contents for spans, if any.

            super(context: context, **options, &) # Sets options and evals block (for action).
          end

          # A convenience DSL method to set the `wrap` property to `true`.
          #
          # @example
          #   text_component.text "Long text..."
          #   text_component.wrap! # Enables text wrapping
          #
          # @return [true]
          def wrap!
            wrap(true) # Use the setter generated by `option`
          end

          # Adds a {Span} component to this text component's contents.
          #
          # Spans allow different styling for parts of the text, such as color,
          # weight, size, and decoration.
          #
          # @param text_content [String] The span text content.
          # @param options [Hash] Options for the span. See {Span#initialize}.
          # @param block [Proc, nil] An optional block for advanced span configuration.
          # @return [Flex::Span] The newly created Span object.
          # @example
          #   text "Message with spans:" do
          #     span "Important", color: "#FF0000", weight: :bold
          #     span " normal text"
          #   end
          def span(text_content, **options, &)
            @contents << Span.new(text_content, context: @context, **options, &)
          end

          def any_content?
            !contents.empty? || !text.nil?
          end

          def to_h
            raise RequiredError, "text content is required for a text component" unless any_content?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "text",
              text: text,
              contents: contents.map(&:to_h), # Convert spans to hash
              wrap: wrap,               # From option
              color: color,             # From option
              lineSpacing: line_spacing, # From option (maps to API key)
              # Position::Horizontal & Position::Vertical
              align: align,     # From Position::Horizontal
              gravity: gravity, # From Position::Vertical
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
              # Size::Shared & Size::AdjustMode
              size: size,               # From Size::Shared
              adjustMode: adjust_mode,  # From Size::AdjustMode
              # Actionable
              action: action&.to_h # From Actionable module
            }.compact
          end

          def to_sdkv2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "text",
              text: text,
              contents: contents.map(&:to_h), # Convert spans to hash
              wrap: wrap,               # From option
              color: color,             # From option
              line_spacing: line_spacing, # From option (maps to API key)
              # Position::Horizontal & Position::Vertical
              align: align,     # From Position::Horizontal
              gravity: gravity, # From Position::Vertical
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
              # Size::Shared & Size::AdjustMode
              size: size, # From Size::Shared
              adjust_mode: adjust_mode, # From Size::AdjustMode
              # Actionable
              action: action&.to_h # From Actionable module
            }.compact
          end
        end
      end
    end
  end
end
