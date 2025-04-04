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

          def to_h
            { items: @items.map(&:to_h) }
          end
        end
      end
    end
  end
end
