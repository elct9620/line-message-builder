# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `HaveTextMessage` matcher is an RSpec matcher used to verify that
        # a collection of LINE messages (typically an array of message hashes)
        # contains at least one Text Message. Optionally, it can also check if
        # the text content matches a given string or regular expression, and if
        # the message hash includes other specified options (e.g., `quoteToken`).
        #
        # @example Basic usage (checking for any Text Message)
        #   expect(messages).to have_line_text_message
        #
        # @example Checking for a Text Message with specific text
        #   expect(messages).to have_line_text_message("Hello, world!")
        #
        # @example Checking for a Text Message with text matching a regex
        #   expect(messages).to have_line_text_message(/welcome back/i)
        #
        # @example Checking for a Text Message with text and other options
        #   expect(messages).to have_line_text_message("Quoted reply", quoteToken: "token123")
        #
        # Note: All hash keys in the options are automatically stringified.
        class HaveTextMessage
          # Initializes the matcher.
          #
          # @param expected_args [Array] An array where the first element is the expected text
          #   (String, Regexp, or `nil` to match any text message). The optional second
          #   element is a hash of additional properties the text message should include
          #   (e.g., `{ quoteToken: "xyz" }`).
          def initialize(expected_args)
            @expected_text, options_hash = expected_args
            @expected_options = Utils.stringify_keys!(options_hash || {}, deep: true)
          end

          # Provides a human-readable description of the matcher.
          # @return [String] The description.
          def description
            desc = "have text message"
            desc += " with text matching #{@expected_text.inspect}" unless @expected_text.nil?
            desc += " and options #{@expected_options.inspect}" unless @expected_options.empty?
            desc
          end

          # Checks if the `actual_messages` array contains a Text Message matching
          # the specified text and options.
          #
          # @param actual_messages [Array<Hash>] An array of message hashes.
          # @return [Boolean] `true` if a matching Text Message is found, `false` otherwise.
          def matches?(actual_messages)
            @actual = Utils.stringify_keys!(actual_messages, deep: true) # Ensure keys are strings for lookup

            @actual.any? do |message|
              next false unless message.is_a?(Hash) && message["type"] == "text"

              text_match = if @expected_text.nil?
                             true # Any text message matches if no specific text is expected
                           else
                             actual_message_text = message["text"]
                             next false if actual_message_text.nil? # Text must exist if expected_text is not nil
                             @expected_text.is_a?(Regexp) ? actual_message_text.match?(@expected_text) : actual_message_text == @expected_text.to_s
                           end

              options_match = @expected_options.empty? || ::RSpec::Matchers::BuiltIn::Include.new(@expected_options).matches?(message)

              text_match && options_match
            end
          end
          alias == matches? # Standard RSpec matcher alias

          # Provides a failure message.
          # @return [String] The failure message.
          def failure_message
            message = "expected to find a text message"
            message += " with text matching #{@expected_text.inspect}" unless @expected_text.nil?
            message += " and options #{@expected_options.inspect}" unless @expected_options.empty?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          # Provides a failure message for negation.
          # @return [String] The failure message for negation.
          def failure_message_when_negated
            message = "expected not to find a text message"
            message += " with text matching #{@expected_text.inspect}" unless @expected_text.nil?
            message += " and options #{@expected_options.inspect}" unless @expected_options.empty?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end
        end

        # RSpec shorthand helper method for the {HaveTextMessage} matcher.
        #
        # @param expected_text [String, Regexp, nil] The text the message should have.
        #   If `nil`, any text message will match.
        # @param options [Hash] Additional properties the message hash should include (e.g., `quoteToken`).
        # @return [HaveTextMessage] An instance of the matcher.
        #
        # @example
        #   expect(messages).to have_line_text_message("Order confirmed.")
        #   expect(messages).to have_line_text_message(/status update/i, quoteToken: "prev_msg_token")
        #   expect(messages).to have_line_text_message # Checks for any text message
        def have_line_text_message(*expected_args) # rubocop:disable Naming/PredicateName
          HaveTextMessage.new(expected_args)
        end
      end
    end
  end
end
