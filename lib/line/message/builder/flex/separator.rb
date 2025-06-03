# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        class Separator < Line::Message::Builder::Base
          def to_h
            {
              type: "separator"
            }
          end
        end
      end
    end
  end
end
