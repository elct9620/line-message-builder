# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The button is a component of the Flex message.
        class Button < Line::Message::Builder::Base
          attr_reader :action

          option :flex, default: nil
          option :margin, default: nil
          option :style, default: :link
          option :height, default: :md

          def initialize(context: nil, **options, &)
            @action = nil

            super
          end

          def message(text, label:, display_text: nil, &)
            @action = Actions::Message.new(text, label: label, display_text: display_text, &)
          end

          def postback(data, label: nil, display_text: nil, &)
            @action = Actions::Postback.new(data, label: label, display_text: display_text, &)
          end

          def to_h
            raise RequiredError, "action is required" if action.nil?

            {
              type: "button",
              action: action.to_h,
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
