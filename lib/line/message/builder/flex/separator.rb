# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a separator component in a LINE Flex Message.
        #
        # Separator components are used to create a visual separation between components
        # within a container. They draw a horizontal line that helps organize the layout
        # and improve readability.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Separator Example" do
        #       bubble do
        #         body do
        #           text "Section 1"
        #           separator
        #           text "Section 2"
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#separator
        class Separator < Line::Message::Builder::Base
          # Converts the separator component to a hash representation compatible with
          # the LINE Messaging API.
          #
          # Returns a hash containing the separator component's type.
          #
          # == Example
          #
          #   separator = Separator.new
          #   separator.to_h
          #   # => { type: "separator" }
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
