# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents an "image" component in a LINE Flex Message.
        #
        # Images are specified by a URL and can be included in various parts of a
        # Flex Message, such as a box, a bubble's hero section, etc. They offer
        # several properties to control their appearance, including `size`,
        # `aspect_ratio`, and `aspect_mode`. An image can also have an
        # {Actionable#action action} to make it tappable.
        #
        # @example Creating an image component within a box
        #   Line::Message::Builder.with do |root|
        #     root.flex alt_text: "Image Example" do |flex|
        #       flex.bubble do |bubble|
        #         bubble.body do |body_box|
        #           body_box.image "https://example.com/image.png",
        #                          aspect_ratio: "16:9",
        #                          aspect_mode: :cover,
        #                          size: :full do |img_action|
        #             img_action.message "View Details", text: "Show details for image"
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#image
        # @see Actionable For making the image tappable.
        # @see Position::Horizontal For `align` property.
        # @see Position::Vertical For `gravity` property.
        # @see Position::Margin For `margin` property.
        # @see Position::Offset For offset properties.
        # @see Size::Flex For `flex` sizing property.
        # @see Size::Image For `size` (image specific keywords), `aspect_ratio`, `aspect_mode`.
        class Image < Line::Message::Builder::Base
          include Actionable           # Enables defining an action for the image.
          include Position::Horizontal # Adds `align` option for horizontal alignment.
          include Position::Vertical   # Adds `gravity` option for vertical alignment.
          include Position::Margin     # Adds `margin` option.
          include Position::Offset     # Adds offset options.
          include Size::Flex           # Adds `flex` option for sizing within a parent box.
          include Size::Image          # Adds image-specific sizing options like `size`, `aspect_ratio`, `aspect_mode`.

          # @!attribute [r] url
          #   @return [String] The URL of the image. Must be HTTPS.
          #     This is a required attribute.
          attr_reader :url

          # Specifies the aspect ratio of the image (width:height).
          # E.g., "1:1", "16:9", "20:13". Default is "1:1".
          # @!method aspect_ratio(value)
          #   @param value [String, nil] The aspect ratio string.
          #   @return [String, nil] The current aspect ratio.
          option :aspect_ratio, default: nil

          # Specifies how the image should be displayed within the area defined by `aspect_ratio`.
          # @!method aspect_mode(value)
          #   @param value [Symbol, String, nil] Aspect mode. Can be `:cover` (default)
          #     or `:fit`.
          #   @return [Symbol, String, nil] The current aspect mode.
          option :aspect_mode, default: nil # :cover, :fit

          # Initializes a new Flex Message Image component.
          #
          # @param url [String] The HTTPS URL of the image. This is required.
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables
          #   (e.g., `:aspect_ratio`, `:aspect_mode`, `:size`, and options from included modules).
          # @param block [Proc, nil] An optional block, typically used to define an
          #   {Actionable#action action} for the image.
          # @raise [ArgumentError] if `url` is nil (though the more specific `RequiredError`
          #   is raised in `to_h`).
          def initialize(url, context: nil, **options, &)
            @url = url # The image URL is mandatory.

            super(context: context, **options, &) # Sets options and evals block (for action).
          end

          # Converts the Image component and its properties to a hash suitable for
          # the LINE Messaging API.
          #
          # @return [Hash] A hash representing the image component.
          # @raise [RequiredError] if `url` is not set.
          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "url is required for an image component" if url.nil?

            {
              type: "image",
              url: url,
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
              # Size::Image (includes aspect_ratio, aspect_mode, and specific image size keywords)
              size: size,
              aspectRatio: aspect_ratio, # From option
              aspectMode: aspect_mode,   # From option
              # Actionable
              action: action&.to_h # From Actionable module
            }.compact
          end
        end
      end
    end
  end
end
