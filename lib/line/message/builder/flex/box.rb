# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The box is a component for the Flex message.
        class Box < Line::Message::Builder::Base
          option :layout, default: :horizontal

          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          def box(**options, &)
            @contents << Flex::Box.new(context: context, **options, &)
          end

          def text(text, **options, &)
            @contents << Flex::Text.new(text, context: context, **options, &)
          end

          def button(**options, &)
            @contents << Flex::Button.new(context: context, **options, &)
          end

          def to_h
            {
              type: "box",
              layout: @layout,
              contents: @contents.map(&:to_h)
            }.compact
          end
        end
      end
    end
  end
end
