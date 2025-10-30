# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a carousel container in a LINE Flex Message.
        # A carousel is a horizontally scrollable sequence of Bubble components.
        # Each bubble in the carousel is a distinct message unit. Users can swipe
        # left or right to view the different bubbles.
        #
        # Carousels are ideal for presenting multiple items, such as products,
        # articles, or options, in a compact and interactive way.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     flex alt_text: "Product Showcase" do
        #       carousel do
        #         bubble size: :mega do
        #           hero_image "https://example.com/product1.jpg"
        #           body { text "Product 1" }
        #         end
        #         bubble size: :mega do
        #           hero_image "https://example.com/product2.jpg"
        #           body { text "Product 2" }
        #         end
        #       end
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#carousel
        # - Bubble for the structure of individual items within the carousel
        # - HasPartial (included but direct usage on Carousel is limited; partials
        #   are more commonly used within bubbles)
        class Carousel < Line::Message::Builder::Base
          include HasPartial

          # An array holding the Bubble components that form the items of this carousel.
          attr_reader :contents

          # Initializes a new Flex Message Carousel container.
          # The provided block is instance-eval'd, allowing DSL methods like
          # +bubble+ to be called to add bubbles to the carousel.
          #
          # [context]
          #   An optional context for the builder
          # [options]
          #   A hash of options (currently none specific to Carousel itself,
          #   but available for future extensions or via Base)
          # [block]
          #   A block to define the bubbles within this carousel
          #
          # == Example
          #
          #   carousel = Carousel.new do
          #     bubble { body { text "First" } }
          #     bubble { body { text "Second" } }
          #   end
          def initialize(context: nil, **options, &)
            @contents = [] # Holds an array of Bubble objects

            super # Calls Base#initialize, sets options, and evals block
          end

          # Adds a new Bubble to this carousel's contents.
          # Each call to this method appends another bubble to the horizontal sequence.
          #
          # [options]
          #   Options for the Bubble (see Bubble#initialize)
          # [block]
          #   A block to define the sections and content of the Bubble
          #
          # [return]
          #   The newly created Bubble object that was added to the carousel
          #
          # == Example
          #
          #   carousel do
          #     bubble size: :mega do
          #       body { text "Product 1" }
          #     end
          #     bubble size: :mega do
          #       body { text "Product 2" }
          #     end
          #   end
          def bubble(**options, &)
            # The maximum number of bubbles is validated in `to_h` as per LINE API limits.
            @contents << Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          # :nodoc:
          def to_h
            raise RequiredError, "Carousel contents must have at least 1 bubble." if @contents.empty?
            # LINE API as of 2023-10-10 allows up to 12 bubbles in a carousel.
            raise ValidationError, "Carousel contents can have at most 12 bubbles." if @contents.size > 12

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          # :nodoc:
          def to_api
            {
              type: "carousel",
              contents: @contents.map(&:to_h) # Serializes each Bubble in the array
            }.compact # compact is likely unnecessary here as contents is always present.
          end

          # :nodoc:
          def to_sdkv2
            {
              type: "carousel",
              contents: @contents.map(&:to_h) # Serializes each Bubble in the array
            }.compact # compact is likely unnecessary here as contents is always present.
          end
        end
      end
    end
  end
end
