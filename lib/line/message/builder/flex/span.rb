# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "span" component in a LINE Flex Message.
        #
        # Span components are used within a Text component to apply different styling
        # to specific portions of text. They offer various styling options, including 
        # `size`, `weight`, `color`, and `decoration`. Unlike Text components, spans
        # cannot have actions attached to them.
        #
        # @example Creating a text component with spans
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
        # @see https://developers.line.biz/en/reference/messaging-api/#span
        # @see Size::Shared For common `size` keywords (e.g., `:xl`, `:sm`).
        class Span < Line::Message::Builder::Base
          include Size::Shared # Adds `size` option (e.g., :sm, :md, :xl).

          # @!attribute [r] text
          #   @return [String] The actual text content to be displayed.
          #     This is a required attribute.
          attr_reader :text

          # Specifies the color of the text.
          # @!method color(value)
          #   @param value [String, nil] Hexadecimal color code (e.g., `"#RRGGBB"`, `"#RRGGBBAA"`).
          #   @return [String, nil] The current text color.
          option :color, default: nil

          # Specifies the weight of the text.
          # @!method weight(value)
          #   @param value [Symbol, String, nil] Text weight. Valid values are `:regular` and `:bold`.
          #   @return [Symbol, String, nil] The current text weight.
          option :weight, default: nil, validator: ->(v) { Validators::Enum.new(:regular, :bold).valid!(v) }

          # Specifies the decoration of the text.
          # @!method decoration(value)
          #   @param value [Symbol, String, nil] Text decoration. 
          #     Valid values are `:none`, `:underline`, and `:line-through`.
          #   @return [Symbol, String, nil] The current text decoration.
          option :decoration, default: nil, validator: ->
            (v) { Validators::Enum.new(:none, :underline, :"line-through").valid!(v) }

          # Initializes a new Flex Message Span component.
          #
          # @param text_content [String] The text to display. This is required.
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options to set instance variables
          #   (e.g., `:color`, `:weight`, `:decoration`, and options from included modules).
          # @param block [Proc, nil] An optional block, typically not used for spans.
          # @raise [ArgumentError] if `text_content` is nil (though the more specific
          #   `RequiredError` is raised in `to_h`).
          def initialize(text_content, context: nil, **options, &)
            @text = text_content # The text content is mandatory.

            super(context: context, **options, &) # Sets options and evals block
          end

          # Sets weight to bold.
          #
          # @return [Symbol] Returns `:bold`.
          def bold!
            weight(:bold)
          end

          # Sets decoration to underline.
          #
          # @return [Symbol] Returns `:underline`.
          def underline!
            decoration(:underline)
          end

          # Sets decoration to line-through.
          #
          # @return [Symbol] Returns `:line-through`.
          def line_through!
            decoration(:"line-through")
          end

          def to_h
            raise RequiredError, "text content is required for a span component" if text.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api
            {
              type: "span",
              text: text,
              color: color,
              size: size,
              weight: weight,
              decoration: decoration
            }.compact
          end

          def to_sdkv2
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
