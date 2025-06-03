# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "box" component in a LINE Flex Message.
        #
        # A box is a fundamental layout container that arranges its child components
        # (`contents`) in a specified direction (`layout`: horizontal, vertical, or
        # baseline). It can hold various other components like text, images, buttons,
        # or even nested boxes, allowing for complex layouts.
        #
        # Boxes have numerous properties to control their appearance and the
        # arrangement of their children, such as padding, margin, spacing between
        # items, justification, and alignment.
        #
        # A box can also have an `action` associated with it, making the entire
        # box area tappable.
        #
        # @example Creating a horizontal box with two text components
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
        # @see https://developers.line.biz/en/reference/messaging-api/#box
        # @see Actionable For making the box tappable.
        # @see HasPartial For including reusable component groups.
        # @see Position::Padding For padding properties.
        # @see Position::Margin For margin properties.
        # @see Position::Offset For offset properties.
        # @see Size::Flex For flex sizing property.
        class Box < Line::Message::Builder::Base
          include HasPartial # Allows including predefined partial component sets.
          include Actionable # Enables defining an action for the entire box.
          include Position::Padding  # Adds padding options like `padding_all`, `padding_top`, etc.
          include Position::Margin   # Adds `margin` option.
          include Position::Offset   # Adds offset options like `offset_top`, `offset_start`, etc.
          include Size::Flex         # Adds `flex` option for controlling size within a parent box.

          # @!attribute [r] contents
          #   @return [Array<Base>] An array holding the child components (e.g.,
          #     {Text}, {Image}, nested {Box} instances) of this box.
          attr_reader :contents

          # Specifies the arrangement of child components.
          # @!method layout(value)
          #   @param value [Symbol] `:horizontal` (default), `:vertical`, or `:baseline`.
          #   @return [Symbol] The current layout.
          option :layout, default: :horizontal, validator: Validators::Enum.new(
            :horizontal, :vertical, :baseline
          )

          # Horizontal alignment of content in a horizontal box; vertical alignment in a vertical box.
          # @!method justify_content(value)
          #   @param value [Symbol, nil] E.g., `:flex_start`, `:center`, `:flex_end`,
          #     `:space_between`, `:space_around`, `:space_evenly`.
          #   @return [Symbol, nil] The current justify_content value.
          option :justify_content, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end, :space_between, :space_around, :space_evenly
          )

          # Vertical alignment of content in a horizontal box; horizontal alignment in a vertical box.
          # @!method align_items(value)
          #   @param value [Symbol, nil] E.g., `:flex_start`, `:center`, `:flex_end`.
          #   @return [Symbol, nil] The current align_items value.
          option :align_items, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end
          )

          # Specifies the minimum spacing between components.
          # Not applicable if `layout` is `:baseline` or if the box contains only one component.
          # @!method spacing(value)
          #   @param value [String, Symbol, nil] E.g., `"md"`, `:lg`, `"10px"`.
          #     Keywords: `:none`, `:xs`, `:sm`, `:md`, `:lg`, `:xl`, `:xxl`.
          #   @return [String, Symbol, nil] The current spacing value.
          option :spacing, default: nil, validator: Validators::Size.new(:pixel, :keyword)

          # Width of the box. Can be a percentage or pixel value.
          # @!method width(value)
          #   @param value [String, nil] E.g., `"100px"`, `"50%"`.
          #   @return [String, nil] The current width.
          option :width, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Maximum width of the box.
          # @!method max_width(value)
          #   @param value [String, nil] E.g., `"100px"`, `"50%"`.
          #   @return [String, nil] The current maximum width.
          option :max_width, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Height of the box.
          # @!method height(value)
          #   @param value [String, nil] E.g., `"100px"`, `"50%"`.
          #   @return [String, nil] The current height.
          option :height, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Maximum height of the box.
          # @!method max_height(value)
          #   @param value [String, nil] E.g., `"100px"`, `"50%"`.
          #   @return [String, nil] The current maximum height.
          option :max_height, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Initializes a new Flex Message Box component.
          # The provided block is instance-eval'd, allowing DSL methods for adding
          # child components (e.g., {#text}, {#button}, nested {#box}) to be called.
          #
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables.
          #   Corresponds to the `option` definitions in this class and included modules.
          # @param block [Proc, nil] A block to define the contents of this box.
          def initialize(context: nil, **options, &)
            @contents = [] # Holds child components
            super # Calls Base#initialize, sets options, and evals block
          end

          # Adds a nested Flex {Box} component to this box's contents.
          #
          # @param options [Hash] Options for the nested box. See {Box#initialize}.
          # @param block [Proc] A block to define the contents of the nested box.
          # @return [Flex::Box] The newly created nested Box object.
          def box(**options, &)
            @contents << Flex::Box.new(context: context, **options, &)
          end

          # Adds a Flex {Text} component to this box's contents.
          #
          # @param text [String] The text content.
          # @param options [Hash] Options for the text component. See {Text#initialize}.
          # @param block [Proc, nil] An optional block for the text component (e.g., for an action).
          # @return [Flex::Text] The newly created Text object.
          def text(text, **options, &)
            @contents << Flex::Text.new(text, context: context, **options, &)
          end

          # Adds a Flex {Button} component to this box's contents.
          #
          # @param options [Hash] Options for the button component. See {Button#initialize}.
          # @param block [Proc] A block to define the button's action and properties.
          # @return [Flex::Button] The newly created Button object.
          def button(**options, &)
            @contents << Flex::Button.new(context: context, **options, &)
          end

          # Adds a Flex {Image} component to this box's contents.
          #
          # @param url [String] The URL of the image.
          # @param options [Hash] Options for the image component. See {Image#initialize}.
          # @param block [Proc, nil] An optional block for the image component (e.g., for an action).
          # @return [Flex::Image] The newly created Image object.
          def image(url, **options, &)
            @contents << Flex::Image.new(url, context: context, **options, &)
          end

          # Adds a Flex {Separator} component to this box's contents.
          #
          # A separator is a simple component that draws a horizontal line,
          # creating a visual division between other components in a container.
          #
          # @param options [Hash] Options for the separator component. See {Separator}.
          # @param block [Proc, nil] An optional block for advanced separator configuration.
          # @return [Flex::Separator] The newly created Separator object.
          def separator(**options, &)
            @contents << Flex::Separator.new(context: context, **options, &)
          end

          def to_h
            raise RequiredError, "layout is required" if layout.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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

          def to_sdkv2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
