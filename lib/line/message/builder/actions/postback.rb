# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Actions
        # The Postback class is used to build postback actions for quick replies.
        class Postback < Line::Message::Builder::Base
          attr_reader :data

          option :label, default: nil
          option :display_text, default: nil

          def initialize(data, context: nil, **options, &)
            @data = data

            super(context: context, **options, &)
          end

          def to_h
            raise RequiredError, "data is required" if data.nil?

            {
              type: "postback",
              label: label,
              data: data,
              displayText: display_text
            }.compact
          end
        end
      end
    end
  end
end
