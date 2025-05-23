# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a "carousel" container in a LINE Flex Message.
        # A carousel is a horizontally scrollable sequence of {Bubble} components.
        # Each bubble in the carousel is a distinct message unit. Users can swipe
        # left or right to view the different bubbles.
        #
        # Carousels are ideal for presenting multiple items, such as products,
        # articles, or options, in a compact and interactive way.
        #
        # @example Creating a carousel with two bubbles
        #   Line::Message::Builder.with do |root|
        #     root.flex alt_text: "Product Showcase" do |flex_builder|
        #       flex_builder.carousel do |carousel_container| # carousel_container is an instance of Flex::Carousel
        #         carousel_container.bubble size: :mega do |bubble1|
        #           bubble1.hero_image "https://example.com/product1.jpg"
        #           bubble1.body { |b| b.text "Product 1" }
        #         end
        #         carousel_container.bubble size: :mega do |bubble2|
        #           bubble2.hero_image "https://example.com/product2.jpg"
        #           bubble2.body { |b| b.text "Product 2" }
        #         end
        #       end
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#carousel
        # @see Bubble For the structure of individual items within the carousel.
        # @see HasPartial While included, direct usage on Carousel itself is limited;
        #   partials are more commonly used within the individual bubbles.
        class Carousel < Line::Message::Builder::Base
          include HasPartial # Allows including predefined partial component sets (more relevant for bubbles within).

          # @!attribute [r] contents
          #   @return [Array<Flex::Bubble>] An array holding the {Bubble} components
          #     that form the items of this carousel.
          attr_reader :contents

          # Initializes a new Flex Message Carousel container.
          # The provided block is instance-eval'd, allowing DSL methods like
          # {#bubble} to be called to add bubbles to the carousel.
          #
          # @param context [Object, nil] An optional context for the builder.
          # @param options [Hash] A hash of options (currently none specific to Carousel itself,
          #   but available for future extensions or via `Base`).
          # @param block [Proc, nil] A block to define the bubbles within this carousel.
          def initialize(context: nil, **options, &)
            @contents = [] # Holds an array of Bubble objects

            super # Calls Base#initialize, sets options, and evals block
          end

          # Adds a new {Bubble} to this carousel's contents.
          # Each call to this method appends another bubble to the horizontal sequence.
          #
          # @param options [Hash] Options for the Bubble. See {Bubble#initialize}.
          # @param block [Proc] A block to define the sections and content of the Bubble.
          # @return [Flex::Bubble] The newly created Bubble object that was added to the carousel.
          def bubble(**options, &)
            # The maximum number of bubbles is validated in `to_h` as per LINE API limits.
            @contents << Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          # Converts the Carousel container and all its Bubbles to a hash suitable
          # for the LINE Messaging API.
          #
          # @return [Hash] A hash representing the carousel container.
          # @raise [RequiredError] if the carousel contains no bubbles.
          # @raise [ValidationError] if the carousel contains more than 12 bubbles
          #   (LINE API limit is 12, previously was 10).
          def to_h
            raise RequiredError, "Carousel contents must have at least 1 bubble." if @contents.empty?
            # LINE API as of 2023-10-10 allows up to 12 bubbles in a carousel.
            raise ValidationError, "Carousel contents can have at most 12 bubbles." if @contents.size > 12

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
