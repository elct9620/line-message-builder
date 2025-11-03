# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The flex component matcher for RSpec to search nested flex components in the message array.
        class HaveFlexBubble
          def initialize(expected)
            @expected = Utils.stringify_keys!(expected || {}, deep: true)
          end

          def description
            return "have flex bubble" if @expected.empty?

            "have flex bubble matching #{@expected.inspect}"
          end

          def matches?(actual)
            @actual = Utils.stringify_keys!(actual, deep: true)
            @actual.any? { |message| match_flex_component?(message) }
          end
          alias == matches?

          def failure_message
            return "expected to find a flex bubble" if @expected.empty?

            "expected to find a flex bubble matching #{@expected.inspect}"
          end

          private

          def match_flex_component?(message)
            return false unless message["type"] == "flex"

            match_content?(message["contents"])
          end

          def match_content?(content)
            return match_options?(content) if content["type"] == "bubble"
            return false unless content["contents"]

            content["contents"].any? { |nested_content| match_content?(nested_content) }
          end

          def match_options?(content)
            return false unless content["type"] == "bubble"

            ::RSpec::Matchers::BuiltIn::Include.new(@expected).matches?(content)
          end
        end

        def have_line_flex_bubble(expected = nil) # rubocop:disable Naming/PredicatePrefix
          HaveFlexBubble.new(expected)
        end
      end
    end
  end
end
