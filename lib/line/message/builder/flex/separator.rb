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
        # === Example: Spacing and tinting the line
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Separator Example" do
        #       bubble do
        #         body do
        #           text "Section 1"
        #           separator margin: :xl, color: "#F0F0F0"
        #           text "Section 2"
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#separator
        # - Position::Margin for the +margin+ property
        class Separator < Line::Message::Builder::Base
          include Position::Margin # Adds `margin` option.

          # :method: color
          # :call-seq:
          #   color() -> String or nil
          #   color(value) -> String
          #
          # Sets or gets the color of the separator line.
          #
          # [value]
          #   Hexadecimal color code (e.g., <code>"#RRGGBB"</code>)
          option :color, default: nil

          # Converts the separator component to a hash representation compatible with
          # the LINE Messaging API.
          #
          # The +margin+ and +color+ properties share the same name in both the API
          # and SDK v2 formats, so a single representation serves both.
          #
          # Returns a hash containing the separator component's type and any set
          # properties.
          #
          # == Example
          #
          #   separator = Separator.new(margin: :md)
          #   separator.to_h
          #   # => { type: "separator", margin: :md }
          def to_h
            {
              type: "separator",
              # Position::Margin
              margin: margin,
              color: color # From option
            }.compact
          end
        end
      end
    end
  end
end
