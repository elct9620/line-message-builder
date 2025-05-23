# frozen_string_literal: true

module Line
  module Message
    module RSpec
      module Matchers
        # The `HaveFlexComponent` matcher is a versatile RSpec matcher designed to
        # recursively search within a collection of LINE messages (typically an array of hashes)
        # for any Flex Message component that satisfies a given condition.
        # The condition is defined by a block passed to its constructor.
        #
        # This class forms the basis for more specific component matchers like
        # `have_line_flex_box`, `have_line_flex_text`, etc.
        #
        # @example Generic usage with a block
        #   # Check for any component that is a box with a specific layout
        #   expect(messages).to have_line_flex_component do |component|
        #     component["type"] == "box" && component["layout"] == "vertical"
        #   end
        #
        # Note: All hash keys in the message data are automatically stringified before comparison.
        class HaveFlexComponent
          # Initializes the generic component matcher.
          #
          # @param expected_desc [String, nil] An optional description of what the component
          #   is expected to be. Used in failure messages.
          # @param expected_block [Proc] A block that takes a component hash as an argument
          #   and returns `true` if the component matches the desired criteria, `false` otherwise.
          def initialize(expected_desc: nil, &expected_block)
            @expected_block = expected_block
            @expected_desc = expected_desc
          end

          # Provides a human-readable description of the matcher.
          # @return [String] The description.
          def description
            return "have flex component" if @expected_block.nil? && @expected_desc.nil?
            return "have flex component matching #{@expected_desc}" if @expected_desc

            "have flex component matching criteria" # Generic for block
          end

          # Checks if the `actual_messages` array contains any Flex Message component
          # that satisfies the `@expected_block`.
          #
          # @param actual_messages [Array<Hash>] An array of message hashes.
          # @return [Boolean] `true` if a matching component is found, `false` otherwise.
          def matches?(actual_messages)
            @actual = Utils.stringify_keys!(actual_messages, deep: true)
            @actual.any? { |message| find_component_in_message?(message) }
          end
          alias == matches? # Standard RSpec matcher alias

          # Provides a failure message.
          # @return [String] The failure message.
          def failure_message
            message = "expected to find a flex component"
            message += " matching #{@expected_desc}" if @expected_desc
            message += " matching criteria defined by the block" if @expected_block && !@expected_desc
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          # Provides a failure message for negation.
          # @return [String] The failure message for negation.
          def failure_message_when_negated
            message = "expected not to find a flex component"
            message += " matching #{@expected_desc}" if @expected_desc
            message += " matching criteria defined by the block" if @expected_block && !@expected_desc
            message += "\nActual messages: #{@actual.inspect}"
            message
          end

          private

          # Checks if a single message is a Flex Message and contains a matching component.
          # @param message [Hash] A single message hash.
          # @return [Boolean]
          def find_component_in_message?(message)
            return false unless message["type"] == "flex" && message["contents"]

            # Flex message `contents` can be a Bubble or a Carousel
            traverse_flex_structure(message["contents"])
          end

          # Recursively traverses the Flex Message structure (Bubbles, Carousels, Boxes)
          # applying the `@expected_block` to each component encountered.
          # @param element [Hash, Array] A part of the Flex Message structure.
          # @return [Boolean] `true` if the block returns true for any component.
          def traverse_flex_structure(element)
            # If the current element itself matches the criteria (block returns true)
            return true if @expected_block.call(element)

            # If element is a Hash (like a Box, Bubble, or other component)
            if element.is_a?(Hash)
              # If it's a Bubble, check its sections (header, hero, body, footer)
              if element["type"] == "bubble"
                return %w[header hero body footer].any? do |section_key|
                  section_content = element[section_key]
                  section_content && traverse_flex_structure(section_content)
                end
              end

              # For any component that can have 'contents' (like Box, Carousel)
              # Note: Carousel `contents` is an array of Bubbles.
              # Box `contents` is an array of other components.
              if element["contents"].is_a?(Array)
                return element["contents"].any? { |nested_element| traverse_flex_structure(nested_element) }
              elsif element["contents"].is_a?(Hash) # Should not happen often for 'contents', but to be safe
                return traverse_flex_structure(element["contents"])
              end
            end

            # If element is an Array (like the `contents` of a Box or Carousel)
            return element.any? { |item| traverse_flex_structure(item) } if element.is_a?(Array)

            false # No match found in this path
          end
        end

        # RSpec shorthand helper for the generic {HaveFlexComponent} matcher.
        # Use this when you need custom logic to find a component.
        #
        # @param block [Proc] A block that evaluates a component hash.
        # @return [HaveFlexComponent] An instance of the matcher.
        #
        # @example
        #   expect(messages).to have_line_flex_component do |component|
        #     component["type"] == "text" && component["text"].include?("Urgent")
        #   end
        def have_line_flex_component(&block) # rubocop:disable Naming/PredicateName
          HaveFlexComponent.new(&block)
        end

        # RSpec matcher to find a Flex Box component with specified properties.
        #
        # @param options [Hash] A hash of properties the Box component should include.
        #   Keys are automatically stringified. (e.g., `layout: "vertical"`)
        # @return [HaveFlexComponent] An instance of the matcher configured for Boxes.
        #
        # @example
        #   expect(messages).to have_line_flex_box(layout: "horizontal", spacing: "md")
        def have_line_flex_box(**options) # rubocop:disable Naming/PredicateName
          expected_properties = Utils.stringify_keys!(options, deep: true)
          desc = "box with properties #{expected_properties.inspect}"

          HaveFlexComponent.new(expected_desc: desc) do |component|
            next false unless component["type"] == "box"
            ::RSpec::Matchers::BuiltIn::Include.new(expected_properties).matches?(component)
          end
        end

        # RSpec matcher to find a Flex Text component with specified text and properties.
        #
        # @param text_content [String, Regexp] The text the component should have. Can be a string or regex.
        # @param options [Hash] Additional properties the Text component should include.
        #   (e.g., `size: "lg"`, `color: "#FF0000"`)
        # @return [HaveFlexComponent] An instance of the matcher configured for Text components.
        #
        # @example
        #   expect(messages).to have_line_flex_text("Welcome!", size: "xl")
        #   expect(messages).to have_line_flex_text(/Order confirmed/i)
        def have_line_flex_text(text_content, **options) # rubocop:disable Naming/PredicateName
          expected_properties = Utils.stringify_keys!(options, deep: true)
          desc = "text component with text matching #{text_content.inspect} and properties #{expected_properties.inspect}"

          HaveFlexComponent.new(expected_desc: desc) do |component|
            next false unless component["type"] == "text"
            text_matches = text_content.is_a?(Regexp) ? component["text"]&.match?(text_content) : component["text"] == text_content
            text_matches && ::RSpec::Matchers::BuiltIn::Include.new(expected_properties).matches?(component)
          end
        end

        # RSpec matcher to find a Flex Button component with a specific action type and properties.
        #
        # @param action_type [String, Symbol] The type of action the button should have (e.g., "uri", "postback", "message").
        # @param options [Hash] Additional properties the Button component itself or its action should include.
        #   If a key matches a button property (e.g. `style`, `height`), it's matched against the button.
        #   Other properties are assumed to belong to the action object.
        # @return [HaveFlexComponent] An instance of the matcher configured for Button components.
        #
        # @example
        #   expect(messages).to have_line_flex_button(:uri, label: "Details", uri: "https://example.com")
        #   expect(messages).to have_line_flex_button("postback", data: "action=buy")
        #   expect(messages).to have_line_flex_button(:message, text: "Hello", style: "primary")
        def have_line_flex_button(action_type, **options) # rubocop:disable Naming/PredicateName
          expected_properties = Utils.stringify_keys!(options, deep: true)
          stringified_action_type = action_type.to_s
          desc = "button component with action type '#{stringified_action_type}' and properties #{expected_properties.inspect}"

          # Separate button properties from action properties
          button_props = expected_properties.slice("style", "height", "gravity", "margin", "flex", "adjustMode", "color")
          action_props = expected_properties.except(*button_props.keys)
          action_props["type"] = stringified_action_type # Action must have the specified type

          HaveFlexComponent.new(expected_desc: desc) do |component|
            next false unless component.is_a?(Hash) && component["type"] == "button" && component["action"].is_a?(Hash)

            button_match = button_props.empty? || ::RSpec::Matchers::BuiltIn::Include.new(button_props).matches?(component)
            action_match = ::RSpec::Matchers::BuiltIn::Include.new(action_props).matches?(component["action"])

            button_match && action_match
          end
        end

        # RSpec matcher to find a Flex Image component with a specific URL and properties.
        #
        # @param url [String, Regexp] The URL the image should have. Can be a string or regex.
        # @param options [Hash] Additional properties the Image component should include.
        #   (e.g., `size: "full"`, `aspectRatio: "16:9"`)
        # @return [HaveFlexComponent] An instance of the matcher configured for Image components.
        #
        # @example
        #   expect(messages).to have_line_flex_image("https://example.com/image.png", size: "md")
        #   expect(messages).to have_line_flex_image(/logo\.png/i, aspectRatio: "1:1")
        def have_line_flex_image(url, **options) # rubocop:disable Naming/PredicateName
          expected_properties = Utils.stringify_keys!(options, deep: true)
          desc = "image component with URL matching #{url.inspect} and properties #{expected_properties.inspect}"

          HaveFlexComponent.new(expected_desc: desc) do |component|
            next false unless component["type"] == "image"
            url_matches = url.is_a?(Regexp) ? component["url"]&.match?(url) : component["url"] == url
            url_matches && ::RSpec::Matchers::BuiltIn::Include.new(expected_properties).matches?(component)
          end
        end
      end
    end
  end
end
