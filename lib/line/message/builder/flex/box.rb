# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "box" component in a LINE Flex Message.
        #
        # A box is a fundamental layout container that arranges its child components
        # (+contents+) in a specified direction (+layout+: horizontal, vertical, or
        # baseline). It can hold various other components like text, images, buttons,
        # or even nested boxes, allowing for complex layouts.
        #
        # Boxes have numerous properties to control their appearance and the
        # arrangement of their children, such as padding, margin, spacing between
        # items, justification, and alignment.
        #
        # A box can also have an +action+ associated with it, making the entire
        # box area tappable.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Box example" do
        #       bubble do
        #         body do
        #           layout :horizontal
        #           spacing :md
        #           text "Item 1"
        #           text "Item 2"
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#box
        # - Actionable for making the box tappable
        # - HasPartial for including reusable component groups
        # - Position::Padding for padding properties
        # - Position::Margin for margin properties
        # - Position::Offset for offset properties
        # - Size::Flex for flex sizing property
        class Box < Line::Message::Builder::Base
          include HasPartial # Allows including predefined partial component sets.
          include Actionable # Enables defining an action for the entire box.
          include Position::Padding  # Adds padding options like +padding_all+, +padding_top+, etc.
          include Position::Margin   # Adds +margin+ option.
          include Position::Offset   # Adds offset options like +offset_top+, +offset_start+, etc.
          include Size::Flex         # Adds +flex+ option for controlling size within a parent box.

          # An array holding the child components (e.g., Text, Image, nested Box instances) of this box.
          attr_reader :contents

          # :method: layout
          # :call-seq:
          #   layout() -> Symbol
          #   layout(value) -> Symbol
          #
          # Specifies the arrangement of child components.
          #
          # [value]
          #   +:horizontal+ (default), +:vertical+, or +:baseline+
          option :layout, default: :horizontal, validator: Validators::Enum.new(
            :horizontal, :vertical, :baseline
          )

          # :method: justify_content
          # :call-seq:
          #   justify_content() -> Symbol or nil
          #   justify_content(value) -> Symbol
          #
          # Horizontal alignment of content in a horizontal box; vertical alignment in a vertical box.
          #
          # [value]
          #   +:flex_start+, +:center+, +:flex_end+, +:space_between+, +:space_around+, or +:space_evenly+
          option :justify_content, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end, :space_between, :space_around, :space_evenly
          )

          # :method: align_items
          # :call-seq:
          #   align_items() -> Symbol or nil
          #   align_items(value) -> Symbol
          #
          # Vertical alignment of content in a horizontal box; horizontal alignment in a vertical box.
          #
          # [value]
          #   +:flex_start+, +:center+, or +:flex_end+
          option :align_items, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end
          )

          # :method: spacing
          # :call-seq:
          #   spacing() -> String, Symbol, or nil
          #   spacing(value) -> String or Symbol
          #
          # Specifies the minimum spacing between components.
          # Not applicable if +layout+ is +:baseline+ or if the box contains only one component.
          #
          # [value]
          #   <code>"md"</code>, +:lg+, <code>"10px"</code>, or keywords: +:none+, +:xs+, +:sm+, +:md+, +:lg+, +:xl+, +:xxl+
          option :spacing, default: nil, validator: Validators::Size.new(:pixel, :keyword)

          # :method: width
          # :call-seq:
          #   width() -> String or nil
          #   width(value) -> String
          #
          # Width of the box. Can be a percentage or pixel value.
          #
          # [value]
          #   <code>"100px"</code> or <code>"50%"</code>
          option :width, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # :method: max_width
          # :call-seq:
          #   max_width() -> String or nil
          #   max_width(value) -> String
          #
          # Maximum width of the box.
          #
          # [value]
          #   <code>"100px"</code> or <code>"50%"</code>
          option :max_width, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # :method: height
          # :call-seq:
          #   height() -> String or nil
          #   height(value) -> String
          #
          # Height of the box.
          #
          # [value]
          #   <code>"100px"</code> or <code>"50%"</code>
          option :height, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # :method: max_height
          # :call-seq:
          #   max_height() -> String or nil
          #   max_height(value) -> String
          #
          # Maximum height of the box.
          #
          # [value]
          #   <code>"100px"</code> or <code>"50%"</code>
          option :max_height, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Initializes a new Flex Message Box component.
          # The provided block is instance-eval'd, allowing DSL methods for adding
          # child components (e.g., +text+, +button+, nested +box+) to be called.
          #
          # [context]
          #   An optional context for the builder
          # [options]
          #   A hash of options to set instance variables.
          #   Corresponds to the +option+ definitions in this class and included modules
          # [block]
          #   A block to define the contents of this box
          def initialize(context: nil, **options, &)
            @contents = [] # Holds child components
            super # Calls Base#initialize, sets options, and evals block
          end

          # Adds a nested Flex Box component to this box's contents.
          #
          # [options]
          #   Options for the nested box (see Box)
          # [block]
          #   A block to define the contents of the nested box
          #
          # Returns the newly created nested Box object.
          def box(**options, &)
            @contents << Flex::Box.new(context: context, **options, &)
          end

          # Adds a Flex Text component to this box's contents.
          #
          # [text]
          #   The text content
          # [options]
          #   Options for the text component (see Text)
          # [block]
          #   An optional block for the text component. This can be used
          #   to define an action for the text or to add Span components within the text
          #
          # Returns the newly created Text object.
          #
          # == Example: Simple text component
          #
          #   text "Hello, World!"
          #
          # === Example: Text with an action
          #
          #   text "Click me" do
          #     message "Action", text: "You clicked me!"
          #   end
          #
          # === Example: Text with spans
          #
          #   text "This has " do
          #     span "styled", color: "#FF0000"
          #     span " parts"
          #   end
          def text(text = nil, **options, &)
            @contents << Flex::Text.new(text, context: context, **options, &)
          end

          # Adds a Flex Button component to this box's contents.
          #
          # [options]
          #   Options for the button component (see Button)
          # [block]
          #   A block to define the button's action and properties
          #
          # Returns the newly created Button object.
          def button(**options, &)
            @contents << Flex::Button.new(context: context, **options, &)
          end

          # Adds a Flex Image component to this box's contents.
          #
          # [url]
          #   The URL of the image
          # [options]
          #   Options for the image component (see Image)
          # [block]
          #   An optional block for the image component (e.g., for an action)
          #
          # Returns the newly created Image object.
          def image(url, **options, &)
            @contents << Flex::Image.new(url, context: context, **options, &)
          end

          # Adds a Flex Separator component to this box's contents.
          #
          # A separator is a simple component that draws a horizontal line,
          # creating a visual division between other components in a container.
          #
          # [options]
          #   Options for the separator component (see Separator)
          # [block]
          #   An optional block for advanced separator configuration
          #
          # Returns the newly created Separator object.
          def separator(**options, &)
            @contents << Flex::Separator.new(context: context, **options, &)
          end

          def to_h # :nodoc:
            raise RequiredError, "layout is required" if layout.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # :nodoc: # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "box",
              layout: layout,
              # Position & Layout
              justifyContent: justify_content,
              alignItems: align_items,
              spacing: spacing,
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
              # Size
              width: width,
              maxWidth: max_width,
              height: height,
              maxHeight: max_height,
              # Size::Flex
              flex: flex,
              # Contents & Action
              contents: contents.map(&:to_h),
              action: action&.to_h # From Actionable module
            }.compact
          end

          def to_sdkv2 # :nodoc: # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            {
              type: "box",
              layout: layout,
              # Position & Layout
              justify_content: justify_content,
              align_items: align_items,
              spacing: spacing,
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
              # Size
              width: width,
              max_width: max_width,
              height: height,
              max_height: max_height,
              # Size::Flex
              flex: flex,
              # Contents & Action
              contents: contents.map(&:to_h),
              action: action&.to_h # From Actionable module
            }.compact
          end
        end
      end
    end
  end
end
