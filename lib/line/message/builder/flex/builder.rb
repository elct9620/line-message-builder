# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The +Builder+ class is the main entry point for constructing a complete
        # LINE Flex Message. A Flex Message is a highly customizable message type
        # that can contain one main content element, which is either a single
        # Bubble or a Carousel of bubbles.
        #
        # This builder requires +alt_text+ (alternative text) for accessibility and
        # for display on devices or LINE versions that cannot render Flex Messages.
        # It can also have a +quickReply+ attached to it.
        #
        # === Example: Creating a Flex Message with a single bubble
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "My Product" do
        #       flex_builder.bubble size: :giga do
        #         hero_image "https://example.com/product.jpg"
        #         body do
        #           text "Product Name", weight: :bold, size: :xl
        #         end
        #       end
        #       quick_reply do
        #         button action: :message, label: "Learn More", text: "Tell me more"
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#flex-messages
        # - Bubble
        # - Carousel
        # - QuickReply
        class Builder < Line::Message::Builder::Base
          # Alternative text for the Flex Message. Displayed on devices that
          # cannot render Flex Messages or used for accessibility.
          # This is a required field for a valid Flex Message.
          #
          # :method: alt_text
          # :call-seq:
          #   alt_text(value) -> String, nil
          #
          # [value]
          #   The alternative text. Max 400 characters.
          option :alt_text, default: nil

          # Initializes a new Flex Message Builder.
          # The provided block is instance-eval'd, allowing DSL methods like
          # #bubble or #carousel to define the main content.
          #
          # [context]
          #   An optional context for the builder.
          # [option]
          #   A hash of options to set instance variables (e.g., <code>:alt_text</code>).
          # [block]
          #   A block to define the content (bubble or carousel)
          #   of this Flex Message.
          def initialize(context: nil, **options, &)
            @contents = nil # Will hold either a Bubble or Carousel instance

            super # Calls Base#initialize, sets options (like @alt_text), and evals block
          end

          # Defines the content of this Flex Message as a single Bubble.
          # If called, this will overwrite any previously defined +carousel+ content.
          #
          # [option]
          #   Options for the Bubble. See Bubble#initialize.
          # [block]
          #   A block to define the sections of the Bubble.
          def bubble(**options, &)
            @contents = Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          # Defines the content of this Flex Message as a Carousel of bubbles.
          # If called, this will overwrite any previously defined +bubble+ content.
          #
          # [option]
          #   Options for the Carousel. See Carousel#initialize.
          # [block]
          #   A block to define the bubbles within the Carousel.
          def carousel(**options, &)
            @contents = Line::Message::Builder::Flex::Carousel.new(context: context, **options, &)
          end

          private

          def to_api # :nodoc:
            raise Error, "Flex Message contents (bubble or carousel) must be defined." if @contents.nil?

            {
              type: "flex",
              altText: alt_text, # From option
              contents: @contents.to_h, # Serializes the Bubble or Carousel
              quickReply: @quick_reply&.to_h # From Base class's quick_reply method
            }.compact
          end

          def to_sdkv2 # :nodoc:
            raise Error, "Flex Message contents (bubble or carousel) must be defined." if @contents.nil?

            {
              type: "flex",
              alt_text: alt_text, # From option
              contents: @contents.to_h, # Serializes the Bubble or Carousel
              quick_reply: @quick_reply&.to_h # From Base class's quick_reply method
            }.compact
          end
        end
      end
    end
  end
end
