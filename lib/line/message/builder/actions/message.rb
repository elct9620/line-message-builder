# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # The Message class is used to build message actions for quick replies.
        class Message < Line::Message::Builder::Base
          def initialize(text, label: nil, context: nil, &)
            @text = text
            @label = label

            super(context: context, &)
          end

          def label(label)
            @label = label
          end

          def text(text)
            @text = text
          end

          def to_h
            {
              type: "message",
              label: @label,
              text: @text
            }.compact
          end
        end
      end
    end
  end
end
