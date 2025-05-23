# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # Represents a Carousel container in a Flex Message.
        # A carousel is a horizontally scrollable sequence of {Bubble} containers.
        #
        # Usage:
        #   ```ruby
        #   carousel = Line::Message::Builder::Flex::Carousel.new do
        #     bubble do
        #       # ... define first bubble ...
        #     end
        #     bubble do
        #       # ... define second bubble ...
        #     end
        #   end
        #   ```
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#carousel
        class Carousel < Line::Message::Builder::Base
          include HasPartial

          # @!attribute [r] contents
          #   @return [Array<Bubble>] An array of Bubble containers in the carousel.
          attr_reader :contents

          # Initializes a new Carousel container.
          #
          # @param context [Object, nil] The context for the carousel.
          # @param options [Hash] Options for the carousel (currently none specific to Carousel itself).
          # @param block [Proc] A block to define the {Bubble} containers within the carousel.
          #   Use the `bubble` method inside the block to add bubbles.
          def initialize(context: nil, **options, &)
            @contents = []

            super
          end

          # Adds a {Bubble} container to the carousel.
          # This method should be called within the block passed to the `initialize` method.
          #
          # @param options [Hash] Options for the Bubble container.
          # @param block [Proc] A block to define the contents of the Bubble.
          # @return [Bubble] The created Bubble container.
          def bubble(**options, &)
            @contents << Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          # Converts the Carousel container to its hash representation for the LINE API.
          #
          # @raise [RequiredError] if the carousel contains no bubbles.
          # @return [Hash] The hash representation of the carousel.
          def to_h
            raise RequiredError, "contents should have at least 1 bubble" if @contents.empty?

            {
              type: "carousel",
              contents: @contents.map(&:to_h)
            }.compact # compact is likely not needed here as contents will always be present.
          end
        end
      end
    end
  end
end
