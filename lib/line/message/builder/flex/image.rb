# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The image is a component for the Flex message.
        class Image < Line::Message::Builder::Base
          option :size, default: nil
          option :aspect_ratio, default: nil
          option :aspect_mode, default: nil

          def initialize(url, context: nil, **options, &)
            @url = url

            super(context: context, **options, &)
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
