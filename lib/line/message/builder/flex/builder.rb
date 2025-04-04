# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Builder class is used to build quick reply buttons.
        class Builder < Line::Message::Builder::Base
          option :alt_text, default: nil

          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          def bubble(&)
            @contents << Line::Message::Builder::Flex::Bubble.new(context: context, &)
          end

          def to_h
            {
              type: "flex",
              altText: @alt_text,
              contents: @contents.map(&:to_h),
              quickReply: @quick_reply&.to_h
            }.compact
          end
        end
      end
    end
  end
end
