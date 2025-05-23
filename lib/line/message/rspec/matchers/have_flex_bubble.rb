# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `HaveFlexBubble` matcher is an RSpec matcher used to verify that
        # a collection of LINE messages (typically an array of message hashes)
        # contains a Flex Message which, in turn, contains a Bubble component
        # matching specified properties.
        #
        # It can search for a bubble within a standalone Flex Message bubble container
        # or within a Flex Message carousel container.
        #
        # @example Basic usage (checking for any bubble)
        #   expect(messages).to have_line_flex_bubble
        #
        # @example Checking for a bubble with specific properties
        #   expect(messages).to have_line_flex_bubble(
        #     size: "mega",
        #     body: {
        #       type: "box",
        #       layout: "vertical",
        #       contents: [
        #         { type: "text", text: "Hello" }
        #       ]
        #     }
        #   )
        #
        # Note: All hash keys in `expected` are automatically stringified for comparison.
        class HaveFlexBubble
          # Initializes the matcher.
          #
          # @param expected_bubble_properties [Hash, nil] A hash representing the properties
          #   expected in the Flex Message Bubble. If `nil` or empty, the matcher
          #   only checks for the presence of any bubble.
          #   Keys are automatically stringified.
          def initialize(expected_bubble_properties)
            @expected = Utils.stringify_keys!(expected_bubble_properties || {}, deep: true)
          end

          # Provides a human-readable description of the matcher.
          # @return [String] The description.
          def description
            return "have flex bubble" if @expected.empty?

            "have flex bubble matching #{@expected.inspect}"
          end

          # Checks if the `actual` collection of messages contains a Flex Message
          # with a Bubble component matching the expected properties.
          #
          # @param actual_messages [Array<Hash>] An array of message hashes (as produced by the builder).
          # @return [Boolean] `true` if a matching bubble is found, `false` otherwise.
          def matches?(actual_messages)
            @actual = Utils.stringify_keys!(actual_messages, deep: true) # Stringify keys of the input messages
            @actual.any? { |message| find_bubble_in_flex_message?(message) }
          end
          alias == matches? # Standard RSpec matcher alias

          # Provides a failure message when the matcher does not find a match.
          # @return [String] The failure message.
          def failure_message
            message = "expected to find a flex bubble"
            message += " matching #{@expected.inspect}" unless @expected.empty?
            message += "\nActual messages: #{@actual.inspect}" # Show what was actually received
            message
          end

          # Provides a failure message for when the matcher should not have found a match (used with `not_to`).
          # @return [String] The failure message for negation.
          def failure_message_when_negated
            message = "expected not to find a flex bubble"
            message += " matching #{@expected.inspect}" unless @expected.empty?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          private

          # Checks if a single message hash is a Flex Message and contains the desired bubble.
          # @param message [Hash] A single message hash.
          # @return [Boolean] `true` if it's a matching Flex Message with the bubble.
          def find_bubble_in_flex_message?(message)
            return false unless message["type"] == "flex" && message["contents"]

            # The `contents` of a flex message can be a single bubble or a carousel (which contains bubbles)
            match_bubble_in_contents?(message["contents"])
          end

          # Recursively searches for a matching bubble within the Flex Message's contents structure.
          # This can be a direct bubble or a carousel containing bubbles.
          # @param content_payload [Hash, Array] The `contents` part of a Flex Message or a nested structure.
          # @return [Boolean] `true` if a matching bubble is found.
          def match_bubble_in_contents?(content_payload)
            if content_payload.is_a?(Hash) && content_payload["type"] == "bubble"
              return check_bubble_properties?(content_payload)
            elsif content_payload.is_a?(Hash) && content_payload["type"] == "carousel" && content_payload["contents"].is_a?(Array)
              # If it's a carousel, check each of its bubbles
              return content_payload["contents"].any? { |bubble_in_carousel| check_bubble_properties?(bubble_in_carousel) }
            end
            # If it's an array (e.g. old format or unexpected structure), iterate, though LINE API typically uses Hash for contents.
            # This part might be less relevant given current LINE API structure for flex messages.
            # For safety, if contents is an array (not typical for top-level flex contents but could be in nested custom components)
            # This was in the original `match_content?` that searched nested `contents` arrays.
            # However, for a top-level Flex message, "contents" is either a bubble hash or a carousel hash.
            # The original logic `content["contents"].any? { |nested_content| match_content?(nested_content) }`
            # seems more suited for a generic "find any component" rather than specifically a bubble within flex contents.
            # For `HaveFlexBubble`, we are interested in the main bubble or bubbles within a carousel directly under flex `contents`.
            false
          end

          # Checks if a given bubble hash matches the `@expected` properties.
          # @param bubble_hash [Hash] The bubble hash to check.
          # @return [Boolean] `true` if it's a bubble and matches.
          def check_bubble_properties?(bubble_hash)
            return false unless bubble_hash.is_a?(Hash) && bubble_hash["type"] == "bubble"

            # Use RSpec's include matcher to check if bubble_hash includes all @expected properties.
            # This allows @expected to be a subset of the actual bubble's properties.
            ::RSpec::Matchers::BuiltIn::Include.new(@expected).matches?(bubble_hash)
          end
        end

        # RSpec shorthand helper method for the {HaveFlexBubble} matcher.
        #
        # @param expected_bubble_properties [Hash, nil] Properties the bubble should have.
        # @return [HaveFlexBubble] An instance of the matcher.
        #
        # @example
        #   expect(messages).to have_line_flex_bubble(size: "mega")
        def have_line_flex_bubble(expected_bubble_properties = nil) # rubocop:disable Naming/PredicateName
          HaveFlexBubble.new(expected_bubble_properties)
        end
      end
    end
  end
end
