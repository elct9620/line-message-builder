# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The +Container+ class is the top-level entry point for constructing a batch
      # of LINE messages using the builder DSL. It acts as a holder for one or
      # more individual message objects (such as Text or Flex messages).
      #
      # When you use <code>Line::Message::Builder.with {}</code>, you are operating within
      # the context of a +Container+ instance. This container allows you to define
      # multiple messages that can be sent together in a single API call to LINE,
      # although the LINE API typically expects an array of message objects,
      # which this container helps to build.
      #
      # Each message added to the container can also have its own quick reply.
      #
      # == Example
      #
      #   message_payload = Line::Message::Builder.with do
      #     text "Hello, this is the first message!"
      #     flex alt_text: "This is a Flex Message" do
      #       bubble do
      #         body do
      #           body.text "This is a Flex Message body."
      #         end
      #       end
      #     end
      #   end.build # => Returns an array of message hashes
      #
      # See also:
      # - Base
      # - Text
      # - Flex::Builder
      # - QuickReply
      class Container
        # [return]
        #   The context object, which can hold external data or
        #   helper methods accessible within the builder blocks.
        attr_reader :context

        # Initializes a new message container.
        # This is typically not called directly but through <code>Line::Message::Builder.with</code>.
        # The provided block is instance-eval'd, allowing DSL methods like
        # #text and #flex to be called directly on the container instance.
        #
        # [context]
        #   An optional context object that can be used
        #   to share data or helper methods within the builder block. It's wrapped
        #   in a Context object.
        # [mode]
        #   The mode to use for building messages. Can be either
        #   <code>:api</code> (default) for direct LINE Messaging API format or <code>:sdkv2</code> for
        #   LINE Bot SDK v2 compatible format.
        # [block]
        #   A block containing DSL calls to define messages
        #   (e.g., <code>text "Hello"</code>, <code>flex { ... }</code>).
        def initialize(context: nil, mode: :api, &block)
          @messages = [] # Initializes an empty array to store message objects
          @context = Context.new(context, mode:)

          instance_eval(&block) if ::Kernel.block_given?
        end

        # Creates a new Text message and adds it to this container.
        #
        # [text]
        #   The text content of the message.
        # [option]
        #   Additional options for the text message,
        #   such as <code>:quick_reply</code>. See Text#initialize.
        # [block]
        #   An optional block that will be instance-eval'd
        #   in the context of the new Text message instance. This can be used
        #   to add a quick reply to the text message.
        #
        # == Example
        #
        #   root.text "Hello, world!" do
        #     quick_reply do
        #       button action: :message, label: "Hi!", text: "Hi!"
        #     end
        #   end
        def text(text, **options, &)
          @messages << Text.new(text, context: context, **options, &)
        end

        # Creates a new Flex::Builder for constructing a Flex Message and adds it
        # to this container. The block is mandatory and is used to define the
        # content of the Flex Message using the Flex Message DSL.
        #
        # [option]
        #   Options for the Flex Message, primarily <code>:alt_text</code>.
        #   See Flex::Builder#initialize. It's important to provide +alt_text+.
        # [block]
        #   A block that will be instance-eval'd in the context
        #   of the new Flex::Builder instance. This block is used to define the
        #   structure and content of the Flex Message (e.g., bubbles, carousels).
        #
        # Raises ArgumentError if +alt_text+ is not provided in options (validation
        # is typically within Flex::Builder).
        #
        # == Example
        #
        #   flex alt_text: "Important information" do
        #     bubble do
        #       header { text "Header" }
        #       body   { text "Body" }
        #     end
        #   end
        def flex(**options, &)
          @messages << Flex::Builder.new(context: context, **options, &)
        end

        # Converts all messages held by this container into their hash representations.
        # This method iterates over each message object (e.g., Text, Flex::Builder)
        # stored in the container and calls its +to_h+ method. The result is an
        # array of hashes, where each hash represents a single LINE message object
        # ready for JSON serialization and sending to the LINE Messaging API.
        def build
          @messages.map(&:to_h)
        end

        # Converts the array of message hashes (obtained from #build) into a
        # JSON string. This is a convenience method for serializing the messages
        # payload.
        #
        # [arg]
        #   Optional arguments that are passed along to +to_json+
        #   method of the underlying array.
        def to_json(*args)
          build.to_json(*args)
        end

        # :nodoc:
        def respond_to_missing?(method_name, include_private = false)
          context.respond_to?(method_name, include_private) || super
        end

        # :nodoc:
        def method_missing(method_name, ...)
          return context.send(method_name, ...) if context.respond_to?(method_name)

          super
        end
      end
    end
  end
end
