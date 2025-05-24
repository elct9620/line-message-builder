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
            Actions::Message.new(text, label: label, &),
            image_url
          )
        end

        def postback(data, label: nil, display_text: nil, image_url: nil, &)
          action(
            Actions::Postback.new(data, label: label, display_text: display_text, &),
            image_url
          )
        end

        def to_h
          return to_sdkv2 if context.sdkv2?

          to_api
        end

        private

        def to_api
          {
            items: @items.map do |item, image_url|
              {
                type: "action",
                imageUrl: image_url,
                action: item.to_h
              }
            end
          }
        end

        def to_sdkv2
          {
            items: @items.map do |item, image_url|
              {
                type: "action",
                image_url: image_url,
                action: item.to_h
              }
            end
          }
        end

        private

        def action(action, image_url)
          @items << [action, image_url]
        end
      end
    end
  end
end
