# frozen_string_literal: true

module Line
  module Message
    class Builder
      module Actions
        # The Postback class is used to build postback actions for quick replies.
        class Postback < Line::Message::Builder::Base
          def initialize(data: nil, label: nil, display_text: nil, context: nil, &)
            @data = data
            @label = label
            @display_text = display_text

            super(context: context, &)
          end

          def label(label)
            @label = label
          end

          def data(data)
            @data = data
          end

          def display_text(display_text)
            @display_text = display_text
          end

          def to_h
            {
              type: "postback",
              label: @label,
              data: @data,
              displayText: @display_text
            }.compact
          end
        end
      end
    end
  end
end
