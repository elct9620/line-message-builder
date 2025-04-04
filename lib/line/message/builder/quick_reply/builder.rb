# frozen_string_literal: true

module Line
  module Message
    class Builder
      module QuickReply
        # The Builder class is used to build quick reply buttons.
        class Builder < Line::Message::Builder::Base
          def initialize(context = nil, &)
            @items = []

            super
          end

          def message(text, label:, image_url: nil)
            action(
              {
                type: "message",
                label: label,
                text: text
              },
              image_url
            )
          end

          def postback(data:, label:, text: nil, image_url: nil)
            action(
              {
                type: "postback",
                label: label,
                data: data,
                text: text
              },
              image_url
            )
          end

          def to_h
            { items: @items.map(&:to_h) }
          end

          private

          def action(action, image_url)
            @items << {
              type: "action",
              imageUrl: image_url,
              action: action
            }.compact!
          end
        end
      end
    end
  end
end
