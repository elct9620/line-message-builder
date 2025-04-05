# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The image is a component for the Flex message.
        class Image < Line::Message::Builder::Base
          def initialize(url, size: nil, aspect_ratio: nil, aspect_mode: nil, context: nil, &)
            @url = url
            @size = size
            @aspect_ratio = aspect_ratio
            @aspect_mode = aspect_mode

            super(context: context, &)
          end

          def size(size)
            @size = size
          end

          def aspect_ratio(aspect_ratio)
            @aspect_ratio = aspect_ratio
          end

          def aspect_mode(aspect_mode)
            @aspect_mode = aspect_mode
          end

          def to_h
            {
              type: "image",
              url: @url,
              size: @size,
              aspectRatio: @aspect_ratio,
              aspectMode: @aspect_mode
            }.compact
          end
        end
      end
    end
  end
end
