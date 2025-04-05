# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The text message matcher for RSpec to search for text messages in the message array.
        class HaveTextMessage
          def initialize(expected)
            @expected = expected
          end

          def description
            return "have text message" if @expected.nil?

            "have text message matching #{@expected.inspect}"
          end

          def matches?(actual)
            @actual = actual
            @actual.each do |message|
              next unless message[:type] == "text"

              return true if message[:text].match?(@expected)
            end

            false
          end

          def failure_message
            "expected to find a text message matching #{@expected}"
          end
        end

        def have_line_text_message(expected = nil) # rubocop:disable Naming/PredicateName
          HaveTextMessage.new(expected)
        end
      end
    end
  end
end
