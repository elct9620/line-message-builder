# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The flex message matcher for RSpec to search for flex messages in the message array.
        class HaveFlexMessage
          def initialize(expected)
            @expected = expected
          end

          def description
            return "have flex message" if @expected.nil?

            "have flex message alt text matching #{@expected.inspect}"
          end

          def matches?(actual)
            @actual = Utils.stringify_keys!(actual, deep: true)
            @actual.any? { |message| match_alt_text?(message) }
          end
          alias == matches?

          def failure_message
            "expected to find a flex message alt text matching #{@expected}"
          end

          private

          def match_alt_text?(message)
            return false unless message["type"] == "flex"
            return true if @expected.nil?

            message["altText"].match?(@expected)
          end
        end

        def have_line_flex_message(expected = nil) # rubocop:disable Naming/PredicatePrefix
          HaveFlexMessage.new(expected)
        end
      end
    end
  end
end
