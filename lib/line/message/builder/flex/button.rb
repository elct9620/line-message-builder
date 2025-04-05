# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The button is a component of the Flex message.
        class Button < Line::Message::Builder::Base
          def initialize(style: :link, height: :md, context: nil, &)
            @action = nil
            @style = style
            @height = height

            super(context: context, &)
          end

          def message(text, label:, display_text: nil, &)
            @action = Actions::Message.new(text: text, label: label, display_text: display_text, &)
          end

          def postback(data, label: nil, display_text: nil, &)
            @action = Actions::Postback.new(data: data, label: label, display_text: display_text, &)
          end

          def to_h
            raise Error, "Action is required" unless @action

            {
              type: "button",
              action: @action.to_h,
              style: @style,
              height: @height
            }.compact
          end
        end
      end
    end
  end
end
