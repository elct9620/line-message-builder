# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The bubble is container for the Flex message.
        class Bubble < Line::Message::Builder::Base
          def initialize(context: nil, &)
            @header = nil
            @hero = nil
            @body = nil
            @footer = nil

            super
          end

          def header(**options, &)
            @header = Box.new(**options, context: context, &)
          end

          def hero(**options, &)
            @hero = Box.new(**options, context: context, &)
          end

          def hero_image(url, **options, &)
            @hero = Image.new(url, **options, context: context, &)
          end

          def body(**options, &)
            @body = Box.new(**options, context: context, &)
          end

          def footer(**options, &)
            @footer = Box.new(**options, context: context, &)
          end

          def to_h
            {
              type: "bubble",
              header: @header&.to_h,
              hero: @hero&.to_h,
              body: @body&.to_h,
              footer: @footer&.to_h
            }.compact
          end
        end
      end
    end
  end
end
