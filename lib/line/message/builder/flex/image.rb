# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents an "image" component in a LINE Flex Message.
        #
        # Images are specified by a URL and can be included in various parts of a
        # Flex Message, such as a box, a bubble's hero section, etc. They offer
        # several properties to control their appearance, including +size+,
        # +aspect_ratio+, and +aspect_mode+. An image can also have an
        # action to make it tappable.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Image Example" do
        #       bubble do
        #         body do
        #           image "https://example.com/image.png",
        #                 aspect_ratio: "16:9",
        #                 aspect_mode: :cover,
        #                 size: :full
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#image
        # - Actionable for making the image tappable
        # - Position::Horizontal for +align+ property
        # - Position::Vertical for +gravity+ property
        # - Position::Margin for +margin+ property
        # - Position::Offset for offset properties
        # - Size::Flex for +flex+ sizing property
        # - Size::Image for +size+, +aspect_ratio+, and +aspect_mode+ properties
        class Image < Line::Message::Builder::Base
          include Actionable           # Enables defining an action for the image.
          include Position::Horizontal # Adds `align` option for horizontal alignment.
          include Position::Vertical   # Adds `gravity` option for vertical alignment.
          include Position::Margin     # Adds `margin` option.
          include Position::Offset     # Adds offset options.
          include Size::Flex           # Adds `flex` option for sizing within a parent box.
          include Size::Image          # Adds image-specific sizing options like `size`, `aspect_ratio`, `aspect_mode`.

          # The URL of the image (must be HTTPS). This is a required attribute.
          attr_reader :url

          # :method: aspect_ratio
          # :call-seq:
          #   aspect_ratio() -> String or nil
          #   aspect_ratio(value) -> String
          #
          # Sets or gets the aspect ratio of the image (width:height).
          #
          # [value]
          #   The aspect ratio string (e.g., <code>"1:1"</code>, <code>"16:9"</code>,
          #   <code>"20:13"</code>). Default is <code>"1:1"</code>.
          option :aspect_ratio, default: nil

          # :method: aspect_mode
          # :call-seq:
          #   aspect_mode() -> Symbol or nil
          #   aspect_mode(value) -> Symbol
          #
          # Sets or gets how the image should be displayed within the area defined by +aspect_ratio+.
          #
          # [value]
          #   The aspect mode (can be +:cover+ (default) or +:fit+)
          option :aspect_mode, default: nil # :cover, :fit

          # Initializes a new Flex Message Image component.
          #
          # [url]
          #   The HTTPS URL of the image (required)
          # [context]
          #   An optional context for the builder (default: +nil+)
          # [options]
          #   A hash of options to set instance variables (e.g., +:aspect_ratio+,
          #   +:aspect_mode+, +:size+, and options from included modules)
          # [block]
          #   An optional block, typically used to define an action for the image
          #
          # Raises RequiredError if +url+ is +nil+ when building the message.
          #
          # == Example
          #
          #   image = Line::Message::Builder::Flex::Image.new(
          #     "https://example.com/image.png",
          #     aspect_ratio: "16:9",
          #     aspect_mode: :cover
          #   )
          def initialize(url, context: nil, **options, &)
            @url = url # The image URL is mandatory.

            super(context: context, **options, &) # Sets options and evals block (for action).
          end

          private

          # :nodoc:
          def to_api # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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

          # :nodoc:
          def to_sdkv2 # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
              offset_top: offset_top,
              offset_bottom: offset_bottom,
              offset_start: offset_start,
              offset_end: offset_end,
              # Size::Flex
              flex: flex,
              # Size::Image (includes aspect_ratio, aspect_mode, and specific image size keywords)
              size: size,
              aspect_ratio: aspect_ratio, # From option
              aspect_mode: aspect_mode,   # From option
              # Actionable
              action: action&.to_h # From Actionable module
            }.compact
          end
        end
      end
    end
  end
end
