# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents an "icon" component in a LINE Flex Message.
        #
        # Icons render a small image that decorates the text next to them. They are
        # the standard way to build rating stars, labelled metadata rows, and other
        # icon-and-text pairs.
        #
        # An icon can only be placed in a box whose +layout+ is +:baseline+. Unlike
        # Image, an icon cannot have an action attached to it.
        #
        # == Example: Rating stars beside a score
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Review" do
        #       bubble do
        #         body do
        #           box layout: :baseline do
        #             icon "https://example.com/star_on.png", size: :sm
        #             icon "https://example.com/star_on.png", size: :sm
        #             icon "https://example.com/star_off.png", size: :sm
        #             text "3.0", size: :sm, margin: :md
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # === Example: Following the reader's font size
        #
        #   box layout: :baseline do
        #     icon "https://example.com/pin.png", scaling: true
        #     text "Taipei", scaling: true
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#icon
        # - Position::Margin for +margin+ property
        # - Position::Offset for offset properties
        # - Size::Shared for common +size+ keywords (e.g., +:sm+, +:xl+)
        class Icon < Line::Message::Builder::Base
          include Position::Margin # Adds `margin` option.
          include Position::Offset # Adds offset options.
          include Size::Shared     # Adds `size` option (e.g., :sm, :md, :xl).

          # The URL of the icon image (must be HTTPS). This is a required attribute.
          attr_reader :url

          # :method: aspect_ratio
          # :call-seq:
          #   aspect_ratio() -> String or nil
          #   aspect_ratio(value) -> String
          #
          # Sets or gets the aspect ratio of the icon (width:height).
          #
          # [value]
          #   The aspect ratio string (e.g., <code>"1:1"</code>, <code>"2:1"</code>).
          #   Default is <code>"1:1"</code>
          option :aspect_ratio, default: nil # API key: aspectRatio

          # :method: scaling
          # :call-seq:
          #   scaling() -> Boolean or nil
          #   scaling(value) -> Boolean
          #
          # Sets or gets whether the icon size follows the font size setting of the
          # LINE app.
          #
          # [value]
          #   +true+ to scale the icon, +false+ (default) to keep it fixed
          option :scaling, default: nil

          # Initializes a new Flex Message Icon component.
          #
          # [url]
          #   The HTTPS URL of the icon image (required)
          # [context]
          #   An optional context for the builder (default: +nil+)
          # [options]
          #   A hash of options to set instance variables (e.g., +:size+,
          #   +:aspect_ratio+, and options from included modules)
          # [block]
          #   An optional block for further configuration
          #
          # Raises RequiredError if +url+ is +nil+ when building the message.
          #
          # == Example
          #
          #   Line::Message::Builder::Flex::Icon.new(
          #     "https://example.com/star.png",
          #     size: :sm
          #   )
          def initialize(url, context: nil, **options, &)
            @url = url # The icon URL is mandatory.

            super(context: context, **options, &)
          end

          private

          # :nodoc:
          def to_api # rubocop:disable Metrics/MethodLength
            raise RequiredError, "url is required for an icon component" if url.nil?

            {
              type: "icon",
              url: url,
              # Position::Margin
              margin: margin,
              # Position::Offset
              position: position,
              offsetTop: offset_top,
              offsetBottom: offset_bottom,
              offsetStart: offset_start,
              offsetEnd: offset_end,
              # Size::Shared
              size: size,
              aspectRatio: aspect_ratio, # From option (maps to API key)
              scaling: scaling # From option
            }.compact
          end

          # :nodoc:
          def to_sdkv2 # rubocop:disable Metrics/MethodLength
            raise RequiredError, "url is required for an icon component" if url.nil?

            {
              type: "icon",
              url: url,
              # Position::Margin
              margin: margin,
              # Position::Offset
              position: position,
              offset_top: offset_top,
              offset_bottom: offset_bottom,
              offset_start: offset_start,
              offset_end: offset_end,
              # Size::Shared
              size: size,
              aspect_ratio: aspect_ratio, # From option (maps to API key)
              scaling: scaling # From option
            }.compact
          end
        end
      end
    end
  end
end
