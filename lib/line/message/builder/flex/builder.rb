# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Builder class is used to build quick reply buttons.
        class Builder < Line::Message::Builder::Base
          option :alt_text, default: nil

          def initialize(context: nil, **options, &)
            @contents = nil

            super
          end

          def bubble(**options, &)
            @contents = Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          def carousel(**options, &)
            @contents = Line::Message::Builder::Flex::Carousel.new(context: context, **options, &)
          end

          def to_h
            raise Error, "contents should be bubble or carousel" if @contents.nil?

            {
              type: "flex",
              altText: @alt_text,
              contents: @contents.to_h,
              quickReply: @quick_reply&.to_h
            }.compact
          end
        end
      end
    end
  end
end
