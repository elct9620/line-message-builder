# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The carousel is multiple bubbles in a single Flex message.
        class Carousel < Line::Message::Builder::Base
          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          def bubble(**options, &)
            @contents << Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          def to_h
            raise RequiredError, "contents should have at least 1 bubble" if @contents.empty?
            raise ValidationError, "contents should have at most 12 bubbles" if @contents.size > 12

            {
              type: "carousel",
              contents: @contents.map(&:to_h)
            }.compact
          end
        end
      end
    end
  end
end
