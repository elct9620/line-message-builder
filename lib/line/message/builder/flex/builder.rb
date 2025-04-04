# frozen_string_literal: true

module Line
  module Message
    class Builder
      module Flex
        # The Builder class is used to build quick reply buttons.
        class Builder < Line::Message::Builder::Base
          def initialize(context: nil, &)
            @root = nil

            super
          end

          def to_h
            @root&.to_h
          end
        end
      end
    end
  end
end
