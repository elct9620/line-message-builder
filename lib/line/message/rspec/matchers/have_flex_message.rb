# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `HaveFlexMessage` matcher is an RSpec matcher used to verify that
        # a collection of LINE messages (typically an array of message hashes)
        # contains at least one Flex Message. Optionally, it can also check if
        # the Flex Message's `altText` matches a given string or regular expression.
        #
        # @example Basic usage (checking for any Flex Message)
        #   expect(messages).to have_line_flex_message
        #
        # @example Checking for a Flex Message with specific altText
        #   expect(messages).to have_line_flex_message("This is the alt text.")
        #
        # @example Checking for a Flex Message with altText matching a regex
        #   expect(messages).to have_line_flex_message(/alternative text/i)
        #
        # Note: All hash keys in the message data are automatically stringified.
        class HaveFlexMessage
          # Initializes the matcher.
          #
          # @param expected_alt_text [String, Regexp, nil] The expected `altText`.
          #   If `nil`, the matcher only checks for the presence of a Flex Message.
          #   If a `String`, an exact match is required.
          #   If a `Regexp`, `altText.match?(expected_alt_text)` is used.
          def initialize(expected_alt_text)
            @expected_alt_text = expected_alt_text
          end

          # Provides a human-readable description of the matcher.
          # @return [String] The description.
          def description
            return "have flex message" if @expected_alt_text.nil?

            "have flex message with alt text matching #{@expected_alt_text.inspect}"
          end

          # Checks if the `actual_messages` array contains a Flex Message,
          # optionally matching the `altText`.
          #
          # @param actual_messages [Array<Hash>] An array of message hashes.
          # @return [Boolean] `true` if a matching Flex Message is found, `false` otherwise.
          def matches?(actual_messages)
            @actual = Utils.stringify_keys!(actual_messages, deep: true) # Ensure keys are strings for lookup
            @actual.any? { |message| check_message_for_flex_and_alttext?(message) }
          end
          alias == matches? # Standard RSpec matcher alias

          # Provides a failure message.
          # @return [String] The failure message.
          def failure_message
            message = "expected to find a flex message"
            message += " with alt text matching #{@expected_alt_text.inspect}" unless @expected_alt_text.nil?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          # Provides a failure message for negation.
          # @return [String] The failure message for negation.
          def failure_message_when_negated
            message = "expected not to find a flex message"
            message += " with alt text matching #{@expected_alt_text.inspect}" unless @expected_alt_text.nil?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          private

          # Checks if a single message hash is a Flex Message and if its `altText` matches.
          # @param message [Hash] A single message hash.
          # @return [Boolean]
          def check_message_for_flex_and_alttext?(message)
            return false unless message.is_a?(Hash) && message["type"] == "flex"
            return true if @expected_alt_text.nil? # If no altText expected, just finding a flex message is enough

            actual_alt_text = message["altText"]
            return false if actual_alt_text.nil? # If altText is expected but not present

            if @expected_alt_text.is_a?(Regexp)
              actual_alt_text.match?(@expected_alt_text)
            else
              actual_alt_text == @expected_alt_text.to_s
            end
          end
        end

        # RSpec shorthand helper method for the {HaveFlexMessage} matcher.
        #
        # @param expected_alt_text [String, Regexp, nil] The `altText` the Flex Message should have.
        # @return [HaveFlexMessage] An instance of the matcher.
        #
        # @example
        #   expect(messages).to have_line_flex_message("Summary of the message.")
        #   expect(messages).to have_line_flex_message(/important update/i)
        #   expect(messages).to have_line_flex_message # Checks for any flex message
        def have_line_flex_message(expected_alt_text = nil) # rubocop:disable Naming/PredicateName
          HaveFlexMessage.new(expected_alt_text)
        end
      end
    end
  end
end
