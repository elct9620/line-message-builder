# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The flex separator matcher for RSpec to search for separator components in flex messages.
        class HaveFlexSeparator
          def initialize(options = {})
            @options = Utils.stringify_keys!(options || {})
          end

          def description
            return "have flex separator" if @options.empty?

            "have flex separator with options #{@options.inspect}"
          end

          def matches?(actual)
            @actual = Utils.stringify_keys!(actual, deep: true)

            # Find a flex message first
            flex_message = @actual.find { |message| message["type"] == "flex" }
            return false unless flex_message

            # Navigate through the contents to find a separator
            contents = flex_message.dig("contents", "body", "contents") ||
                       flex_message.dig("contents", "hero", "contents") ||
                       flex_message.dig("contents", "footer", "contents") ||
                       flex_message.dig("contents", "header", "contents") ||
                       []
            find_separator_in_contents(contents)
          end
          alias == matches?

          def failure_message
            return "expected to find a flex separator" if @options.empty?

            "expected to find a flex separator with options #{@options.inspect}"
          end

          private

          def find_separator_in_contents(contents)
            return false unless contents.is_a?(Array)

            contents.any? do |component|
              if component["type"] == "separator"
                return true if @options.empty?

                return ::RSpec::Matchers::BuiltIn::Include.new(@options).matches?(component)
              elsif component["type"] == "box" && component["contents"].is_a?(Array)
                result = find_separator_in_contents(component["contents"])
                return true if result
              end
              false
            end
          end
        end

        def have_line_flex_separator(options = {}) # rubocop:disable Naming/PredicateName
          HaveFlexSeparator.new(options)
        end
      end
    end
  end
end
