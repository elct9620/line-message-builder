# frozen_string_literal: true

module Line
  module Message
    module Builder
      module Flex
        # The `Builder` class is the main entry point for constructing a Flex Message.
        # A Flex Message is a customizable message type that can contain one or more
        # {Bubble} containers or a {Carousel} of bubbles.
        #
        # Usage:
        #   ```ruby
        #   flex_message = Line::Message::Builder::Flex::Builder.new alt_text: "Alternative text" do
        #     bubble do
        #       # ... define bubble content ...
        #     end
        #   end
        #   payload = flex_message.to_h
        #   ```
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#flex-messages
        class Builder < Line::Message::Builder::Base
          # @!attribute alt_text
          #   @return [String, nil] Alternative text displayed on clients that don't support Flex Messages.
          #     Max: 400 characters.
          option :alt_text, default: nil

          # Initializes a new Flex Message builder.
          #
          # @param context [Object, nil] The context for the Flex Message.
          # @param options [Hash] Options for the Flex Message (e.g., `alt_text`).
          # @param block [Proc] A block to define the contents of the Flex Message.
          #   Within the block, you should define either a `bubble` or a `carousel`.
          def initialize(context: nil, **options, &)
            @contents = nil

            super
          end

          # Defines the Flex Message content as a single {Bubble} container.
          #
          # @param options [Hash] Options for the Bubble container.
          # @param block [Proc] A block to define the contents of the Bubble.
          # @return [Bubble] The created Bubble container.
          def bubble(**options, &)
            @contents = Line::Message::Builder::Flex::Bubble.new(context: context, **options, &)
          end

          # Defines the Flex Message content as a {Carousel} of {Bubble} containers.
          #
          # @param options [Hash] Options for the Carousel container.
          # @param block [Proc] A block to define the bubbles within the Carousel.
          # @return [Carousel] The created Carousel container.
          def carousel(**options, &)
            @contents = Line::Message::Builder::Flex::Carousel.new(context: context, **options, &)
          end

          # Converts the Flex Message to its hash representation for the LINE API.
          #
          # @raise [Error] if the contents (bubble or carousel) have not been defined.
          # @return [Hash] The hash representation of the Flex Message.
          def to_h
            raise Error, "contents should be bubble or carousel" if @contents.nil?
            raise RequiredError, "alt_text is required" if alt_text.nil?

            {
              type: "flex",
              altText: alt_text, # Use the accessor method
              contents: @contents.to_h,
              quickReply: @quick_reply&.to_h # @quick_reply is from Base
            }.compact
          end
        end
      end
    end
  end
end
