# frozen_string_literal: true

module Line
  module Message
    module Builder
      # The `Actions` module serves as a namespace for action objects that can be
      # associated with various LINE message components, such as buttons in
      # quick replies or imagemaps. Each class within this module represents a
      # specific type of action a user can perform.
      module Actions
        # Represents a "message action" for LINE messages.
        #
        # A message action sends a specified text message to the chat from the user
        # when a button associated with this action is tapped. It's commonly used
        # in quick replies or other interactive message components.
        #
        # @example Creating a message action for a quick reply button
        #   Line::Message::Builder.with do |root|
        #     root.text "Select your favorite food:"
        #     root.quick_reply do |qr|
        #       # When this button is tapped, the user sends "Pizza"
        #       qr.button action: :message, label: "Pizza", text: "Pizza"
        #       # When this button is tapped, the user sends "Sushi"
        #       qr.button action: :message, label: "Sushi", text: "Sushi"
        #     end
        #   end
        #
        # @see https://developers.line.biz/en/reference/messaging-api/#message-action
        class Message < Line::Message::Builder::Base
          # @!attribute [r] text
          #   @return [String] The text that is sent as a message from the user
          #     when the action is performed. This is a required attribute.
          attr_reader :text

          # Defines an optional `label` for the action.
          # The label is recommended by LINE for accessibility purposes, but it's
          # not displayed in all LINE versions. For some message types like buttons,
          # the label of the button itself is used as the action's label.
          #
          # @!method label(value = nil)
          #   @param value [String, nil] The label text for the action.
          #   @return [String, nil] The current label text.
          option :label, default: nil

          # Initializes a new Message action.
          #
          # @param text [String] The text to be sent when the action is performed.
          #   This is a required parameter.
          # @param context [Object, nil] An optional context object for resolving
          #   method calls within a block, if one is provided.
          # @param options [Hash] A hash of options to set instance variables.
          #   Can include `:label`.
          # @param block [Proc, nil] An optional block to be instance-eval'd.
          #   While available, it's not commonly used for simple actions like this.
          # @raise [RequiredError] if `text` is nil. (This check is done in `to_h`
          #   but `text` is conceptually required on initialization).
          def initialize(text, context: nil, **options, &)
            @text = text

            super(context: context, **options, &)
          end

          # Converts the Message action object to a hash suitable for the LINE
          # Messaging API.
          #
          # @return [Hash] A hash representing the message action.
          #   Includes `:type`, `:label` (if set), and `:text`.
          # @raise [RequiredError] if `text` is nil.
          def to_h
            return to_sdkv2 if context.sdkv2?

            to_api
          end

          private

          def to_api
            raise RequiredError, "text is required" if text.nil?

            {
              type: "message",
              label: label,
              text: text
            }.compact
          end

          def to_sdkv2
            raise RequiredError, "text is required" if text.nil?

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
