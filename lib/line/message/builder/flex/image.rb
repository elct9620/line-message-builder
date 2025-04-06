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

          attr_reader :url

          option :size, default: nil
          option :aspect_ratio, default: nil
          option :aspect_mode, default: nil
          option :flex, default: nil
          option :margin, default: nil

          def initialize(url, context: nil, **options, &)
            @url = url

            super(context: context, **options, &)
          end

          def to_h # rubocop:disable Metrics/MethodLength
            raise RequiredError, "url is required" if url.nil?

            {
              type: "image",
              url: url,
              # Position
              align: align,
              gravity: gravity,
              size: size,
              flex: flex,
              margin: margin,
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
