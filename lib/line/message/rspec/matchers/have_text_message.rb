# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The text message matcher for RSpec to search for text messages in the message array.
        class HaveTextMessage
          def initialize(expected)
            @text, @options = expected
            @options = Utils.stringify_keys!(@options || {})
          end

          def description
            return "have text message" if @text.nil?
            return "have text message matching #{@text.inspect}" if @options.empty?

            "have text message matching #{@text.inspect} with options #{@options.inspect}"
          end

          def matches?(actual)
            @actual = Utils.stringify_keys!(actual, deep: true)
            @actual.any? do |message|
              next unless message["type"] == "text"
              next true if @text.nil?

              message["text"].match?(@text) && ::RSpec::Matchers::BuiltIn::Include.new(@options).matches?(message)
            end
          end
          alias == matches?

          def failure_message
            return "expected to find a text message" if @text.nil?
            return "expected to find a text message matching #{@text.inspect}" if @options.empty?

            "expected to find a text message matching #{@text.inspect} with options #{@options.inspect}"
          end
        end

        def have_line_text_message(*expected) # rubocop:disable Naming/PredicateName
          HaveTextMessage.new(expected)
        end
      end
    end
  end
end
