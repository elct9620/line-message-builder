# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The QuickReply allows to attach quick reply buttons to a message.
      class QuickReply < Line::Message::Builder::Base
        def initialize(context: nil, &)
          @items = []

          super
        end

        def message(text, label:, image_url: nil, &)
          action(
            Actions::Message.new(text: text, label: label, &).to_h,
            image_url
          )
        end

        def postback(data, label: nil, display_text: nil, image_url: nil, &)
          action(
            Actions::Postback.new(data: data, label: label, display_text: display_text, &).to_h,
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
          }.compact
        end
      end
    end
  end
end
