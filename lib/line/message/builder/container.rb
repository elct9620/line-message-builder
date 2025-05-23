# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Container` class is the main entry point for building a collection of LINE messages.
      # It acts as a container that can hold multiple message objects (like Text, Flex messages).
      #
      # Usage:
      #   ```ruby
      #   container = Line::Message::Builder::Container.new do
      #     text "Hello, world!"
      #     flex alt_text: "This is a Flex Message" do
      #       # ... define flex message content ...
      #     end
      #   end
      #   message_payload = container.build
      #   ```
      class Container < Base
        # @!attribute [r] context
        #   @return [Context] The context object associated with this container.
        attr_reader :context

        # Initializes a new message container.
        #
        # @param context [Object, nil] An optional external context.
        # @param block [Proc] A block that defines the messages within this container.
        #   The block is executed in the context of the new container instance.
        def initialize(context: nil, &)
          @messages = []

          super
        end

        # Adds a text message to the container.
        #
        # @param text [String] The content of the text message.
        # @param options [Hash] Additional options for the text message (e.g., quick reply).
        # @param block [Proc, nil] An optional block to further configure the text message.
        # @return [Text] The created Text message object.
        def text(text, **options, &)
          @messages << Text.new(text, context: context, **options, &)
        end

        # Adds a flex message to the container.
        #
        # @param options [Hash] Options for the flex message (e.g., `alt_text`).
        # @param block [Proc] A block that defines the content of the flex message.
        #   The block is executed in the context of a new {Flex::Builder} instance.
        # @return [Flex::Builder] The created Flex message builder object.
        def flex(**options, &)
          @messages << Flex::Builder.new(context: context, **options, &)
        end

        # Builds an array of message hashes from the messages added to the container.
        # This is typically the payload you would send to the LINE Messaging API.
        #
        # @return [Array<Hash>] An array of message objects, ready for JSON conversion.
        def build
          @messages.map(&:to_h)
        end

        # Converts the built messages into a JSON string.
        #
        # @param args [Array] Arguments to be passed to `to_json` on the array of messages.
        # @return [String] A JSON string representing the messages.
        def to_json(*args)
          build.to_json(*args)
        end
      end
    end
  end
end
