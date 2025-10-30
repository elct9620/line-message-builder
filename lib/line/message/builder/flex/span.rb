# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a span component in a LINE Flex Message.
        #
        # Span components are used within a Text component to apply different styling
        # to specific portions of text. They offer various styling options, including
        # +size+, +weight+, +color+, and +decoration+. Unlike Text components, spans
        # cannot have actions attached to them.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Span Example" do
        #       bubble do
        #         body do
        #           text do
        #             span "Hello, ", color: "#FF0000"
        #             span "Flex ", weight: :bold
        #             span "World!", size: :xl, decoration: :underline
        #           end
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#span
        # - Size::Shared for common size keywords (e.g., +:xl+, +:sm+)
        class Span < Line::Message::Builder::Base
          include Size::Shared # Adds `size` option (e.g., :sm, :md, :xl).

          # The actual text content to be displayed. This is a required attribute.
          attr_reader :text

          # :method: color
          # :call-seq:
          #   color() -> String or nil
          #   color(value) -> String
          #
          # Sets or gets the text color.
          #
          # [value]
          #   Hexadecimal color code (e.g., <code>"#RRGGBB"</code>, <code>"#RRGGBBAA"</code>)
          #
          # == Example
          #
          #   span "Hello", color: "#FF0000"
          option :color, default: nil

          # :method: weight
          # :call-seq:
          #   weight() -> Symbol, String, or nil
          #   weight(value) -> Symbol or String
          #
          # Sets or gets the text weight.
          #
          # [value]
          #   Text weight. Valid values are +:regular+ and +:bold+
          #
          # == Example
          #
          #   span "Bold text", weight: :bold
          option :weight, default: nil, validator: Validators::Enum.new(:regular, :bold)

          # :method: decoration
          # :call-seq:
          #   decoration() -> Symbol, String, or nil
          #   decoration(value) -> Symbol or String
          #
          # Sets or gets the text decoration.
          #
          # [value]
          #   Text decoration. Valid values are +:none+, +:underline+, and <code>:line-through</code>
          #
          # == Example
          #
          #   span "Underlined", decoration: :underline
          option :decoration, default: nil, validator: Validators::Enum.new(:none, :underline, :"line-through")

          # Initializes a new Flex Message Span component.
          #
          # [text_content]
          #   The text to display. This is required
          # [context]
          #   An optional context for the builder
          # [options]
          #   A hash of options to set instance variables (e.g., +:color+, +:weight+, +:decoration+, and options from included modules)
          # [block]
          #   An optional block, typically not used for spans
          #
          # == Example
          #
          #   span "Hello", color: "#FF0000", weight: :bold
          def initialize(text_content, context: nil, **options, &)
            @text = text_content # The text content is mandatory.

            super(context: context, **options, &) # Sets options and evals block
          end

          # Sets weight to bold.
          #
          # == Example
          #
          #   span "Bold text" do
          #     bold!
          #   end
          def bold!
            weight(:bold)
          end

          # Sets decoration to underline.
          #
          # == Example
          #
          #   span "Underlined text" do
          #     underline!
          #   end
          def underline!
            decoration(:underline)
          end

          # Sets decoration to line-through.
          #
          # == Example
          #
          #   span "Strikethrough text" do
          #     line_through!
          #   end
          def line_through!
            decoration(:"line-through")
          end

          def to_h # :nodoc:
            raise RequiredError, "text content is required for a span component" if text.nil?

            {
              type: "span",
              text: text,
              color: color,
              size: size,
              weight: weight,
              decoration: decoration
            }.compact
          end
        end
      end
    end
  end
end
