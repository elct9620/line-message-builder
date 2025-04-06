# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The button is a component of the Flex message.
        class Button < Line::Message::Builder::Base
          include Actionable
          include Position::Vertical

          option :flex, default: nil
          option :margin, default: nil
          option :style, default: :link
          option :height, default: :md

          def to_h
            raise RequiredError, "action is required" if action.nil?

            {
              type: "button",
              action: action.to_h,
              # Position
              grivity: gravity,
              flex: flex,
              margin: margin,
              style: style,
              height: height
            }.compact
          end
        end
      end
    end
  end
end
