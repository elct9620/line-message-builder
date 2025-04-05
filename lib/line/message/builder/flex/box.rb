# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The box is a component for the Flex message.
        class Box < Line::Message::Builder::Base
          ALLOWED_LAYOUTS = %i[horizontal vertical baseline].freeze

          def initialize(layout: :horizontal, context: nil, &)
            raise ArgumentError, "Invalid layout" unless ALLOWED_LAYOUTS.include?(layout)

            @layout = layout
            @contents = []

            super(context: context, &)
          end

          def box(**options, &)
            @contents << Flex::Box.new(**options, context: context, &)
          end

          def text(text, **options, &)
            @contents << Flex::Text.new(text, **options, context: context, &)
          end

          def button(**options, &)
            @contents << Flex::Button.new(**options, context: context, &)
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
