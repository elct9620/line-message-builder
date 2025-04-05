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

          def header(&)
            @header = Box.new(context: context, &)
          end

          def body(&)
            @body = Box.new(context: context, &)
          end

          def footer(&)
            @footer = Box.new(context: context, &)
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
