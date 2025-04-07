# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The image is a component for the Flex message.
        class Image < Line::Message::Builder::Base
          include Actionable
          include Position::Horizontal
          include Position::Vertical
          include Position::Margin
          include Position::Offset
          include Size::Flex

          attr_reader :url

          option :size, default: nil
          option :aspect_ratio, default: nil
          option :aspect_mode, default: nil

          def initialize(url, context: nil, **options, &)
            @url = url

            super(context: context, **options, &)
          end

          def to_h # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
            raise RequiredError, "url is required" if url.nil?

            {
              type: "image",
              url: url,
              # Position
              align: align,
              gravity: gravity,
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
              size: size,
              aspectRatio: aspect_ratio,
              aspectMode: aspect_mode,
              action: action&.to_h
            }.compact
          end
        end
      end
    end
  end
end
