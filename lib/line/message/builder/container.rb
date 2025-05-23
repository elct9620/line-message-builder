# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Container` class is the top-level entry point for constructing a batch
      # of LINE messages using the builder DSL. It acts as a holder for one or
      # more individual message objects (such as {Text} or {Flex} messages).
      #
      # When you use `Line::Message::Builder.with {}`, you are operating within
      # the context of a `Container` instance. This container allows you to define
      # multiple messages that can be sent together in a single API call to LINE,
      # although the LINE API typically expects an array of message objects,
      # which this container helps to build.
      #
      # Each message added to the container can also have its own quick reply.
      #
      # @example Building multiple messages
      #   message_payload = Line::Message::Builder.with do |root|
      #     root.text "Hello, this is the first message!"
      #     root.flex alt_text: "This is a Flex Message" do |flex_builder|
      #       flex_builder.bubble do |bubble|
      #         bubble.body do |body|
      #           body.text "This is a Flex Message body."
      #         end
      #       end
      #     end
      #   end.build # => Returns an array of message hashes
      #
      # @see Base
      # @see Text
      # @see Flex::Builder
      # @see QuickReply
      class Container < Base
        # While `context` is available via `Base`, it's documented here for clarity
        # within the container's scope.
        # @!attribute [r] context
        #   @return [Context] The context object, which can hold external data or
        #     helper methods accessible within the builder blocks.
        attr_reader :context

        # Initializes a new message container.
        # This is typically not called directly but through `Line::Message::Builder.with`.
        # The provided block is instance-eval'd, allowing DSL methods like
        # {#text} and {#flex} to be called directly on the container instance.
        #
        # @param context [Object, nil] An optional context object that can be used
        #   to share data or helper methods within the builder block. It's wrapped
        #   in a {Context} object.
        # @param block [Proc] A block containing DSL calls to define messages
        #   (e.g., `text "Hello"`, `flex { ... }`).
        def initialize(context: nil, &)
          @messages = [] # Initializes an empty array to store message objects

          super # Calls Base#initialize, which sets up @context and evals the block
        end

        # Creates a new {Text} message and adds it to this container.
        #
        # @param text [String] The text content of the message.
        # @param options [Hash] Additional options for the text message,
        #   such as `:quick_reply`. See {Text#initialize}.
        # @param block [Proc, nil] An optional block that will be instance-eval'd
        #   in the context of the new {Text} message instance. This can be used
        #   to add a quick reply to the text message.
        # @return [Text] The newly created {Text} message object.
        #
        # @example
        #   root.text "Hello, world!" do
        #     quick_reply do
        #       button action: :message, label: "Hi!", text: "Hi!"
        #     end
        #   end
        def text(text, **options, &)
          @messages << Text.new(text, context: context, **options, &)
        end

        # Creates a new {Flex::Builder} for constructing a Flex Message and adds it
        # to this container. The block is mandatory and is used to define the
        # content of the Flex Message using the Flex Message DSL.
        #
        # @param options [Hash] Options for the Flex Message, primarily `:alt_text`.
        #   See {Flex::Builder#initialize}. It's important to provide `alt_text`.
        # @param block [Proc] A block that will be instance-eval'd in the context
        #   of the new {Flex::Builder} instance. This block is used to define the
        #   structure and content of the Flex Message (e.g., bubbles, carousels).
        # @return [Flex::Builder] The newly created {Flex::Builder} object.
        # @raise [ArgumentError] if `alt_text` is not provided in options (validation
        #   is typically within Flex::Builder).
        #
        # @example
        #   root.flex alt_text: "Important information" do |fb|
        #     fb.bubble do |bubble|
        #       bubble.header { |h| h.text "Header" }
        #       bubble.body   { |b| b.text "Body" }
        #     end
        #   end
        def flex(**options, &)
          @messages << Flex::Builder.new(context: context, **options, &)
        end

        # Converts all messages held by this container into their hash representations.
        # This method iterates over each message object (e.g., {Text}, {Flex::Builder})
        # stored in the container and calls its `to_h` method. The result is an
        # array of hashes, where each hash represents a single LINE message object
        # ready for JSON serialization and sending to the LINE Messaging API.
        #
        # @return [Array<Hash>] An array of message objects, each represented as a hash.
        #   This is the format expected by the LINE API for the `messages` field
        #   in a request body.
        def build
          @messages.map(&:to_h)
        end

        # Converts the array of message hashes (obtained from {#build}) into a
        # JSON string. This is a convenience method for serializing the messages
        # payload.
        #
        # @param args [Object] Optional arguments that are passed along to `to_json`
        #   method of the underlying array.
        # @return [String] A JSON string representing the array of message objects.
        def to_json(*args)
          build.to_json(*args)
        end
      end
    end
  end
end
