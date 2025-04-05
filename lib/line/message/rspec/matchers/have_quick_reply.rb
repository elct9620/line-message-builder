# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The quick reply matcher for RSpec to search for quick reply action in the message array.
        class HaveQuickReply
          def initialize(expected)
            @expected = expected
          end

          def description
            return "have quick reply action" if @expected.nil?

            "have quick reply action matching #{@expected}"
          end

          def matches?(actual)
            @actual = actual
            @actual.any? { |message| match_message(message) }
          end
          alias == matches?

          def failure_message
            "expected to find a quick reply message matching #{@expected}"
          end

          private

          def match_message(message)
            reply = message[:quickReply]
            return false unless reply

            reply[:items].any? { |item| match_action(item[:action]) }
          end

          def match_action(action)
            return true if @expected.nil?
            return true if ::RSpec::Matchers::BuiltIn::Include.new(@expected).matches?(action)

            false
          end
        end

        def have_line_quick_reply(expected = nil) # rubocop:disable Naming/PredicateName
          HaveQuickReply.new(expected)
        end
      end
    end
  end
end
