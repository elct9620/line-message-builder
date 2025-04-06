# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # The Message class is used to build message actions for quick replies.
        class Message < Line::Message::Builder::Base
          attr_reader :text

          option :label, default: nil

          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          def to_h
            raise RequiredError, "text is required" if text.nil?

            {
              type: "message",
              label: label,
              text: text
            }.compact
          end
        end
      end
    end
  end
end
