# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a text component in a LINE Flex Message.
        #
        # Text components are used to display strings of text. They offer various
        # styling options, including font +size+, +weight+, +style+, +decoration+,
        # +color+, +align+ment, +gravity+, text +wrap+ping, +line_spacing+,
        # +max_lines+, +scaling+, and more. A text component can also have an
        # action to make it tappable.
        #
        # Text components also support embedded Span components, which allow parts of
        # the text to have different styling. Spans can be added to a text component
        # using the +span+ method within the Text component block.
        #
        # == Example: Creating a text component within a box
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Text Example" do
        #       bubble do
        #         body do
        #           text "Hello, Flex World!",
        #                size: :xl,
        #                color: "#FF0000",
        #                wrap: true do
        #                  message "Tell me more about text", label: "More info"
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # == Example: Creating a text component with spans
        #
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
        # === Example: Emphasising a heading and truncating a long body
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Article" do
        #       bubble do
        #         body do
        #           text "Ruby Taiwan Meetup", weight: :bold, size: :xl
        #           text long_article_body, wrap: true, max_lines: 3
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#text
        # - Actionable for making the text tappable
        # - Position::Horizontal for +align+ property
        # - Position::Vertical for +gravity+ property
        # - Position::Margin for +margin+ property
        # - Position::Offset for offset properties
        # - Size::Flex for +flex+ sizing property
        # - Size::Shared for common +size+ keywords (e.g., +:xl+, +:sm+)
        # - Size::AdjustMode for +adjust_mode+ property
        class Text < Line::Message::Builder::Base
          include Actionable           # Enables defining an action for the text.
          include Position::Horizontal # Adds `align` option.
          include Position::Vertical   # Adds `gravity` option.
          include Position::Margin     # Adds `margin` option.
          include Position::Offset     # Adds offset options.
          include Size::Flex           # Adds `flex` option for sizing within a parent box.
          include Size::Shared         # Adds `size` option (e.g., :sm, :md, :xl).
          include Size::AdjustMode # Adds `adjust_mode` option.

          # The actual text content to be displayed (required attribute).
          attr_reader :text

          # Array of Span components for styled text segments.
          attr_reader :contents

          # :method: wrap
          # :call-seq:
          #   wrap() -> Boolean
          #   wrap(value) -> Boolean
          #
          # Sets or gets whether the text should wrap or be truncated if it exceeds
          # the component's width.
          #
          # [value]
          #   +true+ to enable text wrapping, +false+ (default) to disable
          option :wrap, default: false

          # :method: line_spacing
          # :call-seq:
          #   line_spacing() -> String or nil
          #   line_spacing(value) -> String
          #
          # Sets or gets the spacing between lines of text.
          # Can be a pixel value or a keyword.
          #
          # [value]
          #   The line spacing value (e.g., <code>"5px"</code>)
          option :line_spacing, default: nil # API key: lineSpacing

          # :method: color
          # :call-seq:
          #   color() -> String or nil
          #   color(value) -> String
          #
          # Sets or gets the color of the text.
          #
          # [value]
          #   Hexadecimal color code (e.g., <code>"#RRGGBB"</code>, <code>"#RRGGBBAA"</code>)
          option :color, default: nil

          # :method: weight
          # :call-seq:
          #   weight() -> Symbol or nil
          #   weight(value) -> Symbol
          #
          # Sets or gets the font weight of the text.
          #
          # [value]
          #   <code>:regular</code> (default) or <code>:bold</code>
          option :weight, default: nil, validator: Validators::Enum.new(:regular, :bold)

          # :method: max_lines
          # :call-seq:
          #   max_lines() -> Integer or nil
          #   max_lines(value) -> Integer
          #
          # Sets or gets the maximum number of lines to display. Text exceeding
          # this number of lines ends in an ellipsis. A value of +0+ displays the
          # entire text.
          #
          # [value]
          #   The maximum number of lines
          option :max_lines, default: nil # API key: maxLines

          # :method: style
          # :call-seq:
          #   style() -> Symbol or nil
          #   style(value) -> Symbol
          #
          # Sets or gets the font style of the text.
          #
          # [value]
          #   <code>:normal</code> (default) or <code>:italic</code>
          option :style, default: nil, validator: Validators::Enum.new(:normal, :italic)

          # :method: decoration
          # :call-seq:
          #   decoration() -> Symbol or nil
          #   decoration(value) -> Symbol
          #
          # Sets or gets the decoration of the text. A decoration set here cannot
          # be overwritten by the +decoration+ of a nested Span.
          #
          # [value]
          #   <code>:none</code> (default), <code>:underline</code> or
          #   <code>:"line-through"</code>
          option :decoration, default: nil, validator: Validators::Enum.new(:none, :underline, :"line-through")

          # :method: scaling
          # :call-seq:
          #   scaling() -> Boolean or nil
          #   scaling(value) -> Boolean
          #
          # Sets or gets whether the font size follows the font size setting of
          # the LINE app. Spans nested in this text are scaled as well.
          #
          # [value]
          #   +true+ to scale the font size, +false+ (default) to keep it fixed
          option :scaling, default: nil

          # Initializes a new Flex Message Text component.
          #
          # [text_content]
          #   The text to display (required)
          # [context]
          #   An optional context for the builder
          # [options]
          #   A hash of options to set instance variables
          #   (e.g., +:wrap+, +:color+, +:size+, and options from included modules)
          # [block]
          #   An optional block, typically used to define an action for the text
          #
          # Raises RequiredError if +text_content+ is nil (in +to_h+).
          def initialize(text_content = nil, context: nil, **, &)
            @text = text_content # The text content is mandatory.
            @contents = []       # Initialize contents for spans, if any.

            super(context: context, **, &) # Sets options and evals block (for action).
          end

          # A convenience DSL method to set the +wrap+ property to +true+.
          #
          # == Example
          #
          #   text_component.text "Long text..."
          #   text_component.wrap! # Enables text wrapping
          def wrap!
            wrap(true) # Use the setter generated by `option`
          end

          # Adds a Span component to this text component's contents.
          #
          # Spans allow different styling for parts of the text, such as color,
          # weight, size, and decoration.
          #
          # [text_content]
          #   The span text content
          # [options]
          #   Options for the span (see Span)
          # [block]
          #   An optional block for advanced span configuration
          #
          # == Example
          #
          #   text "Message with spans:" do
          #     span "Important", color: "#FF0000", weight: :bold
          #     span " normal text"
          #   end
          def span(text_content, **, &)
            @contents << Span.new(text_content, context: @context, **, &)
          end

          # :nodoc:
          def any_content?
            !contents.empty? || !text.nil?
          end

          # :nodoc:
          def to_h
            raise RequiredError, "text content is required for a text component" unless any_content?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          # :nodoc:
          def to_api # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "text",
              text: text,
              contents: contents.map(&:to_h), # Convert spans to hash
              wrap: wrap,               # From option
              color: color,             # From option
              lineSpacing: line_spacing, # From option (maps to API key)
              weight: weight,           # From option
              maxLines: max_lines,      # From option (maps to API key)
              style: style,             # From option
              decoration: decoration,   # From option
              scaling: scaling,         # From option
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

          # :nodoc:
          def to_sdkv2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "text",
              text: text,
              contents: contents.map(&:to_h), # Convert spans to hash
              wrap: wrap,               # From option
              color: color,             # From option
              line_spacing: line_spacing, # From option (maps to API key)
              weight: weight,           # From option
              max_lines: max_lines,     # From option (maps to API key)
              style: style,             # From option
              decoration: decoration,   # From option
              scaling: scaling,         # From option
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
