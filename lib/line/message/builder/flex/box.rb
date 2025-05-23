# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a Box component in a Flex Message.
        # Boxes are containers that arrange their child components (other boxes, text, images, etc.)
        # in a specified layout (horizontal, vertical, or baseline).
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#box
        # @see https://developers.line.biz/en/reference/messaging-api/#box-layout
        class Box < Line::Message::Builder::Base
          include HasPartial
          include Actionable
          # @!parse include Position::Padding
          # @!parse include Position::Margin
          # @!parse include Position::Offset
          # @!parse include Size::Flex
          include Position::Padding
          include Position::Margin
          include Position::Offset
          include Size::Flex

          # @!attribute [r] contents
          #   @return [Array<Line::Message::Builder::Base>] An array of components within this box.
          attr_reader :contents

          # @!attribute layout
          #   @return [:horizontal, :vertical, :baseline] The arrangement of child components.
          #     Defaults to `:horizontal`.
          #   @see https://developers.line.biz/en/reference/messaging-api/#box-layout
          option :layout, default: :horizontal, validator: Validators::Enum.new(
            :horizontal, :vertical, :baseline
          )
          # @!attribute justify_content
          #   @return [:flex_start, :center, :flex_end, :space_between, :space_around, :space_evenly, nil]
          #     Horizontal alignment of components and inter-component spacing.
          #   @see https://developers.line.biz/en/reference/messaging-api/#box-justifycontent
          option :justify_content, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end, :space_between, :space_around, :space_evenly
          )
          # @!attribute align_items
          #   @return [:flex_start, :center, :flex_end, nil] Vertical alignment of components.
          #   @see https://developers.line.biz/en/reference/messaging-api/#box-alignitems
          option :align_items, default: nil, validator: Validators::Enum.new(
            :flex_start, :center, :flex_end
          )
          # @!attribute spacing
          #   @return [String, nil] The minimum space between components. (e.g., "md", "10px").
          #   @see https://developers.line.biz/en/reference/messaging-api/#box-spacing
          option :spacing, default: nil, validator: Validators::Size.new(:pixel, :keyword)
          # @!attribute width
          #   @return [String, nil] The width of the box (e.g., "100px", "50%").
          #   @see https://developers.line.biz/en/reference/messaging-api/#component-width-height
          option :width, default: nil, validator: Validators::Size.new(:pixel, :percentage)
          # @!attribute max_width
          #   @return [String, nil] The maximum width of the box.
          option :max_width, default: nil, validator: Validators::Size.new(:pixel, :percentage)
          # @!attribute height
          #   @return [String, nil] The height of the box.
          option :height, default: nil, validator: Validators::Size.new(:pixel, :percentage)
          # @!attribute max_height
          #   @return [String, nil] The maximum height of the box.
          option :max_height, default: nil, validator: Validators::Size.new(:pixel, :percentage)

          # Initializes a new Box component.
          #
          # @param context [Object, nil] The context for the component.
          # @param options [Hash] Options for the box (e.g., layout, spacing, width).
          # @param block [Proc, nil] A block to define the contents of the box using the DSL.
          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          # Adds a nested Box component to this box's contents.
          #
          # @param options [Hash] Options for the nested box.
          # @param block [Proc] A block to define the contents of the nested box.
          # @return [Flex::Box] The created nested Box component.
          def box(**options, &)
            @contents << Flex::Box.new(context: context, **options, &)
          end

          # Adds a Text component to this box's contents.
          #
          # @param text [String] The text content.
          # @param options [Hash] Options for the text component.
          # @param block [Proc, nil] An optional block for further configuration.
          # @return [Flex::Text] The created Text component.
          def text(text, **options, &)
            @contents << Flex::Text.new(text, context: context, **options, &)
          end

          # Adds a Button component to this box's contents.
          #
          # @param options [Hash] Options for the button component.
          # @param block [Proc] A block to define the button's properties (e.g., action).
          # @return [Flex::Button] The created Button component.
          def button(**options, &)
            @contents << Flex::Button.new(context: context, **options, &)
          end

          # Adds an Image component to this box's contents.
          #
          # @param url [String] The URL of the image.
          # @param options [Hash] Options for the image component.
          # @param block [Proc, nil] An optional block for further configuration.
          # @return [Flex::Image] The created Image component.
          def image(url, **options, &)
            @contents << Flex::Image.new(url, context: context, **options, &)
          end

          # Converts the Box component to its hash representation for the LINE API.
          #
          # @raise [RequiredError] if layout is not set.
          # @return [Hash] The hash representation of the box.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "layout is required" if layout.nil?

            {
              type: "box",
              layout: layout.to_s, # Ensure layout is a string
              # Position
              justifyContent: justify_content&.to_s, # Ensure enum values are strings
              alignItems: align_items&.to_s, # Ensure enum values are strings
              spacing: spacing,
              # Position::Padding
              paddingAll: padding_all, # Use the method defined in Position::Padding
              paddingTop: padding_top,
              paddingBottom: padding_bottom,
              paddingStart: padding_start,
              paddingEnd: padding_end,
              # Position::Margin
              margin: margin, # This comes from Position::Margin
              # Position::Offset
              position: position&.to_s, # Ensure enum values are strings
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              # Size
              width: width, # This comes from self
              maxWidth: max_width, # This comes from self
              height: height, # This comes from self
              maxHeight: max_height, # This comes from self
              # Size::Flex
              flex: flex, # This comes from Size::Flex
              contents: contents.map(&:to_h),
              action: action&.to_h
            }.compact
          end
        end
      end
    end
  end
end
