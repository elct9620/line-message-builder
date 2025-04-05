# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The Builder class is used to build quick reply buttons.
        class Builder < Line::Message::Builder::Base
          def initialize(alt_text: nil, context: nil, &)
            @alt_text = alt_text
            @contents = []

            super(context: context, &)
          end

          def to_h
            {
              type: "flex",
              altText: @alt_text,
              contents: @contents.map(&:to_h)
            }.compact
          end
        end
      end
    end
  end
end
