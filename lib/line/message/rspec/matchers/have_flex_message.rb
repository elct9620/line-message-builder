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
            @actual = actual
            @actual.any? { |message| match_alt_text?(message) }
          end

          def failure_message
            "expected to find a flex message alt text matching #{@expected}"
          end

          private

          def match_alt_text?(message)
            return false unless message[:type] == "flex"
            return true if @expected.nil?

            message[:altText].match?(@expected)
          end
        end

        def have_line_flex_message(expected = nil) # rubocop:disable Naming/PredicateName
          HaveFlexMessage.new(expected)
        end

        module_function

        def in_content?(container, &)
          return in_bubble?(container, &) if container[:type] == "bubble"
          return yield(container) unless container[:contents]

          container[:contents].each do |content|
            return true if content[:contents] && in_content?(content, &)
            return true if yield(content)
          end

          false
        end

        def in_bubble?(container, &) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          return true if container[:header] && in_content?(container[:header], &)
          return true if container[:hero] && in_content?(container[:hero], &)
          return true if container[:footer] && in_content?(container[:footer], &)
          return true if container[:body] && in_content?(container[:body], &)

          false
        end
      end
    end
  end
end

RSpec::Matchers.define :have_line_flex_text do |text|
  match do |actual|
    actual.each do |message|
      next unless message[:type] == "flex"

      next unless message[:contents]

      message[:contents].each do |content|
        is_found = Line::Message::RSpec::Matchers.in_content?(content) do |component|
          next false unless component[:type] == "text"

          component[:text] =~ text
        end

        return true if is_found
      end
    end

    false
  end

  failure_message do |_actual|
    "expected to find a flex text matching #{text}"
  end
end

RSpec::Matchers.define :have_line_flex_button do |type, **args|
  match do |actual|
    actual.each do |message|
      next unless message[:type] == "flex"

      next unless message[:contents]

      message[:contents].each do |content|
        is_found = Line::Message::RSpec::Matchers.in_content?(content) do |component|
          next false unless component[:type] == "button"

          RSpec::Matchers::BuiltIn::Include.new({ type: type, **args }).matches?(component[:action])
        end

        return true if is_found
      end
    end

    false
  end

  failure_message do |_actual|
    "expected to find a flex #{type} button matching #{args}"
  end
end

RSpec::Matchers.define :have_line_flex_image do |url, **args|
  match do |actual|
    actual.each do |message|
      next unless message[:type] == "flex"
      next unless message[:contents]

      message[:contents].each do |content|
        is_found = Line::Message::RSpec::Matchers.in_content?(content) do |component|
          next false unless component[:type] == "image"

          RSpec::Matchers::BuiltIn::Include.new({ url: url, **args }).matches?(component)
        end

        return true if is_found
      end
    end

    false
  end

  failure_message do |_actual|
    "expected to find a flex image matching #{url}"
  end
end
