# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `HaveQuickReply` matcher is an RSpec matcher used to verify that
        # a collection of LINE messages (typically an array of message hashes)
        # contains at least one message that has a Quick Reply section, and that
        # this Quick Reply section includes an action item matching the specified properties.
        #
        # @example Basic usage (checking for any quick reply action)
        #   expect(messages).to have_line_quick_reply
        #
        # @example Checking for a quick reply action with specific properties
        #   # This checks if any quick reply button has a 'message' action with label 'Yes'
        #   expect(messages).to have_line_quick_reply(type: "message", label: "Yes")
        #
        #   # This checks if any quick reply button has a 'postback' action with specific data
        #   expect(messages).to have_line_quick_reply(type: "postback", data: "action=subscribe")
        #
        # Note: All hash keys in `expected_action_properties` are automatically stringified.
        class HaveQuickReply
          # Initializes the matcher.
          #
          # @param expected_action_properties [Hash, nil] A hash representing the properties
          #   expected in one of the Quick Reply action items. If `nil`, the matcher
          #   only checks for the presence of any quick reply action.
          #   Keys are automatically stringified.
          def initialize(expected_action_properties)
            @expected_action_properties = Utils.stringify_keys!(expected_action_properties || {}, deep: true)
          end

          # Provides a human-readable description of the matcher.
          # @return [String] The description.
          def description
            return "have a message with a quick reply action" if @expected_action_properties.empty?

            "have a message with a quick reply action matching #{@expected_action_properties.inspect}"
          end

          # Checks if the `actual_messages` array contains a message with a Quick Reply
          # that includes an action matching the expected properties.
          #
          # @param actual_messages [Array<Hash>] An array of message hashes.
          # @return [Boolean] `true` if a matching quick reply action is found, `false` otherwise.
          def matches?(actual_messages)
            @actual = Utils.stringify_keys!(actual_messages, deep: true) # Ensure keys are strings
            @actual.any? { |message| check_message_for_quick_reply_action?(message) }
          end
          alias == matches? # Standard RSpec matcher alias

          # Provides a failure message.
          # @return [String] The failure message.
          def failure_message
            message = "expected to find a message with a quick reply action"
            message += " matching #{@expected_action_properties.inspect}" unless @expected_action_properties.empty?
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          private

          # Checks if a single message hash has a Quick Reply with a matching action.
          # @param message [Hash] A single message hash.
          # @return [Boolean]
          def check_message_for_quick_reply_action?(message)
            quick_reply_payload = message["quickReply"]
            return false unless quick_reply_payload.is_a?(Hash) && quick_reply_payload["items"].is_a?(Array)

            quick_reply_payload["items"].any? do |item|
              action_payload = item["action"] # Each item in quickReply.items has an 'action'
              next false unless action_payload.is_a?(Hash)
              action_matches_expected?(action_payload)
            end
          end

          # Checks if a given action hash matches the `@expected_action_properties`.
          # @param action_hash [Hash] The action hash from a quick reply item.
          # @return [Boolean] `true` if it matches.
          def action_matches_expected?(action_hash)
            return true if @expected_action_properties.empty? # If no specific properties, any action is fine

            # Use RSpec's include matcher to check if action_hash includes all @expected_action_properties.
            ::RSpec::Matchers::BuiltIn::Include.new(@expected_action_properties).matches?(action_hash)
          end
        end

        # RSpec shorthand helper method for the {HaveQuickReply} matcher.
        #
        # @param expected_action_properties [Hash, nil] Properties the quick reply action should have.
        # @return [HaveQuickReply] An instance of the matcher.
        #
        # @example
        #   expect(messages).to have_line_quick_reply(label: "Confirm", data: "action=confirm")
        #   expect(messages).to have_line_quick_reply # Checks for any quick reply
        def have_line_quick_reply(expected_action_properties = nil) # rubocop:disable Naming/PredicateName
          HaveQuickReply.new(expected_action_properties)
        end
      end
    end
  end
end
