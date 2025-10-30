# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The Actions module serves as a namespace for action objects that can be
      # associated with various LINE message components, such as buttons in
      # quick replies or imagemaps. Each class within this module represents a
      # specific type of action a user can perform.
      module Actions
        # Represents a message action for LINE messages.
        #
        # A message action sends a specified text message to the chat from the user
        # when a button associated with this action is tapped. It's commonly used
        # in quick replies or other interactive message components.
        #
        # == Example
        #
        #   Line::Message::Builder.with do
        #     text "Select your favorite food:"
        #     quick_reply do
        #       # When this button is tapped, the user sends "Pizza"
        #       button action: :message, label: "Pizza", text: "Pizza"
        #       # When this button is tapped, the user sends "Sushi"
        #       button action: :message, label: "Sushi", text: "Sushi"
        #     end
        #   end
        #
        # See also:
        # - https://developers.line.biz/en/reference/messaging-api/#message-action
        class Message < Line::Message::Builder::Base
          # The text that is sent as a message from the user when the action
          # is performed. This is a required attribute.
          attr_reader :text

          # :method: label
          # :call-seq:
          #   label() -> String or nil
          #   label(value) -> String
          #
          # Sets or gets the optional label for the action.
          #
          # The label is recommended by LINE for accessibility purposes, but it's
          # not displayed in all LINE versions. For some message types like buttons,
          # the label of the button itself is used as the action's label.
          #
          # [value]
          #   The label text for the action
          option :label, default: nil

          # Initializes a new Message action.
          #
          # [text]
          #   The text to be sent when the action is performed (required)
          # [context]
          #   An optional context object for resolving method calls within a block
          # [options]
          #   A hash of options to set instance variables (can include +:label+)
          # [block]
          #   An optional block to be instance-eval'd (not commonly used for simple actions)
          #
          # Raises RequiredError if +text+ is nil (this check is done in +to_h+
          # but text is conceptually required on initialization).
          #
          # == Example
          #
          #   action = Message.new("Hello, world!")
          #   action = Message.new("Pizza", label: "Select Pizza")
          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          # Converts the Message action object to a hash suitable for the LINE
          # Messaging API.
          #
          # The returned hash includes +:type+, +:label+ (if set), and +:text+.
          #
          # Raises RequiredError if +text+ is nil.
          #
          # == Example
          #
          #   action = Message.new("Pizza")
          #   action.to_h
          #   # => { type: "message", text: "Pizza" }
          #
          # [return]
          #   A hash representing the message action
          def to_h
            raise RequiredError, "text is required" if text.nil?

            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api # :nodoc:
            {
              type: "message",
              label: label,
              text: text
            }.compact
          end

          def to_sdkv2 # :nodoc:
            {
              type: "message",
              label: label,
              text: text
            }.compact
          end
        end
      end
    end
  end
end
