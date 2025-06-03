# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "separator" component in a LINE Flex Message.
        #
        # Separator components are used to create a visual separation between components
        # within a container. They draw a horizontal line that helps organize the layout
        # and improve readability.
        #
        # @example Creating a separator within a box
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
        # @see https://developers.line.biz/en/reference/messaging-api/#separator
        class Separator < Line::Message::Builder::Base
          # Converts the separator component to a hash representation compatible with
          # the LINE Messaging API.
          #
          # @return [Hash] A hash containing the separator component's type.
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
