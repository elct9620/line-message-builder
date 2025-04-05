# frozen_string_literal: true

module Line
  module Message
    module RSpec
      # :nodoc:
      module Matchers
        # The flex component matcher for RSpec to search nested flex components in the message array.
        class HaveFlexComponent
          def initialize(expected_desc: nil, &expected)
            @expected = expected
            @expected_desc = expected_desc
          end

          def description
            return "have flex component" if @expected.nil?
            return "have flex component matching #{@expected_desc}" if @expected_desc

            "have flex component matching #{@expected.inspect}"
          end

          def matches?(actual)
            @actual = actual
            @actual.any? { |message| match_flex_component?(message) }
          end

          def failure_message
            return "expected to find a flex component" if @expected.nil?
            return "expected to find a flex component matching #{@expected_desc}" if @expected_desc

            "expected to find a flex component matching #{@expected.inspect}"
          end

          private

          def match_flex_component?(message)
            return false unless message[:type] == "flex"

            message[:contents].any? { |content| match_content?(content) }
          end

          def match_content?(content)
            return match_bubble?(content) if content[:type] == "bubble"

            if content[:contents]
              return content[:contents].any? do |nested_content|
                match_content?(nested_content)
              end || @expected.call(content)
            end

            @expected.call(content)
          end

          def match_bubble?(content)
            %i[header hero body footer].any? do |key|
              block = content[key]
              next unless block

              match_bubble_block?(block)
            end
          end

          def match_bubble_block?(block)
            return block[:contents].any? { |nested_content| match_content?(nested_content) } if block[:contents]

            match_content?(block)
          end
        end

        def have_line_flex_component(&) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(&)
        end

        def have_line_flex_box(**args) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(expected_desc: "box(#{args.inspect})") do |content|
            next false unless content[:type] == "box"

            ::RSpec::Matchers::BuiltIn::Include.new(args).matches?(content)
          end
        end

        def have_line_flex_text(text) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(expected_desc: "text(#{text.inspect})") do |content|
            content[:type] == "text" && content[:text].match?(text)
          end
        end

        def have_line_flex_button(type, **args) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(expected_desc: "#{type} button(#{args.inspect})") do |content|
            next false unless content[:type] == "button"

            ::RSpec::Matchers::BuiltIn::Include.new({ type: type, **args }).matches?(content[:action]) ||
              ::RSpec::Matchers::BuiltIn::Include.new({ **args, action: ::RSpec::Matchers::BuiltIn::Include.new(
                type: type
              ) }).matches?(content)
          end
        end

        def have_line_flex_image(url, **args) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(expected_desc: "image(#{url.inspect})") do |content|
            next false unless content[:type] == "image"

            ::RSpec::Matchers::BuiltIn::Include.new({ url: url, **args }).matches?(content)
          end
        end
      end
    end
  end
end
