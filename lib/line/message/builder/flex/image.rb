# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents an Image component in a Flex Message.
        # Images can be included in various parts of a Flex Message, such as the hero section of a bubble.
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#image
        class Image < Line::Message::Builder::Base
          include Actionable # Allows an action to be defined for the image
          # @!parse include Position::Horizontal
          # @!parse include Position::Vertical
          # @!parse include Position::Margin
          # @!parse include Position::Offset
          # @!parse include Size::Flex
          # @!parse include Size::Image
          include Position::Horizontal # For `align`
          include Position::Vertical   # For `gravity`
          include Position::Margin
          include Position::Offset
          include Size::Flex         # For `flex` factor
          include Size::Image        # For `size`, `aspect_ratio`, `aspect_mode`

          # @!attribute [r] url
          #   @return [String] The URL of the image. HTTPS is required.
          attr_reader :url

          # @!attribute aspect_ratio
          #   @return [String, nil] The aspect ratio of the image (e.g., "1:1", "20:13").
          #     Defaults to `nil`, meaning the original aspect ratio is used.
          #   @see https://developers.line.biz/en/reference/messaging-api/#image-aspectratio
          option :aspect_ratio, default: nil # This is also defined in Size::Image, but can be documented here for clarity
          # @!attribute aspect_mode
          #   @return [:cover, :fit, nil] The mode for adjusting the image to the aspect ratio.
          #     Defaults to `nil` (behaves like `:fit`).
          #   @see https://developers.line.biz/en/reference/messaging-api/#image-aspectmode
          option :aspect_mode, default: nil # Also in Size::Image

          # Initializes a new Image component.
          #
          # @param url [String] The URL of the image. Must use HTTPS.
          # @param context [Object, nil] The context for the image component.
          # @param options [Hash] Options for the image (e.g., aspect_ratio, size, action).
          # @param block [Proc, nil] An optional block for further configuration, typically for defining an action.
          def initialize(url, context: nil, **options, &)
            @url = url

            super(context: context, **options, &)
          end

          # Converts the Image component to its hash representation for the LINE API.
          #
          # @raise [RequiredError] if the `url` is not set.
          # @return [Hash] The hash representation of the image.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "url is required" if url.nil?

            {
              type: "image",
              url: url,
              # Position
              align: align,
              gravity: gravity,
              # Position::Margin
              margin: margin, # From Position::Margin
              # Position::Offset
              position: position,
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              # Size::Flex
              flex: flex, # From Size::Flex
              # Size::Image
              size: size,
              aspectRatio: aspect_ratio, # From self or Size::Image
              aspectMode: aspect_mode,
              action: action&.to_h # From Actionable
            }.compact
          end
        end
      end
    end
  end
end
